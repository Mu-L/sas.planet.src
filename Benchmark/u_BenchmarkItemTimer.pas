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

unit u_BenchmarkItemTimer;

interface

uses
  i_Timer,
  u_BenchmarkItemBase;

type
  TBenchmarkItemTimer = class(TBenchmarkItemBase)
  private
    FTimer: ITimer;
  protected
    function RunOneStep: Integer; override;
  public
    constructor Create(
      const ATimerName: string;
      const ATimer: ITimer
    );
  end;

implementation

const CRepeatCount = 1000;

{ TBenchmarkItemTimer }

constructor TBenchmarkItemTimer.Create(
  const ATimerName: string;
  const ATimer: ITimer
);
begin
  inherited Create(Assigned(ATimer), 'Timer ' + ATimerName, CRepeatCount);
  FTimer := ATimer;
end;

function TBenchmarkItemTimer.RunOneStep: Integer;
var
  i: Integer;
  VTime: Int64;
begin
  for i := 0 to CRepeatCount - 1 do begin
    VTime := FTimer.CurrentTime;
  end;
  Result := VTime;
end;

end.
