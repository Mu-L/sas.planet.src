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

unit u_MainGeoCoderConfig;

interface

uses
  i_ConfigDataProvider,
  i_ConfigDataWriteProvider,
  i_MainGeoCoderConfig,
  u_ConfigDataElementBase;

type
  TMainGeoCoderConfig = class(TConfigDataElementBase, IMainGeoCoderConfig)
  private
    FActiveGeoCoderGUID: TGUID;
  protected
    procedure DoReadConfig(const AConfigData: IConfigDataProvider); override;
    procedure DoWriteConfig(const AConfigData: IConfigDataWriteProvider); override;
  private
    function GetActiveGeoCoderGUID: TGUID;
    procedure SetActiveGeoCoderGUID(const AValue: TGUID);
  public
    constructor Create;
  end;

implementation

uses
  SysUtils,
  c_ZeroGUID,
  u_ConfigProviderHelpers;

{ TMainGeoCoderConfig }

constructor TMainGeoCoderConfig.Create;
begin
  inherited Create;
  FActiveGeoCoderGUID := CGUID_Zero;
end;

procedure TMainGeoCoderConfig.DoReadConfig(const AConfigData: IConfigDataProvider);
begin
  inherited;
  if AConfigData <> nil then begin
    SetActiveGeoCoderGUID(ReadGUID(AConfigData, 'GeoCoderGUID', FActiveGeoCoderGUID));
  end;
end;

procedure TMainGeoCoderConfig.DoWriteConfig(
  const AConfigData: IConfigDataWriteProvider
);
begin
  inherited;
  WriteGUID(AConfigData, 'GeoCoderGUID', FActiveGeoCoderGUID);
end;

function TMainGeoCoderConfig.GetActiveGeoCoderGUID: TGUID;
begin
  LockRead;
  try
    Result := FActiveGeoCoderGUID;
  finally
    UnlockRead;
  end;
end;

procedure TMainGeoCoderConfig.SetActiveGeoCoderGUID(const AValue: TGUID);
begin
  LockWrite;
  try
    if not IsEqualGUID(FActiveGeoCoderGUID, AValue) then begin
      FActiveGeoCoderGUID := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

end.
