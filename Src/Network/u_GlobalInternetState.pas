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

unit u_GlobalInternetState;

interface

uses
  SysUtils,
  i_GlobalInternetState,
  u_BaseInterfacedObject;

type
  TGlobalInternetState = class(TBaseInterfacedObject, IGlobalInternetState)
  private
    FCS: IReadWriteSync;
    FQueueCount: Integer;
    function GetQueueCount: Integer;
  public
    constructor Create;
    procedure IncQueueCount;
    procedure DecQueueCount;
    property QueueCount: Integer read GetQueueCount;
  end;

implementation

uses
  u_Synchronizer;

{ TGlobalInternetState }

constructor TGlobalInternetState.Create;
begin
  inherited;
  FCS := GSync.SyncVariable.Make(Self.ClassName);
  FQueueCount := 0;
end;

procedure TGlobalInternetState.IncQueueCount;
begin
  FCS.BeginWrite;
  try
    Inc(FQueueCount);
  finally
    FCS.EndWrite;
  end;
end;

procedure TGlobalInternetState.DecQueueCount;
begin
  FCS.BeginWrite;
  try
    Dec(FQueueCount);
    if FQueueCount < 0 then begin
      FQueueCount := 0;
    end;
  finally
    FCS.EndWrite;
  end;
end;

function TGlobalInternetState.GetQueueCount: Integer;
begin
  FCS.BeginRead;
  try
    Result := FQueueCount;
  finally
    FCS.EndRead;
  end;
end;

end.
