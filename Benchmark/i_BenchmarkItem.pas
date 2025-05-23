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

unit i_BenchmarkItem;

interface

type
  IBenchmarkItem = interface
    ['{91C4C570-6140-4B00-93A1-01FB60FA669F}']
    function GetEnabled: Boolean;
    property Enabled: Boolean read GetEnabled;

    function GetName: string;
    property Name: string read GetName;

    function GetCountOperationsPerStep: Integer;
    property CountOperationsPerStep: Integer read GetCountOperationsPerStep;

    procedure SetUp;
    function RunOneStep: Integer;
    procedure TearDown;
  end;

implementation

end.

