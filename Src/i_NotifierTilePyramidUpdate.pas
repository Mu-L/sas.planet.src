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

unit i_NotifierTilePyramidUpdate;

interface

uses
  Types,
  i_Listener,
  i_TileKey,
  i_TileRect,
  i_ProjectionSet;

type
  INotifierTilePyramidUpdate = interface
    ['{67415555-955C-4BC7-BC8F-2F9BCDD0F065}']
    function GetProjectionSet: IProjectionSet;
    property ProjectionSet: IProjectionSet read GetProjectionSet;

    procedure AddListenerByRect(
      const AListener: IListener;
      const AZoom: Byte;
      const ATileRect: TRect
    );
    procedure AddListenerByZoom(
      const AListener: IListener;
      const AZoom: Byte
    );
    procedure AddListener(
      const AListener: IListener
    );
    procedure Remove(const AListener: IListener);
  end;

  INotifierTilePyramidUpdateInternal = interface(INotifierTilePyramidUpdate)
    procedure TileFullUpdateNotify;
    procedure TileUpdateNotify(const ATileKey: ITileKey); overload;
    procedure TileUpdateNotify(
      const ATile: TPoint;
      const AZoom: Byte
    ); overload;
    procedure TileRectUpdateNotify(const ATileRect: ITileRect); overload;
    procedure TileRectUpdateNotify(
      const ATileRect: TRect;
      const AZoom: Byte
    ); overload;
  end;

implementation

end.
