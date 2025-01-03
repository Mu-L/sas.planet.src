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

unit u_InternalPerformanceCounterFake;

interface

uses
  i_InternalPerformanceCounter;

type
  TInternalPerformanceCounterFake = class(TInterfacedObject, IInternalPerformanceCounterList, IInternalPerformanceCounter)
  private
    { IInternalPerformanceCounterList }
    function CreateAndAddNewCounter(const AName: string): IInternalPerformanceCounter;
    function CreateAndAddNewSubList(const AName: string): IInternalPerformanceCounterList;
  private
    { IInternalPerformanceCounter }
    function StartOperation: TInternalPerformanceCounterContext;
    procedure FinishOperation(const AContext: TInternalPerformanceCounterContext);
    function GetStaticData: IInternalPerformanceCounterStaticData;
  end;

implementation

{ TInternalPerformanceCounterFake }

function TInternalPerformanceCounterFake.CreateAndAddNewCounter(const AName: string): IInternalPerformanceCounter;
begin
  Result := Self;
end;

function TInternalPerformanceCounterFake.CreateAndAddNewSubList(const AName: string): IInternalPerformanceCounterList;
begin
  Result := Self;
end;

procedure TInternalPerformanceCounterFake.FinishOperation(const AContext: TInternalPerformanceCounterContext);
begin
  // empty
end;

function TInternalPerformanceCounterFake.GetStaticData: IInternalPerformanceCounterStaticData;
begin
  Result := nil;
end;

function TInternalPerformanceCounterFake.StartOperation: TInternalPerformanceCounterContext;
begin
  Result := 0;
end;

end.
