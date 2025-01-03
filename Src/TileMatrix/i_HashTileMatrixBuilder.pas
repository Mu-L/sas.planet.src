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

unit i_HashTileMatrixBuilder;

interface

uses
  Types,
  t_Hash,
  i_TileRect,
  i_HashTileMatrix;

type
  IHashTileMatrixBuilder = interface
    ['{805E09A4-7B44-4FFF-BC78-B4D3BBE27990}']
    function GetTileRect: ITileRect;
    property TileRect: ITileRect read GetTileRect;

    function GetTile(const ATile: TPoint): THashValue;
    procedure SetTile(
      const ATile: TPoint;
      const AValue: THashValue
    );
    property Tiles[const ATile: TPoint]: THashValue read GetTile write SetTile;

    procedure Reset(const AValue: THashValue);
    procedure SetRectWithReset(
      const ATileRect: ITileRect;
      const AValue: THashValue
    );
    procedure SetRect(
      const ATileRect: ITileRect;
      const AValue: THashValue
    );

    function MakeStatic: IHashTileMatrix;
  end;

implementation

end.
