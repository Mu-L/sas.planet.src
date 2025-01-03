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

unit i_BitmapTileMatrix;

interface

uses
  Types,
  t_Hash,
  i_TileRect,
  i_Bitmap32Static;

type
  IBitmapTileMatrix = interface
    ['{A135B6B8-0B5A-45BA-B126-BFE959977731}']
    function GetHash: THashValue;
    property Hash: THashValue read GetHash;

    function GetTileRect: ITileRect;
    property TileRect: ITileRect read GetTileRect;

    function GetElementByTile(const ATile: TPoint): IBitmap32Static;

    function GetItem(AX, AY: Integer): IBitmap32Static;
    property Items[AX, AY: Integer]: IBitmap32Static read GetItem;
  end;

implementation

end.
