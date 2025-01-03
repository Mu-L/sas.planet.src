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

unit i_MarkerRingsConfig;

interface

uses
  i_ConfigDataElement;

type
  IMarkerRingsConfigStatic = interface
    ['{7B1A1CBB-7E9B-47F6-B657-6E800FABC7B3}']
    function GetCount: Integer;
    property Count: Integer read GetCount;

    function GetStepDistance: Double;
    property StepDistance: Double read GetStepDistance;
  end;

  IMarkerRingsConfig = interface(IConfigDataElement)
    ['{56C28B06-2AC9-46B9-9E7E-CBEC3A41B975}']
    function GetCount: Integer;
    procedure SetCount(AValue: Integer);
    property Count: Integer read GetCount write SetCount;

    function GetStepDistance: Double;
    procedure SetStepDistance(AValue: Double);
    property StepDistance: Double read GetStepDistance write SetStepDistance;

    function GetStatic: IMarkerRingsConfigStatic;
  end;

implementation

end.
