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

unit u_InternalPerformanceCounterListForDebugOneClass;

interface

uses
  i_InternalPerformanceCounter,
  i_InternalPerformanceCounterListForDebug;

type
  TInternalPerformanceCounterListForDebugOneClass = class(TInterfacedObject, IInternalPerformanceCounterListForDebugOneClass)
  private
    FCounterCreate: IInternalPerformanceCounter;
    FCounterDestroy: IInternalPerformanceCounter;
  private
    function GetCounterCreate: IInternalPerformanceCounter;
    function GetCounterDestroy: IInternalPerformanceCounter;
  public
    constructor Create(
      const ABaseName: string;
      const AFactory: IInternalPerformanceCounterFactory
    );
  end;

implementation

{ TInternalPerformanceCounterListForDebugOneClass }

constructor TInternalPerformanceCounterListForDebugOneClass.Create(
  const ABaseName: string;
  const AFactory: IInternalPerformanceCounterFactory
);
begin
  inherited Create;
  FCounterCreate := AFactory.Build(ABaseName + '/Create');
  FCounterDestroy := AFactory.Build(ABaseName + '/Destroy');
end;

function TInternalPerformanceCounterListForDebugOneClass.GetCounterCreate: IInternalPerformanceCounter;
begin
  Result := FCounterCreate;
end;

function TInternalPerformanceCounterListForDebugOneClass.GetCounterDestroy: IInternalPerformanceCounter;
begin
  Result := FCounterDestroy;
end;

end.
