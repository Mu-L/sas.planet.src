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

unit i_StorageStateProxy;

interface

uses
  i_StorageState,
  i_Changeable;

type
  IStorageStateProxy = interface(IChangeable)
    ['{0C95A8D3-B486-4A9A-A84B-EC209B24BA0C}']
    function GetTarget: IStorageStateChangeble;
    procedure SetTarget(const AValue: IStorageStateChangeble);
    property Target: IStorageStateChangeble read GetTarget write SetTarget;

    function GetStatic: IStorageStateStatic;
  end;

implementation

end.
