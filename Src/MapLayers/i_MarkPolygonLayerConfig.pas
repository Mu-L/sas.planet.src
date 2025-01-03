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

unit i_MarkPolygonLayerConfig;

interface

uses
  i_ConfigDataElement,
  i_PolyLineLayerConfig,
  i_PolygonLayerConfig,
  i_PolygonCaptionsLayerConfig;

type
  IMarkPolygonLayerConfig = interface(IConfigDataElement)
    ['{B6E75FAB-86BB-4CE9-B2FD-F3A014FA0B12}']
    function GetLineConfig: IPolygonLayerConfig;
    property LineConfig: IPolygonLayerConfig read GetLineConfig;

    function GetPointsConfig: IPointsSetLayerConfig;
    property PointsConfig: IPointsSetLayerConfig read GetPointsConfig;

    function GetCaptionsConfig: IPolygonCaptionsLayerConfig;
    property CaptionsConfig: IPolygonCaptionsLayerConfig read GetCaptionsConfig;
  end;

implementation

end.
