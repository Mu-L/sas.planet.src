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

unit i_TileObjCache;

interface

uses
  Types,
  i_Bitmap32Static,
  i_VectorItemSubset;

type
  ITileObjCacheVector = interface
    ['{B52B38D1-C57C-424C-B85B-AC623A54E7B5}']
    procedure Clear;
    procedure DeleteTileFromCache(
      const AXY: TPoint;
      const AZoom: Byte
    );
    procedure DeleteTileRectFromCache(
      const ARect: TRect;
      const AZoom: Byte
    );
    procedure AddTileToCache(
      const AObj: IVectorItemSubset;
      const AXY: TPoint;
      const AZoom: Byte
    );
    function TryLoadTileFromCache(
      const AXY: TPoint;
      const AZoom: Byte
    ): IVectorItemSubset;
  end;

  ITileObjCacheBitmap = interface
    ['{B52B38D1-C57C-424C-B85B-AC623A54E7B5}']
    procedure Clear;
    procedure DeleteTileFromCache(
      const AXY: TPoint;
      const AZoom: Byte
    );
    procedure DeleteTileRectFromCache(
      const ARect: TRect;
      const AZoom: Byte
    );
    procedure AddTileToCache(
      const AObj: IBitmap32Static;
      const AXY: TPoint;
      const AZoom: Byte
    );
    function TryLoadTileFromCache(
      const AXY: TPoint;
      const AZoom: Byte
    ): IBitmap32Static;
  end;

implementation

end.
