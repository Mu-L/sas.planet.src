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

unit u_MarkPolygonLayerConfig;

interface

uses
  i_MarkPolygonLayerConfig,
  i_PolyLineLayerConfig,
  i_PolygonLayerConfig,
  i_PolygonCaptionsLayerConfig,
  u_ConfigDataElementComplexBase;

type
  TMarkPolygonLayerConfig = class(TConfigDataElementComplexBase, IMarkPolygonLayerConfig)
  private
    FLineConfig: IPolygonLayerConfig;
    FPointsConfig: IPointsSetLayerConfig;
    FCaptionsConfig: IPolygonCaptionsLayerConfig;
  private
    { IMarkPolygonLayerConfig }
    function GetLineConfig: IPolygonLayerConfig;
    function GetPointsConfig: IPointsSetLayerConfig;
    function GetCaptionsConfig: IPolygonCaptionsLayerConfig;
  public
    constructor Create;
  end;

implementation

uses
  GR32,
  i_MarkerSimpleConfig,
  u_MarkerSimpleConfigStatic,
  u_PointsSetLayerConfig,
  u_PolygonLayerConfig,
  u_PolygonCaptionsLayerConfig,
  u_ConfigSaveLoadStrategyBasicUseProvider;

{ TMarkPolygonLayerConfig }

constructor TMarkPolygonLayerConfig.Create;
var
  VFirstPointMarkerDefault: IMarkerSimpleConfigStatic;
  VActivePointMarkerDefault: IMarkerSimpleConfigStatic;
  VNormalPointMarkerDefault: IMarkerSimpleConfigStatic;
begin
  inherited Create;
  FLineConfig := TPolygonLayerConfig.Create;
  FLineConfig.LineColor := SetAlpha(ClRed32, 150);
  FLineConfig.LineWidth := 3;
  FLineConfig.FillColor := SetAlpha(ClWhite32, 50);
  Add(FLineConfig, TConfigSaveLoadStrategyBasicUseProvider.Create);

  VFirstPointMarkerDefault :=
    TMarkerSimpleConfigStatic.Create(
      8,
      SetAlpha(clLime32, 255),
      SetAlpha(ClRed32, 150)
    );

  VActivePointMarkerDefault :=
    TMarkerSimpleConfigStatic.Create(
      10,
      SetAlpha(ClRed32, 100),
      SetAlpha(ClRed32, 255)
    );

  VNormalPointMarkerDefault :=
    TMarkerSimpleConfigStatic.Create(
      8,
      SetAlpha(clYellow32, 150),
      SetAlpha(ClRed32, 150)
    );

  FPointsConfig :=
    TPointsSetLayerConfig.Create(
      VFirstPointMarkerDefault,
      VActivePointMarkerDefault,
      VNormalPointMarkerDefault
    );
  Add(FPointsConfig, TConfigSaveLoadStrategyBasicUseProvider.Create);

  FCaptionsConfig := TPolygonCaptionsLayerConfig.Create;
  Add(FCaptionsConfig, TConfigSaveLoadStrategyBasicUseProvider.Create);
end;

function TMarkPolygonLayerConfig.GetCaptionsConfig: IPolygonCaptionsLayerConfig;
begin
  Result := FCaptionsConfig;
end;

function TMarkPolygonLayerConfig.GetLineConfig: IPolygonLayerConfig;
begin
  Result := FLineConfig;
end;

function TMarkPolygonLayerConfig.GetPointsConfig: IPointsSetLayerConfig;
begin
  Result := FPointsConfig;
end;

end.
