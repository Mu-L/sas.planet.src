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

unit i_ElevationMetaWriter;

interface

uses
  i_GeometryLonLat;

type
  TElevationMetaWriterResult = procedure(const ALine: IGeometryLonLatLine) of object;

  IElevationMetaWriter = interface
    ['{62C42A6C-9ABC-40A5-945B-DB2FF5E6339C}']

    procedure ProcessLineAsync(
      const ALine: IGeometryLonLatLine;
      const AOnResult: TElevationMetaWriterResult;
      const AAddIntermediatePoints: Boolean = False;
      const AMaxDistanceForIntermediatePoint: Double = 0
    );
  end;

implementation

end.
