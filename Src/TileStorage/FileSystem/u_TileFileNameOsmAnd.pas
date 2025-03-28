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

unit u_TileFileNameOsmAnd;

interface

uses
  Types,
  Windows,
  i_TileFileNameParser,
  i_TileFileNameGenerator,
  u_TileFileNameBase;

type
  TTileFileNameOsmAnd = class(TTileFileNameBase)
  protected
    function GetTileFileName(
      AXY: TPoint;
      AZoom: Byte
    ): string; override;

    function GetTilePoint(
      const ATileFileName: AnsiString;
      out ATileXY: TPoint;
      out ATileZoom: Byte
    ): Boolean; override;

    function AddExt(const AFileName, AExt: String): String; override;
  end;

implementation

uses
  RegExpr,
  SysUtils,
  u_AnsiStr;

const
  c_OsmAnd_Expr = '^(.+\\)?(\d\d?)\\(\d+)\\(\d+)(\..+)?$';

{ TTileFileNameOsmAnd }

function TTileFileNameOsmAnd.GetTileFileName(
  AXY: TPoint;
  AZoom: Byte
): string;
begin
  Result := Format('%d' + PathDelim + '%d' + PathDelim + '%d', [
    AZoom,
    AXY.X,
    AXY.Y
    ]);
end;

function TTileFileNameOsmAnd.GetTilePoint(
  const ATileFileName: AnsiString;
  out ATileXY: TPoint;
  out ATileZoom: Byte
): Boolean;
var
  VRegExpr: TRegExpr;
begin
  VRegExpr := TRegExpr.Create;
  try
    VRegExpr.Expression := c_OsmAnd_Expr;
    if VRegExpr.Exec(ATileFileName) then begin
      ATileZoom := StrToIntA(VRegExpr.Match[2]);
      ATileXY.X := StrToIntA(VRegExpr.Match[3]); // (!) X - first, Y - last
      ATileXY.Y := StrToIntA(VRegExpr.Match[4]);
      Result := True;
    end else begin
      Result := False;
    end;
  finally
    VRegExpr.Free;
  end;
end;

function TTileFileNameOsmAnd.AddExt(const AFileName, AExt: String): String;
const
  CTneFileExt = '.tne';
var
  Ext: String;
begin
  if SameFileName(AExt, CTneFileExt) then begin
    Ext := AExt;
  end else begin
    Ext := AExt + '.tile';
  end;
  Result := inherited AddExt(AFileName, Ext);
end;

end.
