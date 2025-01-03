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

unit u_BitmapMarkerProviderByCaptionForMarks;

interface

uses
  GR32,
  i_BitmapMarker,
  i_BitmapMarkerProviderByCaption;

type
  TBitmapMarkerProviderByCaptionForMarks = class(TInterfacedObject, IBitmapMarkerProviderByCaption)
  private
    FFontSize: Integer;
    FTextColor: TColor32;
    FTextBgColor: TColor32;
    FSolidBgDraw: Boolean;

    FBitmapWithText: TBitmap32;
  private
    function GetMarker(const ACaption: string): IBitmapMarker;
  public
    constructor Create(
      AFontSize: Integer;
      ATextColor: TColor32;
      ATextBgColor: TColor32;
      ASolidBgDraw: Boolean
    );
  end;


implementation

uses
  GR32_Resamplers;

{ TBitmapMarkerProviderByCaptionForMarks }

constructor TBitmapMarkerProviderByCaptionForMarks.Create(
  AFontSize: Integer;
  ATextColor, ATextBgColor: TColor32;
  ASolidBgDraw: Boolean
);
begin
  inherited Create;
  FFontSize := AFontSize;
  FTextColor := ATextColor;
  FTextBgColor := ATextBgColor;
  FSolidBgDraw := ASolidBgDraw;

  FBitmapWithText := TBitmap32.Create;
  FBitmapWithText.Font.Name := 'Tahoma';
  FBitmapWithText.Font.Style := [];
  FBitmapWithText.DrawMode := dmBlend;
  FBitmapWithText.CombineMode := cmMerge;
  FBitmapWithText.Font.Size := CMaxFontSize;
  FBitmapWithText.Resampler := TLinearResampler.Create;
end;

function TBitmapMarkerProviderByCaptionForMarks.GetMarker(
  const ACaption: string): IBitmapMarker;
begin

end;

end.
