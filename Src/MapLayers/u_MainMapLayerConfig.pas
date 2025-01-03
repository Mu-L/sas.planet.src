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

unit u_MainMapLayerConfig;

interface

uses
  i_ThreadConfig,
  i_MainMapLayerConfig,
  i_UseTilePrevZoomConfig,
  u_ConfigDataElementComplexBase;

type
  TMainMapLayerConfig = class(TConfigDataElementComplexBase, IMainMapLayerConfig)
  private
    FUseTilePrevZoomConfig: IUseTilePrevZoomConfig;
    FThreadConfig: IThreadConfig;
  private
    function GetUseTilePrevZoomConfig: IUseTilePrevZoomConfig;
    function GetThreadConfig: IThreadConfig;
  public
    constructor Create;
  end;

implementation

uses
  Classes,
  u_ConfigSaveLoadStrategyBasicUseProvider,
  u_UseTilePrevZoomConfig,
  u_ThreadConfig;

{ TMainMapLayerConfig }

constructor TMainMapLayerConfig.Create;
begin
  inherited Create;

  FUseTilePrevZoomConfig := TUseTilePrevZoomConfig.Create;
  Add(FUseTilePrevZoomConfig, TConfigSaveLoadStrategyBasicUseProvider.Create);

  FThreadConfig := TThreadConfig.Create(tpNormal);
  Add(FThreadConfig, TConfigSaveLoadStrategyBasicUseProvider.Create);
end;

function TMainMapLayerConfig.GetThreadConfig: IThreadConfig;
begin
  Result := FThreadConfig;
end;

function TMainMapLayerConfig.GetUseTilePrevZoomConfig: IUseTilePrevZoomConfig;
begin
  Result := FUseTilePrevZoomConfig;
end;

end.
