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

unit i_MapVersionInfo;

interface

uses
  t_Hash;

type
  IMapVersionInfo = interface
    ['{CC157D46-11DA-4035-963B-2F0BEAEA265A}']
    function GetHash: THashValue;
    property Hash: THashValue read GetHash;

    function GetUrlString: string;
    property UrlString: string read GetUrlString;

    function GetStoreString: string;
    property StoreString: string read GetStoreString;

    function GetCaption: string;
    property Caption: string read GetCaption;

    function IsSame(const AValue: IMapVersionInfo): Boolean;
  end;

implementation

end.
