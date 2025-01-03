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

unit u_TileIteratorFactory;

interface

uses
  i_Projection,
  i_TileIterator,
  i_TileIteratorFactory,
  i_GeometryLonLat,
  i_GeometryProjectedFactory,
  u_BaseInterfacedObject;

type
  TTileIteratorFactory = class(TBaseInterfacedObject, ITileIteratorFactory)
  private
    FGeometryProjectedFactory: IGeometryProjectedFactory;
  private
    { ITileIteratorFactory }
    function MakeTileIterator(
      const AProjection: IProjection;
      const ALonLatPolygon: IGeometryLonLatPolygon;
      const ATilesToProcess: Int64 = -1;
      const AStartPointX: Integer = -1;
      const AStartPointY: Integer = -1
    ): ITileIterator;
  public
    constructor Create(
      const AGeometryProjectedFactory: IGeometryProjectedFactory
    );
  end;

implementation

uses
  i_TileRect,
  i_GeometryProjected,
  u_GeometryFunc,
  u_TileIteratorByRect,
  u_TileIteratorByPolygon;

{ TTileIteratorFactory }

constructor TTileIteratorFactory.Create(
  const AGeometryProjectedFactory: IGeometryProjectedFactory
);
begin
  Assert(AGeometryProjectedFactory <> nil);
  inherited Create;

  FGeometryProjectedFactory := AGeometryProjectedFactory;
end;

function TTileIteratorFactory.MakeTileIterator(
  const AProjection: IProjection;
  const ALonLatPolygon: IGeometryLonLatPolygon;
  const ATilesToProcess: Int64;
  const AStartPointX: Integer;
  const AStartPointY: Integer
): ITileIterator;
var
  VTileRect: ITileRect;
  VProjected: IGeometryProjectedPolygon;
begin
  VProjected :=
    FGeometryProjectedFactory.CreateProjectedPolygonByLonLatPolygon(
      AProjection,
      ALonLatPolygon
    );

  VTileRect := TryProjectedPolygonToTileRect(AProjection, VProjected);

  if VTileRect <> nil then begin
    Result :=
      TTileIteratorByRect.Create(
        VTileRect,
        ATilesToProcess,
        AStartPointX,
        AStartPointY
      );
  end else begin
    Result :=
      TTileIteratorByPolygon.Create(
        AProjection,
        VProjected,
        ATilesToProcess,
        AStartPointX,
        AStartPointY
      );
  end;
end;

end.
