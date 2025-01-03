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

unit i_ReadWriteState;

interface

uses
  i_Changeable;

type
  IReadWriteStateStatic = interface
    ['{E6BE17B1-BF3C-4313-B733-7B66A63EF684}']
    function GetReadAccess: Boolean;
    property ReadAccess: Boolean read GetReadAccess;

    function GetWriteAccess: Boolean;
    property WriteAccess: Boolean read GetWriteAccess;
  end;

  IReadWriteStateChangeble = interface(IChangeable)
    ['{6202AB73-00A2-4711-87F4-D195CEFD9C3F}']
    function GetStatic: IReadWriteStateStatic;
  end;

implementation

end.
