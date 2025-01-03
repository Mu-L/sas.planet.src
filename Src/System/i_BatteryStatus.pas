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

unit i_BatteryStatus;

interface

uses
  i_Changeable;

type
  IBatteryStatusStatic = interface
    ['{5A0E6C17-5834-40FA-8B16-6B00BCDAC175}']
    function GetACLineStatus: Byte;
    property ACLineStatus: Byte read GetACLineStatus;

    function GetBatteryFlag: Byte;
    property BatteryFlag: Byte read GetBatteryFlag;

    function GetBatteryLifePercent: Byte;
    property BatteryLifePercent: Byte read GetBatteryLifePercent;

    function GetBatteryLifeTime: LongWord;
    property BatteryLifeTime: LongWord read GetBatteryLifeTime;
  end;

  IBatteryStatus = interface(IChangeable)
    ['{ABA8A37A-AAA2-4E93-ADC1-6BC0E75D3238}']
    function GetStatic: IBatteryStatusStatic;
  end;


implementation

end.
