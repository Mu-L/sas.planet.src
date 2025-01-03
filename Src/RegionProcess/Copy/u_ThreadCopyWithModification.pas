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

unit u_ThreadCopyWithModification;

interface

uses
  Types,
  i_MapVersionInfo,
  i_TileStorage,
  i_GeometryLonLat,
  i_TileIteratorFactory,
  i_RegionProcessProgressInfo,
  i_ContentTypeInfo,
  i_BitmapTileSaveLoad,
  i_BitmapTileProvider,
  i_MapType,
  u_ExportTaskAbstract;

type
  TThreadCopyWithModification = class(TExportTaskAbstract)
  private
    FTarget: ITileStorage;
    FTargetVersionInfo: IMapVersionInfo;
    FSource: IMapType;
    FLayer: IMapType;
    FBitmapTileProviderArr: TBitmapTileProviderDynArray;
    FBitmapTileSaver: IBitmapTileSaver;
    FContentType: IContentTypeInfoBasic;
    FIsOverwriteDestTiles: Boolean;
    FIsProcessTne: Boolean;
  protected
    procedure ProcessRegion; override;
  public
    constructor Create(
      const AProgressInfo: IRegionProcessProgressInfoInternal;
      const ATileIteratorFactory: ITileIteratorFactory;
      const APolygon: IGeometryLonLatPolygon;
      const ATarget: ITileStorage;
      const ATargetVersionForce: IMapVersionInfo;
      const ASource: IMapType;
      const ALayer: IMapType;
      const ABitmapTileProviderArr: TBitmapTileProviderDynArray;
      const ABitmapTileSaver: IBitmapTileSaver;
      const AZoomArr: TByteDynArray;
      const AContentType: IContentTypeInfoBasic;
      const AIsProcessTne: Boolean;
      const AIsOverwriteDestTiles: Boolean
    );
  end;

implementation

uses
  SysUtils,
  i_TileIterator,
  i_Bitmap32Static,
  i_BinaryData,
  i_ProjectionSet,
  i_Projection,
  u_ZoomArrayFunc,
  u_ResStrings;

{ TThreadCopyWithModification }

constructor TThreadCopyWithModification.Create(
  const AProgressInfo: IRegionProcessProgressInfoInternal;
  const ATileIteratorFactory: ITileIteratorFactory;
  const APolygon: IGeometryLonLatPolygon;
  const ATarget: ITileStorage;
  const ATargetVersionForce: IMapVersionInfo;
  const ASource: IMapType;
  const ALayer: IMapType;
  const ABitmapTileProviderArr: TBitmapTileProviderDynArray;
  const ABitmapTileSaver: IBitmapTileSaver;
  const AZoomArr: TByteDynArray;
  const AContentType: IContentTypeInfoBasic;
  const AIsProcessTne: Boolean;
  const AIsOverwriteDestTiles: Boolean
);
begin
  Assert(Length(AZoomArr) = Length(ABitmapTileProviderArr));

  inherited Create(
    AProgressInfo,
    APolygon,
    AZoomArr,
    ATileIteratorFactory
  );

  FIsProcessTne := AIsProcessTne;
  FSource := ASource;
  FLayer := ALayer;

  FTarget := ATarget;
  FTargetVersionInfo := ATargetVersionForce;
  FBitmapTileProviderArr := ABitmapTileProviderArr;
  FBitmapTileSaver := ABitmapTileSaver;
  FContentType := AContentType;
  FIsOverwriteDestTiles := AIsOverwriteDestTiles;
end;

procedure TThreadCopyWithModification.ProcessRegion;

  procedure ProcessTile(
    const AProvider: IBitmapTileProvider;
    const ATile: TPoint;
    const AZoom: Byte;
    const ALoadDate: TDateTime
  );
  var
    VBitmapTile: IBitmap32Static;
    VTileData: IBinaryData;
  begin
    VBitmapTile :=
      AProvider.GetTile(
        Self.OperationID,
        Self.CancelNotifier,
        ATile
      );
    if Assigned(VBitmapTile) then begin
      VTileData := FBitmapTileSaver.Save(VBitmapTile);
      FTarget.SaveTile(
        ATile,
        AZoom,
        FTargetVersionInfo,
        ALoadDate,
        FContentType,
        VTileData,
        FIsOverwriteDestTiles
      );
    end;
  end;

var
  VTilesToProcess: Int64;
  VTilesProcessed: Int64;
  VTileIterators: array of ITileIterator;
  I: Integer;
  VZoom: Byte;
  VProjectionSet: IProjectionSet;
  VProjection: IProjection;
  VTileIterator: ITileIterator;
  VTile: TPoint;
begin
  inherited;

  VTilesToProcess := 0;
  VTilesProcessed := 0;

  SetLength(VTileIterators, Length(FZooms));
  for I := 0 to Length(FZooms) - 1 do begin
    VZoom := FZooms[I];
    VProjectionSet := FTarget.ProjectionSet;
    VProjection := VProjectionSet.Zooms[VZoom];
    VTileIterators[I] := Self.MakeTileIterator(VProjection);
    Inc(VTilesToProcess, VTileIterators[I].TilesTotal);
  end;

  ProgressInfo.SetCaption(SAS_STR_ExportTiles + ' ' + ZoomArrayToStr(FZooms));
  ProgressInfo.SetFirstLine(
    SAS_STR_AllSaves + ' ' + IntToStr(VTilesToProcess) + ' ' + SAS_STR_Files
  );
  ProgressFormUpdateOnProgress(VTilesProcessed, VTilesToProcess);

  for I := 0 to Length(FZooms) - 1 do begin
    VTileIterator := VTileIterators[I];
    while VTileIterator.Next(VTile) do begin
      if CancelNotifier.IsOperationCanceled(OperationID) then begin
        Exit;
      end;

      ProcessTile(FBitmapTileProviderArr[I], VTile, FZooms[I], Now);

      Inc(VTilesProcessed);
      if VTilesProcessed mod 100 = 0 then begin
        ProgressFormUpdateOnProgress(VTilesProcessed, VTilesToProcess);
      end;
    end;
  end;
end;

end.
