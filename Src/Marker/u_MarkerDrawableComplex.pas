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

unit u_MarkerDrawableComplex;

interface

uses
  Types,
  GR32,
  t_GeoTypes,
  i_MarkerDrawable,
  u_BaseInterfacedObject;

type
  TMarkerDrawableComplex = class(TBaseInterfacedObject, IMarkerDrawable)
  private
    FMarkerFirst: IMarkerDrawable;
    FMarkerSecond: IMarkerDrawable;
  private
    function GetBoundsForPosition(const APosition: TDoublePoint): TRect;
    function DrawToBitmap(
      ABitmap: TCustomBitmap32;
      const APosition: TDoublePoint
    ): Boolean;
  public
    constructor Create(
      const AMarkerFirst: IMarkerDrawable;
      const AMarkerSecond: IMarkerDrawable
    );
  end;

implementation

{ TMarkerDrawableComplex }

constructor TMarkerDrawableComplex.Create(
  const AMarkerFirst, AMarkerSecond: IMarkerDrawable
);
begin
  Assert(AMarkerFirst <> nil);
  Assert(AMarkerSecond <> nil);
  inherited Create;
  FMarkerFirst := AMarkerFirst;
  FMarkerSecond := AMarkerSecond;
end;

function TMarkerDrawableComplex.DrawToBitmap(
  ABitmap: TCustomBitmap32;
  const APosition: TDoublePoint
): Boolean;
begin
  Result := False;
  if FMarkerFirst.DrawToBitmap(ABitmap, APosition) then begin
    Result := True;
  end;
  if FMarkerSecond.DrawToBitmap(ABitmap, APosition) then begin
    Result := True;
  end;
end;

function TMarkerDrawableComplex.GetBoundsForPosition(
  const APosition: TDoublePoint
): TRect;
begin
  GR32.UnionRect(
    Result,
    FMarkerFirst.GetBoundsForPosition(APosition),
    FMarkerSecond.GetBoundsForPosition(APosition)
  );
end;

end.
