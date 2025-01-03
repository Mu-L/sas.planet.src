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

unit i_FavoriteMapSetConfig;

interface

uses
  Classes,
  t_GeoTypes,
  i_GUIDListStatic,
  i_ConfigDataElement,
  i_InterfaceListStatic,
  i_FavoriteMapSetItemStatic;

type
  IFavoriteMapSetConfig = interface(IConfigDataElement)
  ['{C98ACE9E-513B-47F1-A908-5931F538ED0A}']
    function GetCount: Integer;
    property Count: Integer read GetCount;

    function GetByID(const AID: TGUID): IFavoriteMapSetItemStatic;
    function GetByName(const AName: string): IFavoriteMapSetItemStatic;

    function Delete(const AID: TGUID): Boolean;

    function Add(
      const ABaseMap: TGUID;
      const ALayers: IGUIDSetStatic;
      const AMergeLayers: Boolean;
      const AZoom: Integer;
      const ALonLat: TDoublePoint;
      const AName: string;
      const AHotKey: TShortCut
    ): TGUID;

    function Update(
      const AID: TGUID;
      const ABaseMap: TGUID;
      const ALayers: IGUIDSetStatic;
      const AMergeLayers: Boolean;
      const AZoom: Integer;
      const ALonLat: TDoublePoint;
      const AName: string;
      const AHotKey: TShortCut
    ): Boolean;

    function MoveUp(const AID: TGUID): Boolean;
    function MoveDown(const AID: TGUID): Boolean;

    function GetStatic: IInterfaceListStatic;
  end;

implementation

end.
