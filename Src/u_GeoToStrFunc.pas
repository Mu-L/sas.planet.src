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

unit u_GeoToStrFunc;

interface

uses
  SysUtils,
  t_GeoTypes,
  u_AnsiStr;

function RoundEx(const ANumber: Double; const ADigits: Integer): string; inline;
function RoundExAnsi(const ANumber: Double; const ADigits: Integer): AnsiString;

function R2StrPoint(const r: Double): string; inline;
function R2AnsiStrPoint(const r: Double): AnsiString;

function LonLat2GShListName(const ALonLat: TDoublePoint; AScale: Integer; APrec: Integer): string;
function str2r(const AStrValue: string): Double;

// forced with point
function StrPointToFloat(const S: string): Double; inline;
function TryStrPointToFloat(const S: string; out AValue: Double): Boolean; inline;

type
  TGeoToStrFunc = record
  private
    class var FFormatSettings: TFormatSettings;
    class var FFormatSettingsA: TFormatSettingsA;
  end;

implementation

uses
  Math;

function RoundEx(const ANumber: Double; const ADigits: Integer): string;
begin
  if IsNan(ANumber) then begin
    Result := '-';
  end else begin
    // The Precision parameter specifies the precision of the given value.
    // It should be 7 or less for values of type Single, 15 or less for values of type 'Double,
    // and 18 or less for values of type Extended.
    // https://docwiki.embarcadero.com/Libraries/Sydney/en/System.SysUtils.FloatToStrF
    Result := FloatToStrF(ANumber, ffFixed, 15, ADigits, TGeoToStrFunc.FFormatSettings);
  end;
end;

function RoundExAnsi(const ANumber: Double; const ADigits: Integer): AnsiString;
begin
  if IsNan(ANumber) then begin
    Result := '-';
  end else begin
    Result := FloatToStrFA(ANumber, ffFixed, 15, ADigits, TGeoToStrFunc.FFormatSettingsA);
  end;
end;

function str2r(const AStrValue: string): Double;
var
  VPos: Integer;
  VFormatSettings: TFormatSettings;
begin
  if Length(AStrValue) = 0 then begin
    Result := 0;
  end else begin
    VPos := System.Pos(',', AStrValue);
    if VPos > 0 then begin
      VFormatSettings.DecimalSeparator := ',';
    end else begin
      VPos := System.Pos('.', AStrValue);
      if VPos > 0 then begin
        VFormatSettings.DecimalSeparator := '.';
      end else begin
        VFormatSettings.DecimalSeparator := FormatSettings.DecimalSeparator;
      end;
    end;
    Result := StrToFloatDef(AStrValue, 0, VFormatSettings);
  end;
end;

function StrPointToFloat(const S: string): Double;
begin
  Result := StrToFloat(S, TGeoToStrFunc.FFormatSettings);
end;

function TryStrPointToFloat(const S: string; out AValue: Double): Boolean;
begin
  Result := TryStrToFloat(S, AValue, TGeoToStrFunc.FFormatSettings);
end;

function R2StrPoint(const r: Double): string;
begin
  Result := FloatToStr(r, TGeoToStrFunc.FFormatSettings);
end;

function R2AnsiStrPoint(const r: Double): AnsiString;
begin
  Result := FloatToStrA(r, TGeoToStrFunc.FFormatSettingsA);
end;

function LonLat2GShListName(const ALonLat: TDoublePoint; AScale: Integer; APrec: Integer): string;
const
  cRomans: array[1..36] of string = (
    'I','II','III','IV','V','VI','VII','VIII','IX','X','XI',
    'XII','XIII','XIV','XV','XVI','XVII','XVIII','XIX','XX',
    'XXI','XXII','XXIII','XXIV','XXV','XXVI','XXVII','XXVIII',
    'XXIX','XXX','XXXI','XXXII','XXXIII','XXXIV','XXXV','XXXVI'
  );

var
  VLon, VLat: Int64;

  function GetNameAtom(divr, modl: Integer): Integer;
  begin
    Result :=
      ((VLon div Round(6/divr*APrec)) mod modl)+
      (Abs(Integer(ALonLat.Y>0)*(modl-1)-((VLat div Round(4/divr*APrec)) mod modl)))*modl;
  end;

  function AChr(const AValue: Integer): AnsiChar;
  begin
    Result := {$IFDEF UNICODE} AnsiChar(AValue) {$ELSE} Chr(AValue) {$ENDIF} ;
  end;

begin
  VLon := Round((ALonLat.X+180)*APrec);
  VLat := Round(Abs(ALonLat.Y*APrec));
  Result := AChr(65+(VLat div (4*APrec)))+'-'+IntToStr(1+(VLon div (6*APrec)));
  if ALonLat.Y < 0 then Result := 'x'+ Result;
  if AScale = 500000  then Result := Result +'-'+AChr(192+GetNameAtom(2,2));
  if AScale = 200000  then Result := Result +'-'+cRomans[1+GetNameAtom(6,6)];
  if AScale <= 100000 then Result := Result +'-'+IntToStr(1+GetNameAtom(12,12));
  if AScale <= 50000  then Result := Result +'-'+AChr(192+GetNameAtom(24,2));
  if AScale <= 25000  then Result := Result +'-'+AChr(224+GetNameAtom(48,2));
  if AScale = 10000   then Result := Result+'-'+IntToStr(1+GetNameAtom(96,2));

  if AScale = 5000 then
    Result :=
      AChr(65+(VLat div (4*APrec)))+'-'+
      IntToStr(1+(VLon div (6*APrec)))+'-'+
      IntToStr(1+GetNameAtom(12,12))+'-'+
      '('+IntToStr(1+GetNameAtom(192,16))+')';

  if AScale = 2500 then
    Result :=
      AChr(65+(VLat div (4*APrec)))+'-'+
      IntToStr(1+(VLon div (6*APrec)))+'-'+
      IntToStr(1+GetNameAtom(12,12))+'-'+
      '('+IntToStr(1+GetNameAtom(192,16))+'-'+AChr(224+GetNameAtom(384,2))+')';
end;

initialization
  TGeoToStrFunc.FFormatSettings.DecimalSeparator := '.';
  TGeoToStrFunc.FFormatSettingsA.DecimalSeparator := '.';

end.
