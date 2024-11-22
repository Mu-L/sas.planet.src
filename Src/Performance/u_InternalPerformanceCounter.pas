{******************************************************************************}
{* This file is part of SAS.Planet project.                                   *}
{*                                                                            *}
{* Copyright (C) 2007-2022, SAS.Planet development team.                      *}
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

unit u_InternalPerformanceCounter;

interface

uses
  i_Timer,
  i_InternalPerformanceCounter;

type
  TInternalPerformanceCounter = class(TInterfacedObject, IInternalPerformanceCounter)
  private
    FTimer: ITimer;
    FMainThreadID: THandle;
    FId: NativeInt;
    FName: string;

    FCounter: Cardinal;
    FTotal: Int64;

    FCounterInMain: Cardinal;
    FTotalInMain: Int64;

    FMin: Int64;
    FMax: Int64;
    FLast: Int64;

    FFreq: Int64;
  private
    function StartOperation: TInternalPerformanceCounterContext;
    procedure FinishOperation(const AContext: TInternalPerformanceCounterContext);

    function GetStaticData: IInternalPerformanceCounterStaticData;
  public
    constructor Create(
      const AName: string;
      const AMainThreadID: THandle;
      const ATimer: ITimer
    );
  end;

  TInternalPerformanceCounterFactory = class(TInterfacedObject, IInternalPerformanceCounterFactory)
  private
    FTimer: ITimer;
    FMainThreadID: THandle;
  private
    function Build(const AName: string): IInternalPerformanceCounter;
  public
    constructor Create(
      const ATimer: ITimer
    );
  end;

implementation

uses
  Windows,
  u_InternalPerformanceCounterStaticData;

{ TInternalPerformanceCounter }

constructor TInternalPerformanceCounter.Create(
  const AName: string;
  const AMainThreadID: THandle;
  const ATimer: ITimer
);
begin
  Assert(Assigned(ATimer));
  inherited Create;
  FId := NativeInt(Self);
  FMainThreadID := AMainThreadID;
  FName := AName;
  FTimer := ATimer;

  FCounter := 0;
  FTotal := 0;
  FCounterInMain := 0;
  FTotalInMain := 0;
  FMin := $7FFFFFFFFFFFFFF;
  FMax := 0;
  FLast := 0;
  FFreq := FTimer.Freq;
end;

procedure TInternalPerformanceCounter.FinishOperation(const AContext: TInternalPerformanceCounterContext);
begin
  if AContext <> 0 then begin
    Inc(FCounter);
    FLast := FTimer.CurrentTime - AContext;
    Inc(FTotal, FLast);
    if GetCurrentThreadId = FMainThreadID then begin
      Inc(FCounterInMain);
      Inc(FTotalInMain, FLast);
    end;
    if FLast > FMax then begin
      FMax := FLast;
    end;
    if FLast < FMin then begin
      FMin := FLast;
    end;
  end;
end;

function TInternalPerformanceCounter.GetStaticData: IInternalPerformanceCounterStaticData;
var
  VTotalTime: Double;
  VTotalTimeInMain: Double;
  VMaxTime: Double;
  VMinTime: Double;
  VLastTime: Double;
begin
  if (FFreq = 0) or (FTotal = 0) then begin
    VTotalTime := 0;
    VTotalTimeInMain := 0;
    VMaxTime := 0;
    VMinTime := 0;
    VLastTime := 0;
  end else begin
    VTotalTime := FTotal / FFreq / 24 / 60 / 60;
    VTotalTimeInMain := FTotalInMain / FFreq / 24 / 60 / 60;
    VMaxTime := FMax / FFreq / 24 / 60 / 60;
    VMinTime := FMin / FFreq / 24 / 60 / 60;
    VLastTime := FLast / FFreq / 24 / 60 / 60;
  end;
  Result :=
    TInternalPerformanceCounterStaticData.Create(
      FId,
      FName,
      FCounter,
      VTotalTime,
      FCounterInMain,
      VTotalTimeInMain,
      VMaxTime,
      VMinTime,
      VLastTime
    );
end;

function TInternalPerformanceCounter.StartOperation: TInternalPerformanceCounterContext;
begin
  Result := FTimer.CurrentTime;
end;

{ TInternalPerformanceCounterFactory }

constructor TInternalPerformanceCounterFactory.Create(
  const ATimer: ITimer
);
begin
  Assert(Assigned(ATimer));
  inherited Create;
  FTimer := ATimer;
  FMainThreadID := GetCurrentThreadId;
end;

function TInternalPerformanceCounterFactory.Build(
  const AName: string
): IInternalPerformanceCounter;
begin
  Result := TInternalPerformanceCounter.Create(AName, FMainThreadID, FTimer);
end;

end.
