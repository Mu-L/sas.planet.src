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

unit u_MainWindowToolbarsLock;

interface

uses
  i_ConfigDataProvider,
  i_ConfigDataWriteProvider,
  u_ConfigDataElementBase,
  i_MainFormConfig;

type
  TMainWindowToolbarsLock = class(TConfigDataElementBase, IMainWindowToolbarsLock)
  private
    FIsLock: Boolean;
  protected
    procedure DoReadConfig(const AConfigData: IConfigDataProvider); override;
    procedure DoWriteConfig(const AConfigData: IConfigDataWriteProvider); override;
  private
    function GetIsLock: Boolean;
    procedure SetIsLock(AValue: Boolean);
  public
    constructor Create;
  end;


implementation

{ TMainWindowToolbarsLock }

constructor TMainWindowToolbarsLock.Create;
begin
  inherited Create;
  FIsLock := False;
end;

procedure TMainWindowToolbarsLock.DoReadConfig(
  const AConfigData: IConfigDataProvider
);
begin
  inherited;
  if AConfigData <> nil then begin
    FIsLock := AConfigData.ReadBool('lock_toolbars', FIsLock);
    SetChanged;
  end;
end;

procedure TMainWindowToolbarsLock.DoWriteConfig(
  const AConfigData: IConfigDataWriteProvider
);
begin
  inherited;
  AConfigData.WriteBool('lock_toolbars', FIsLock);
end;

function TMainWindowToolbarsLock.GetIsLock: Boolean;
begin
  LockRead;
  try
    Result := FIsLock;
  finally
    UnlockRead;
  end;
end;

procedure TMainWindowToolbarsLock.SetIsLock(AValue: Boolean);
begin
  LockWrite;
  try
    if FIsLock <> AValue then begin
      FIsLock := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

end.
