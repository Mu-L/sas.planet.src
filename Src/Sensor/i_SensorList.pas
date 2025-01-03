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

unit i_SensorList;

interface

uses
  ActiveX,
  i_Changeable,
  i_Sensor;

type
  ISensorListEntity = interface(IChangeable)
    ['{26BB13C7-C30E-472D-874E-997122427990}']
    function GetGUID: TGUID;
    property GUID: TGUID read GetGUID;

    function GetCaption: string;
    property Caption: string read GetCaption;

    function GetDescription: string;
    property Description: string read GetDescription;

    function GetMenuItemName: string;
    property MenuItemName: string read GetMenuItemName;

    function GetSensorTypeIID: TGUID;
    property SensorTypeIID: TGUID read GetSensorTypeIID;

    function GetSensor: ISensor;
    property Sensor: ISensor read GetSensor;
  end;

  ISensorList = interface(IChangeable)
    ['{69F7AA17-D6B4-4F49-891E-72AEA4DC053F}']
    function GetGUIDEnum: IEnumGUID;
    function Get(const AGUID: TGUID): ISensorListEntity;
  end;

implementation

end.
