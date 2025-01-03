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

unit u_MarkerDrawableSimpleArrow;

interface

uses
  GR32,
  t_GeoTypes,
  u_MarkerDrawableSimpleAbstract;

type
  TMarkerDrawableSimpleArrow = class(TMarkerDrawableWithDirectionSimpleAbstract)
  protected
    function GetBoundsForPosition(
      const APosition: TDoublePoint;
      const AAngle: Double
    ): TRect; override;

    function DrawToBitmapWithDirection(
      ABitmap: TCustomBitmap32;
      const APosition: TDoublePoint;
      const AAngle: Double
    ): Boolean; override;
  end;

implementation

uses
  Types,
  Math,
  GR32_Polygons,
  GR32_Transforms,
  u_GeoFunc;

{ TMarkerDrawableSimpleArrow }

function TMarkerDrawableSimpleArrow.GetBoundsForPosition(
  const APosition: TDoublePoint;
  const AAngle: Double
): TRect;
const
  CInverseSqrtOfTwo = 1 / 1.4142135623730950488; // 1 / sqrt(2)
var
  VRadius: Double;
  VTargetDoubleRect: TDoubleRect;
begin
  // radius of the circle surrounding the square
  VRadius := Config.MarkerSize * CInverseSqrtOfTwo;

  VTargetDoubleRect.Left := APosition.X - VRadius;
  VTargetDoubleRect.Top := APosition.Y - VRadius;
  VTargetDoubleRect.Right := APosition.X + VRadius;
  VTargetDoubleRect.Bottom := APosition.Y + VRadius;

  Result := RectFromDoubleRect(VTargetDoubleRect, rrOutside);
end;

function TMarkerDrawableSimpleArrow.DrawToBitmapWithDirection(
  ABitmap: TCustomBitmap32;
  const APosition: TDoublePoint;
  const AAngle: Double
): Boolean;
var
  VPolygon: TArrayOfFloatPoint;
  VTransform: TAffineTransformation;
  VHalfSize: Double;
  VWidth: Double;
  VTargetRect: TRect;
begin
  VHalfSize := Config.MarkerSize / 2;
  VWidth := Config.MarkerSize / 3;

  VTargetRect := GetBoundsForPosition(APosition, AAngle);

  Types.IntersectRect(VTargetRect, ABitmap.ClipRect, VTargetRect);
  if Types.IsRectEmpty(VTargetRect) then begin
    Result := False;
    Exit;
  end;

  if not ABitmap.MeasuringMode then begin
    ABitmap.BeginUpdate;
    try
      VTransform := TAffineTransformation.Create;
      try
        VTransform.Rotate(APosition.X, APosition.Y, -AAngle);
        SetLength(VPolygon, 3);
        VPolygon[0] := VTransform.Transform(FloatPoint(APosition.X, APosition.Y - VHalfSize));
        VPolygon[1] := VTransform.Transform(FloatPoint(APosition.X - VWidth, APosition.Y + VHalfSize));
        VPolygon[2] := VTransform.Transform(FloatPoint(APosition.X + VWidth, APosition.Y + VHalfSize));
        PolygonFS(ABitmap, VPolygon, Config.MarkerColor);
        PolylineFS(ABitmap, VPolygon, Config.BorderColor, True);
      finally
        VTransform.Free;
      end;
    finally
      ABitmap.EndUpdate;
    end;
  end;
  ABitmap.Changed(VTargetRect);
  Result := True;
end;

end.
