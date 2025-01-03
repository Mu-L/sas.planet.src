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

unit u_BenchmarkItemDoubleInc;

interface

uses
  u_BenchmarkItemBase;

type
  TBenchmarkItemDoubleInc = class(TBenchmarkItemBase)
  private
    FData: Double;
  protected
    function RunOneStep: Integer; override;
  public
    constructor Create;
  end;

implementation

const CRepeatCount = 1000;

{ TBenchmarkItemDoubleInc }

constructor TBenchmarkItemDoubleInc.Create;
begin
  inherited Create(True, 'Double Increment', CRepeatCount);
end;

function TBenchmarkItemDoubleInc.RunOneStep: Integer;
var
  i: Integer;
begin
  for i := 0 to CRepeatCount - 1 do begin
    FData := FData + 1;
  end;
  Result := Trunc(FData);
end;

end.
