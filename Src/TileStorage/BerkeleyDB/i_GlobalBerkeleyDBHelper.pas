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

unit i_GlobalBerkeleyDBHelper;

interface

uses
  i_BerkeleyDBEnv,
  i_TileStorageBerkeleyDBConfigStatic;

type
  IGlobalBerkeleyDBHelper = interface
    ['{01EDEF03-9DCE-42A9-AB26-40A6C1C7104D}']
    function AllocateEnvironment(
      const AIsReadOnly: Boolean;
      const AStorageConfig: ITileStorageBerkeleyDBConfigStatic;
      const AStorageEPSG: Integer;
      const AEnvRootPath: string
    ): IBerkeleyDBEnvironment;

    procedure FreeEnvironment(const AEnv: IBerkeleyDBEnvironment);

    procedure LogException(const EMsg: string);
  end;

implementation

end.
