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

unit i_EnumDoublePoint;

interface

uses
  t_GeoTypes;

type
  IEnumDoublePoint = interface
    ['{A821C4B3-DB65-4B93-94A2-19ADC919EDCC}']
    function Next(
      out APoint: TDoublePoint
    ): Boolean; overload;

    function Next(
      out APoint: TDoublePoint;
      out AMeta: TDoublePointsMetaItem
    ): Boolean; overload;
  end;

  IEnumLonLatPoint = interface(IEnumDoublePoint)
    ['{E8365B09-9819-4372-B24F-65BBFDC84558}']
  end;

  IEnumProjectedPoint = interface(IEnumDoublePoint)
    ['{BC88EBFF-54FA-4322-BB2A-0845A5943804}']
  end;

  IEnumLocalPoint = interface(IEnumDoublePoint)
    ['{70250A89-1BA1-45BA-8A33-0FE97E714771}']
  end;

implementation

end.
