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

unit i_RegionProcessProvider;

interface

uses
  Controls,
  i_GeometryLonLat;

type
  IRegionProcessProvider = interface
    ['{14935473-1F97-4BCE-B208-A096B871EDE8}']
    function GetCaption: string;

    procedure Show(
      const AParent: TWinControl;
      const AZoom: Byte;
      const APolygon: IGeometryLonLatPolygon
    );

    procedure Hide;

    function Validate(
      const APolygon: IGeometryLonLatPolygon
    ): Boolean;

    procedure StartProcess(
      const APolygon: IGeometryLonLatPolygon
    );
  end;

implementation

end.
