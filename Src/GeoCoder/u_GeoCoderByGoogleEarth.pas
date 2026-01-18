{******************************************************************************}
{* This file is part of SAS.Planet project.                                   *}
{*                                                                            *}
{* Copyright (C) 2007-Present, SAS.Planet development team.                   *}
{*                                                                            *}
{* SAS.Planet is free software: you can redistribute it and/or modify         *}
{* it under the terms of the GNU General Public License as published by       *}
{* the Free Software Foundation, either version 3 of the License, or          *}
{* (at your option) any later version.                                        *}
{*                                                                            *}
{* SAS.Planet is distributed in the hope that it will be useful,              *}
{* but WITHOUT ANY WARRANTY; without even the implied warranty of             *}
{* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the               *}
{* GNU General Public License for more details.                               *}
{*                                                                            *}
{* You should have received a copy of the GNU General Public License          *}
{* along with SAS.Planet. If not, see <http://www.gnu.org/licenses/>.         *}
{*                                                                            *}
{* https://github.com/sasgis/sas.planet.src                                   *}
{******************************************************************************}

unit u_GeoCoderByGoogleEarth;

interface

uses
  Classes,
  i_GeoCoder,
  i_InetConfig,
  i_InterfaceListSimple,
  i_NotifierOperation,
  i_LocalCoordConverter,
  i_DownloadRequest,
  i_DownloadResult,
  u_GeoCoderBasic;

type
  TGeoCoderByGoogleEarth = class(TGeoCoderBasic)
  private
    procedure ParseXmlContent(
      const AXmlContent: string;
      const AResult: IInterfaceListSimple
    );
  protected
    function PrepareRequest(
      const ASearch: string;
      const ALocalConverter: ILocalCoordConverter
    ): IDownloadRequest; override;

    function ParseResultToPlacemarksList(
      const ACancelNotifier: INotifierOperation;
      AOperationID: Integer;
      const AResult: IDownloadResultOk;
      const ASearch: string;
      const ALocalConverter: ILocalCoordConverter
    ): IInterfaceListSimple; override;
  end;

implementation

uses
  ActiveX,
  SysUtils,
  XMLDoc,
  XMLIntf,
  t_GeoTypes,
  i_VectorDataItemSimple,
  i_Projection,
  u_DownloadRequest,
  u_InterfaceListSimple,
  u_ResStrings,
  u_GeoToStrFunc;

{ TGeoCoderByGoogleEarth }

function TGeoCoderByGoogleEarth.PrepareRequest(
  const ASearch: string;
  const ALocalConverter: ILocalCoordConverter
): IDownloadRequest;
const
  CUserAgent: AnsiString =
    'GoogleEarth/7.3.6.10441(Windows;Microsoft Windows (6.2.9200.0);en;kml:2.2;client:Pro;type:default)';
var
  VUrl, VHeaders: AnsiString;
  VProjection: IProjection;
  VMapRect: TDoubleRect;
  VLonLatRect: TDoubleRect;
begin
  VProjection := ALocalConverter.Projection;
  VMapRect := ALocalConverter.GetRectInMapPixelFloat;
  VProjection.ValidatePixelRectFloat(VMapRect);
  VLonLatRect := VProjection.PixelRectFloat2LonLatRect(VMapRect);

  VUrl :=
    'https://www.google.com/earth/rpc/search?q=?' +
    Self.URLEncode(AnsiToUtf8(ASearch)) +
    '&ie=utf-8' +
    AnsiString(SAS_STR_GoogleSearchLanguage) + // &hl=en
    '&sll=' + RoundExAnsi(ALocalConverter.GetCenterLonLat.X, 4) + ',' + RoundExAnsi(ALocalConverter.GetCenterLonLat.Y, 4) +
    '&sspn=' + RoundExAnsi(VLonLatRect.Right - VLonLatRect.Left, 6) + ',' + RoundExAnsi(VLonLatRect.Top - VLonLatRect.Bottom, 6) +
    '&output=xml' +
    '&prune=earth' +
    '&oe=utf8' +
    '&useragent=' + Self.URLEncode(CUserAgent);

  VHeaders := 'User-Agent: ' + CUserAgent;

  Result := TDownloadRequest.Create(VUrl, VHeaders, Self.InetSettings.GetStatic);
end;

function TGeoCoderByGoogleEarth.ParseResultToPlacemarksList(
  const ACancelNotifier: INotifierOperation;
  AOperationID: Integer;
  const AResult: IDownloadResultOk;
  const ASearch: string;
  const ALocalConverter: ILocalCoordConverter
): IInterfaceListSimple;
var
  VTmpBuf: UTF8String;
begin
  if (AResult = nil) or (AResult.Data = nil) or (AResult.Data.Size <= 0) then begin
    raise EParserError.Create(SAS_ERR_EmptyServerResponse);
  end;

  Result := TInterfaceListSimple.Create;

  SetLength(VTmpBuf, AResult.Data.Size);
  Move(AResult.Data.Buffer^, VTmpBuf[1], AResult.Data.Size);

  CoInitialize(nil);
  try
    ParseXmlContent(UTF8ToString(VTmpBuf), Result);
  finally
    CoUninitialize;
  end;
end;

procedure TGeoCoderByGoogleEarth.ParseXmlContent(
  const AXmlContent: string;
  const AResult: IInterfaceListSimple
);
var
  VPlaceCards: array of IXMLNode;

  procedure CollectPlaceCards(const ANode: IXMLNode);
  var
    I: Integer;
  begin
    if ANode = nil then begin
      Exit;
    end;

    if ANode.NodeName = 'place_card' then begin
      SetLength(VPlaceCards, Length(VPlaceCards) + 1);
      VPlaceCards[High(VPlaceCards)] := ANode;
      Exit;
    end;

    for I := 0 to ANode.ChildNodes.Count - 1 do begin
      CollectPlaceCards(ANode.ChildNodes[I]); // recursion
    end;
  end;

var
  I: Integer;
  VName, VDesc: string;
  VPoint: TDoublePoint;
  VXmlDoc: IXMLDocument;
  VNode, VLatLng, VTitleNode, VDescNode: IXMLNode;
  VPlace: IVectorDataItem;
begin
  if AXmlContent = '' then begin
    Exit;
  end;

  VXmlDoc := TXMLDocument.Create(nil);
  VXmlDoc.LoadFromXML(AXmlContent);
  VXmlDoc.Active := True;

  SetLength(VPlaceCards, 0);
  CollectPlaceCards(VXmlDoc.DocumentElement);

  for I := 0 to High(VPlaceCards) do begin
    VName := '';
    VDesc := '';

    VNode := VPlaceCards[I];

    // lat/lng
    VLatLng := VNode.ChildNodes.FindNode('lat_lng');
    if not Assigned(VLatLng) or
       not TryStrPointToFloat(VLatLng.Attributes['lng'], VPoint.X) or
       not TryStrPointToFloat(VLatLng.Attributes['lat'], VPoint.Y)
    then begin
      Continue;
    end;

    // title
    VTitleNode := VNode.ChildNodes.FindNode('title');
    if Assigned(VTitleNode) then begin
      VName := VTitleNode.Text;
    end;

    // description
    VDescNode := VNode.ChildNodes.FindNode('name_and_address');
    if Assigned(VDescNode) then begin
      VDesc := VDescNode.Text;
    end else begin
      VDescNode := VNode.ChildNodes.FindNode('address_line');
      if Assigned(VDescNode) then begin
        VDesc := VDescNode.Text;
      end;
    end;

    VPlace := PlacemarkFactory.Build(VPoint, Trim(VName), Trim(VDesc), '', 4);
    AResult.Add(VPlace);
  end;
end;

end.
