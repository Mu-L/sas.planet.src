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

unit u_BenchmarkResultList;

interface

uses
  i_InterfaceListStatic,
  i_BenchmarkResult,
  i_BenchmarkResultList;

type
  TBenchmarkResultList = class(TInterfacedObject, IBenchmarkResultList)
  private
    FList: IInterfaceListStatic;
  private
    function GetCount: Integer;
    function GetItem(const AIndex: Integer): IBenchmarkResult;
  public
    constructor Create(const AList: IInterfaceListStatic);
  end;

implementation

{ TBenchmarkResultList }

constructor TBenchmarkResultList.Create(const AList: IInterfaceListStatic);
begin
  Assert(Assigned(AList));
  Assert(AList.Count > 0);
  inherited Create;
  FList := AList;
end;

function TBenchmarkResultList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TBenchmarkResultList.GetItem(const AIndex: Integer): IBenchmarkResult;
begin
  Result := IBenchmarkResult(FList.Items[AIndex]);
end;

end.

