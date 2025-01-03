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

unit u_RegionProcessTaskAbstract;

interface

uses
  Math,
  i_GeometryLonLat,
  i_Projection,
  i_TileIterator,
  i_TileIteratorFactory,
  i_NotifierOperation,
  i_RegionProcessTask,
  i_RegionProcessProgressInfo,
  u_BaseInterfacedObject;

type
  TRegionProcessTaskAbstract = class(TBaseInterfacedObject, IRegionProcessTask)
  private
    FCancelNotifier: INotifierOperation;
    FOperationID: Integer;
    FProgressInfo: IRegionProcessProgressInfoInternal;
    FLonLatPolygon: IGeometryLonLatPolygon;
    FTileIteratorFactory: ITileIteratorFactory;
  protected
    function MakeTileIterator(const AProjection: IProjection): ITileIterator;

    procedure ProgressFormUpdateOnProgress(AProcessed, AToProcess: Int64);
    procedure ProcessRegion; virtual; abstract;

    property CancelNotifier: INotifierOperation read FCancelNotifier;
    property OperationID: Integer read FOperationID;

    property ProgressInfo: IRegionProcessProgressInfoInternal read FProgressInfo;
    property PolygLL: IGeometryLonLatPolygon read FLonLatPolygon;
  public
    constructor Create(
      const AProgressInfo: IRegionProcessProgressInfoInternal;
      const APolygon: IGeometryLonLatPolygon;
      const ATileIteratorFactory: ITileIteratorFactory
    );
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils,
  u_ResStrings;

{ TRegionProcessTaskAbstract }

constructor TRegionProcessTaskAbstract.Create(
  const AProgressInfo: IRegionProcessProgressInfoInternal;
  const APolygon: IGeometryLonLatPolygon;
  const ATileIteratorFactory: ITileIteratorFactory
);
begin
  inherited Create;
  FCancelNotifier := AProgressInfo.CancelNotifier;
  FOperationID := AProgressInfo.OperationID;
  FProgressInfo := AProgressInfo;
  FLonLatPolygon := APolygon;
  FTileIteratorFactory := ATileIteratorFactory;
end;

destructor TRegionProcessTaskAbstract.Destroy;
begin
  if Assigned(FProgressInfo) then begin
    FProgressInfo.Finish;
    FProgressInfo := nil;
  end;
  inherited;
end;

function TRegionProcessTaskAbstract.MakeTileIterator(
  const AProjection: IProjection
): ITileIterator;
begin
  Assert(FTileIteratorFactory <> nil);
  Result := FTileIteratorFactory.MakeTileIterator(AProjection, FLonLatPolygon);
end;

procedure TRegionProcessTaskAbstract.ProgressFormUpdateOnProgress(
  AProcessed, AToProcess: Int64
);
var
  VRatio: Double;
begin
  VRatio := IfThen(AToProcess > 0, AProcessed / AToProcess);
  ProgressInfo.SetProcessedRatio(VRatio);
  ProgressInfo.SetSecondLine(SAS_STR_Processed + ' ' + IntToStr(AProcessed));
end;

end.

