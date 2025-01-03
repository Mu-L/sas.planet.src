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

unit u_MarkerDrawableSimpleAbstract;

interface

uses
  GR32,
  t_GeoTypes,
  i_MarkerDrawable,
  i_MarkerSimpleConfig,
  u_BaseInterfacedObject;

type
  TMarkerDrawableSimpleBaseAbstract = class(TBaseInterfacedObject)
  private
    FConfig: IMarkerSimpleConfigStatic;
  protected
    property Config: IMarkerSimpleConfigStatic read FConfig;
  public
    constructor Create(const AConfig: IMarkerSimpleConfigStatic); virtual;
  end;

  TMarkerDrawableSimpleAbstract = class(TMarkerDrawableSimpleBaseAbstract, IMarkerDrawable)
  protected
    function GetBoundsForPosition(
      const APosition: TDoublePoint
    ): TRect; virtual; abstract;

    function DrawToBitmap(
      ABitmap: TCustomBitmap32;
      const APosition: TDoublePoint
    ): Boolean; virtual; abstract;
  end;

  TMarkerDrawableSimpleAbstractClass = class of TMarkerDrawableSimpleAbstract;

  TMarkerDrawableWithDirectionSimpleAbstract = class(TMarkerDrawableSimpleBaseAbstract, IMarkerDrawableWithDirection)
  protected
    function GetBoundsForPosition(
      const APosition: TDoublePoint;
      const AAngle: Double
    ): TRect; virtual; abstract;

    function DrawToBitmapWithDirection(
      ABitmap: TCustomBitmap32;
      const APosition: TDoublePoint;
      const AAngle: Double
    ): Boolean; virtual; abstract;
  end;

  TMarkerDrawableWithDirectionSimpleAbstractClass = class of TMarkerDrawableWithDirectionSimpleAbstract;


implementation

{ TMarkerDrawableSimpleBaseAbstract }

constructor TMarkerDrawableSimpleBaseAbstract.Create(
  const AConfig: IMarkerSimpleConfigStatic
);
begin
  inherited Create;
  FConfig := AConfig;
end;

end.
