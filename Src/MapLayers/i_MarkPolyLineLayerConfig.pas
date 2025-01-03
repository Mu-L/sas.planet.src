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

unit i_MarkPolyLineLayerConfig;

interface

uses
  i_ConfigDataElement,
  i_PointCaptionsLayerConfig,
  i_PolyLineLayerConfig;

type
  IMarkPolyLineLayerConfig = interface(IConfigDataElement)
    ['{2517BC10-BE31-4EC7-B37C-7CBCEA33D2D3}']
    function GetLineConfig: ILineLayerConfig;
    property LineConfig: ILineLayerConfig read GetLineConfig;

    function GetPointsConfig: IPointsSetLayerConfig;
    property PointsConfig: IPointsSetLayerConfig read GetPointsConfig;

    function GetCaptionConfig: IPointCaptionsLayerConfig;
    property CaptionConfig: IPointCaptionsLayerConfig read GetCaptionConfig;
  end;

implementation

end.
