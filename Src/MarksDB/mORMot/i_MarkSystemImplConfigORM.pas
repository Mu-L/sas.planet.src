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

unit i_MarkSystemImplConfigORM;

interface

uses
  i_MarkSystemImplConfig;

type
  IMarkSystemImplConfigORM = interface(IMarkSystemImplConfigStatic)
    ['{4922B216-1197-4BB0-93E1-CC2CC1B68787}']
    function GetUserName: string;
    property UserName: string read GetUserName;

    function GetPassword: string;
    property Password: string read GetPassword;

    function GetPasswordPlain: string;
    property PasswordPlain: string read GetPasswordPlain;

    function GetCacheSizeMb: Cardinal;
    property CacheSizeMb: Cardinal read GetCacheSizeMb;

    function GetForcedSchemaName: string;
    property ForcedSchemaName: string read GetForcedSchemaName;
  end;

implementation

end.
