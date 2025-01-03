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

unit u_InternalPerformanceCounterList;

interface

uses
  SysUtils,
  i_InterfaceListSimple,
  i_InternalPerformanceCounter;

type
  TInternalPerformanceCounterList = class(TInterfacedObject, IInternalPerformanceCounterList)
  private
    FListCS: IReadWriteSync;
    FList: IInterfaceListSimple;
    FFactory: IInternalPerformanceCounterFactory;
    FName: string;
  private
    function CreateAndAddNewCounter(const AName: string): IInternalPerformanceCounter;
    function CreateAndAddNewSubList(const AName: string): IInternalPerformanceCounterList;
  public
    constructor Create(
      const AName: string;
      const AListCS: IReadWriteSync;
      const AList: IInterfaceListSimple;
      const AFactory: IInternalPerformanceCounterFactory
    );
  end;

implementation

const
  CNamePartSeparator: string = '/';

{ TInternalPerformanceCounterList }

constructor TInternalPerformanceCounterList.Create(
  const AName: string;
  const AListCS: IReadWriteSync;
  const AList: IInterfaceListSimple;
  const AFactory: IInternalPerformanceCounterFactory
);
begin
  inherited Create;
  FName := AName;
  FFactory := AFactory;
  FList := AList;
  FListCS := AListCS;
end;

function TInternalPerformanceCounterList.CreateAndAddNewCounter(
  const AName: string
): IInternalPerformanceCounter;
begin
  Result := FFactory.Build(FName + CNamePartSeparator + AName);
  FListCS.BeginWrite;
  try
    FList.Add(Result);
  finally
    FListCS.EndWrite;
  end;
end;

function TInternalPerformanceCounterList.CreateAndAddNewSubList(
  const AName: string
): IInternalPerformanceCounterList;
begin
  Result :=
    TInternalPerformanceCounterList.Create(
      FName + CNamePartSeparator + AName,
      FListCS,
      FList,
      FFactory
    );
end;

end.
