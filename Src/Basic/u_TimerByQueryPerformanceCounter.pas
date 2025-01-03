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

unit u_TimerByQueryPerformanceCounter;

interface

uses
  i_Timer;

function MakeTimerByQueryPerformanceCounter: ITimer;

implementation

uses
  Windows;

{ TTimerByQueryPerformanceCounter }

type
  TTimerByQueryPerformanceCounter = class(TInterfacedObject, ITimer)
  private
    FFreq: Int64;
  private
    function GetFreq: Int64;
    function CurrentTime: Int64;
  public
    constructor Create(
      const AFreq: Int64
    );
  end;

constructor TTimerByQueryPerformanceCounter.Create(const AFreq: Int64);
begin
  Assert(AFreq <> 0);
  inherited Create;
  FFreq := AFreq;
end;

function TTimerByQueryPerformanceCounter.CurrentTime: Int64;
begin
  QueryPerformanceCounter(Result);
end;

function TTimerByQueryPerformanceCounter.GetFreq: Int64;
begin
  Result := FFreq;
end;

function MakeTimerByQueryPerformanceCounter: ITimer;
var
  VCounter, VFreq: Int64;
begin
  Result := nil;
  if QueryPerformanceFrequency(VFreq) then begin
    if VFreq <> 0 then begin
      if QueryPerformanceCounter(VCounter) then begin
        Result := TTimerByQueryPerformanceCounter.Create(VFreq);
      end;
    end;
  end;
end;

end.
