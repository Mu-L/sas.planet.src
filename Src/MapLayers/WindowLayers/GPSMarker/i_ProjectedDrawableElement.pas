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

unit i_ProjectedDrawableElement;

interface

uses
  GR32,
  i_Projection,
  i_LocalCoordConverter;

type
  IProjectedDrawableElement = interface
    ['{999BACCC-135B-439A-A646-A827398B316E}']
    function GetProjection: IProjection;
    property Projection: IProjection read GetProjection;

    function GetBounds(
      const ALocalConverter: ILocalCoordConverter
    ): TRect;

    procedure Draw(
      ABitmap: TCustomBitmap32;
      const ALocalConverter: ILocalCoordConverter
    );
  end;

implementation

end.
