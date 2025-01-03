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

unit i_MarkPictureConfig;

interface

uses
  t_GeoTypes,
  i_ConfigDataElement;

type
  IMarkPictureConfig = interface(IConfigDataElement)
    ['{1A89412D-EFD7-4669-A3ED-A90DAE340BC1}']
    function GetDefaultAnchor(const APicName: string): TDoublePoint;

    function GetAnchor(const APicName: string): TDoublePoint;
    procedure SetAnchor(const APicName: string; const AAnchor: TDoublePoint);
  end;

implementation

end.
