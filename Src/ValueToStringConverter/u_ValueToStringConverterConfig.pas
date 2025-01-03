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

unit u_ValueToStringConverterConfig;

interface

uses
  t_CommonTypes,
  i_ConfigDataProvider,
  i_ConfigDataWriteProvider,
  i_ValueToStringConverterConfig,
  u_BaseInterfacedObject,
  u_ConfigDataElementBase;

type
  TValueToStringConverterConfigStatic = class(TBaseInterfacedObject, IValueToStringConverterConfigStatic)
  private
    FDistStrFormat: TDistStrFormat;
    FAreaShowFormat: TAreaStrFormat;
  private
    function GetDistStrFormat: TDistStrFormat;
    function GetAreaShowFormat: TAreaStrFormat;
  public
    constructor Create(
      const ADistStrFormat: TDistStrFormat;
      const AAreaShowFormat: TAreaStrFormat
    );
  end;

  TValueToStringConverterConfig = class(TConfigDataElementWithStaticBase, IValueToStringConverterConfig)
  private
    FDistStrFormat: TDistStrFormat;
    FAreaShowFormat: TAreaStrFormat;
  protected
    function CreateStatic: IInterface; override;
  protected
    procedure DoReadConfig(const AConfigData: IConfigDataProvider); override;
    procedure DoWriteConfig(const AConfigData: IConfigDataWriteProvider); override;
  private
    { IValueToStringConverterConfig }
    function GetDistStrFormat: TDistStrFormat;
    procedure SetDistStrFormat(const AValue: TDistStrFormat);

    function GetAreaShowFormat: TAreaStrFormat;
    procedure SetAreaShowFormat(const AValue: TAreaStrFormat);

    function GetStatic: IValueToStringConverterConfigStatic;
  public
    constructor Create;
  end;


implementation

{ TValueToStringConverterConfig }

constructor TValueToStringConverterConfig.Create;
begin
  inherited Create;
  FDistStrFormat := dsfKmAndM;
  FAreaShowFormat := asfAuto;
end;

function TValueToStringConverterConfig.CreateStatic: IInterface;
var
  VStatic: IValueToStringConverterConfigStatic;
begin
  VStatic :=
    TValueToStringConverterConfigStatic.Create(
      FDistStrFormat,
      FAreaShowFormat
    );
  Result := VStatic;
end;

procedure TValueToStringConverterConfig.DoReadConfig(const AConfigData: IConfigDataProvider);
begin
  inherited;
  if AConfigData <> nil then begin
    FDistStrFormat := TDistStrFormat(AConfigData.ReadInteger('DistFormat', Integer(FDistStrFormat)));
    FAreaShowFormat := TAreaStrFormat(AConfigData.ReadInteger('AreaShowFormat', Integer(FAreaShowFormat)));
    SetChanged;
  end;
end;

procedure TValueToStringConverterConfig.DoWriteConfig(const AConfigData: IConfigDataWriteProvider);
begin
  inherited;
  AConfigData.WriteInteger('DistFormat', Integer(FDistStrFormat));
  AConfigData.WriteInteger('AreaShowFormat', Integer(FAreaShowFormat));
end;

function TValueToStringConverterConfig.GetAreaShowFormat: TAreaStrFormat;
begin
  LockRead;
  try
    Result := FAreaShowFormat;
  finally
    UnlockRead;
  end;
end;

function TValueToStringConverterConfig.GetDistStrFormat: TDistStrFormat;
begin
  LockRead;
  try
    Result := FDistStrFormat;
  finally
    UnlockRead;
  end;
end;

function TValueToStringConverterConfig.GetStatic: IValueToStringConverterConfigStatic;
begin
  Result := IValueToStringConverterConfigStatic(GetStaticInternal);
end;

procedure TValueToStringConverterConfig.SetAreaShowFormat(const AValue: TAreaStrFormat);
begin
  LockWrite;
  try
    if FAreaShowFormat <> AValue then begin
      FAreaShowFormat := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TValueToStringConverterConfig.SetDistStrFormat(const AValue: TDistStrFormat);
begin
  LockWrite;
  try
    if FDistStrFormat <> AValue then begin
      FDistStrFormat := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

{ TValueToStringConverterConfigStatic }

constructor TValueToStringConverterConfigStatic.Create(
  const ADistStrFormat: TDistStrFormat;
  const AAreaShowFormat: TAreaStrFormat
);
begin
  inherited Create;
  FDistStrFormat := ADistStrFormat;
  FAreaShowFormat := AAreaShowFormat;
end;

function TValueToStringConverterConfigStatic.GetAreaShowFormat: TAreaStrFormat;
begin
  Result := FAreaShowFormat;
end;

function TValueToStringConverterConfigStatic.GetDistStrFormat: TDistStrFormat;
begin
  Result := FDistStrFormat;
end;

end.
