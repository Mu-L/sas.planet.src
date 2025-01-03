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

unit u_WindowLayerSunCalcYearInfo;

interface

uses
  Types,
  GR32,
  u_WindowLayerSunCalcInfoBase;

type
  TWindowLayerSunCalcYearInfo = class(TWindowLayerSunCalcInfoBase)
  private
    FIsValid: Boolean;
    FRect: TRect;
    FCircle, FMaxAlt, FMinAlt, FPoly: TArrayOfFloatPoint;
  protected
    procedure InvalidateLayer; override;
    procedure PaintLayer(ABuffer: TBitmap32); override;
  public
    procedure AfterConstruction; override;
  end;

implementation

uses
  GR32_Polygons,
  u_GR32Func;

{ TWindowLayerSunCalcYearInfo }

procedure TWindowLayerSunCalcYearInfo.AfterConstruction;
begin
  inherited;
  FRepaintOnDayChange := False;
  FRepaintOnTimeChange := False;
  FRepaintOnLocationChange := True;
end;

procedure TWindowLayerSunCalcYearInfo.InvalidateLayer;
var
  VRect: TFloatRect;
  VCenter: TFloatPoint;
begin
  if FIsValid then begin
    FIsValid := False;
    DoInvalidateRect(FRect); // erase
  end;

  FIsValid := Visible and FShapesGenerator.IsIntersectScreenRect;

  if FIsValid then begin
    FShapesGenerator.ValidateCache;
    FShapesGenerator.GetCirclePoints(FCircle);
    FShapesGenerator.GetMinMaxAltitudePoints(FMinAlt, FMaxAlt, FPoly);

    VCenter := FShapesGenerator.GetCalcCenter;
    VRect := FloatRect(VCenter, VCenter);

    UpdateRectByArrayOfFloatPoint(VRect, FCircle);
    UpdateRectByArrayOfFloatPoint(VRect, FMinAlt);
    UpdateRectByArrayOfFloatPoint(VRect, FMaxAlt);
    UpdateRectByArrayOfFloatPoint(VRect, FPoly);

    FRect := MakeRect(VRect, GR32.TRectRounding.rrOutside);

    // draw
    if FMainFormState.IsMapMoving then begin
      DoInvalidateFull;
    end else begin
      DoInvalidateRect(FRect);
    end;
  end;
end;

procedure TWindowLayerSunCalcYearInfo.PaintLayer(ABuffer: TBitmap32);
begin
  if not FIsValid then begin
    Exit;
  end;

  if ABuffer.MeasuringMode then begin
    ABuffer.Changed(FRect);
    Exit;
  end;

  ABuffer.BeginUpdate;
  try
    // Draw background circle
    if Length(FCircle) > 0 then begin
      PolylineFS(ABuffer, FCircle, FShapesColors.YearCircleColor, True);
    end;

    // Draw minimum altitude
    if Length(FMinAlt) > 0 then begin
      PolylineFS(ABuffer, FMinAlt, FShapesColors.YearPolyLinesColor, False);
    end;

    // Draw maximum altitude
    if Length(FMaxAlt) > 0 then begin
      PolylineFS(ABuffer, FMaxAlt, FShapesColors.YearPolyLinesColor, False);
    end;

    // Draw a transparent polygon between the minimum and maximum altitude curves
    if Length(FPoly) > 0 then begin
      PolygonFS(ABuffer, FPoly, FShapesColors.YearPolygonFillColor);
    end;
  finally
    ABuffer.EndUpdate;
  end;
end;

end.
