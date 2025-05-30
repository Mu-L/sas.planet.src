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

unit i_BerkeleyDBEnv;

interface

uses
  t_BerkeleyDB,
  i_BerkeleyDB;

type
  IBerkeleyDBEnvironment = interface
    ['{0D73208B-3729-43F3-9AAE-DF1616107648}']
    function GetEnvironmentPointerForApi: Pointer;
    property dbenv: Pointer read GetEnvironmentPointerForApi;

    function GetRootPath: string;
    property RootPath: string read GetRootPath;

    function GetClientsCount: Integer;
    procedure SetClientsCount(const AValue: Integer);
    property ClientsCount: Integer read GetClientsCount write SetClientsCount;

    function Acquire(const ADatabaseFileName: string): IBerkeleyDB;
    procedure Release(const ADatabase: IBerkeleyDB);

    procedure TransactionBegin(out ATxn: PBerkeleyTxn);
    procedure TransactionCommit(var ATxn: PBerkeleyTxn);
    procedure TransactionAbort(var ATxn: PBerkeleyTxn);

    procedure Sync(out AHotDatabaseCount: Integer);
  end;

implementation

end.
