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

unit i_LocalCoordConverterFactorySimpe;

interface

uses
  Types,
  t_GeoTypes,
  i_Projection,
  i_LocalCoordConverter;

type
  ILocalCoordConverterFactorySimpe = interface
    ['{102D5E00-4F2C-4425-9EB9-ED4DD77141FB}']
    function CreateConverter(
      const ALocalRect: TRect;
      const AProjection: IProjection;
      const AMapScale: Double;
      const AMapPixelAtLocalZero: TDoublePoint
    ): ILocalCoordConverter;
    function CreateConverterNoScale(
      const ALocalRect: TRect;
      const AProjection: IProjection;
      const AMapPixelAtLocalZero: TPoint
    ): ILocalCoordConverter;

    function ChangeCenterLonLat(
      const ASource: ILocalCoordConverter;
      const ALonLat: TDoublePoint
    ): ILocalCoordConverter;
    function ChangeByLocalDelta(
      const ASource: ILocalCoordConverter;
      const ADelta: TDoublePoint
    ): ILocalCoordConverter;
    function ChangeCenterToLocalPoint(
      const ASource: ILocalCoordConverter;
      const AVisualPoint: TPoint
    ): ILocalCoordConverter;
    function ChangeCenterLonLatAndProjection(
      const ASource: ILocalCoordConverter;
      const AProjection: IProjection;
      const ALonLat: TDoublePoint
    ): ILocalCoordConverter;
    function ChangeProjectionWithFreezeAtVisualPoint(
      const ASource: ILocalCoordConverter;
      const AProjection: IProjection;
      const AFreezePoint: TPoint
    ): ILocalCoordConverter;
    function ChangeProjectionWithFreezeAtCenter(
      const ASource: ILocalCoordConverter;
      const AProjection: IProjection
    ): ILocalCoordConverter;
    function ChangeProjectionWithScaleUpdate(
      const ASource: ILocalCoordConverter;
      const AProjection: IProjection
    ): ILocalCoordConverter;


    function CreateForTile(
      const AProjection: IProjection;
      const ATile: TPoint
    ): ILocalCoordConverter;
  end;

implementation

end.
