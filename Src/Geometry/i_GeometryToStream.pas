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

unit i_GeometryToStream;

interface

uses
  Classes,
  i_GeometryLonLat;

type
  IGeometryPointsToStream = interface
    ['{BAA3E867-B9F1-4F32-B7A2-747A7170ED8A}']
    procedure Save(
      const AGeometry: IGeometryLonLat;
      const AStream: TStream
    );
  end;

  IGeometryMetaToStream = interface
    ['{F6997D3C-2D0C-40FC-86D4-762C4D4B99C4}']
    procedure Save(
      const AGeometry: IGeometryLonLat;
      const AStream: TStream
    );
  end;

implementation

end.
