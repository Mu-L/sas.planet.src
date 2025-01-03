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

unit u_PascalScriptTypes;

interface

uses
  uPSRuntime,
  uPSCompiler;

procedure CompileTimeReg_CommonTypes(const APSComp: TPSPascalCompiler);
procedure CompileTimeReg_ProjConverter(const APSComp: TPSPascalCompiler);
procedure CompileTimeReg_ProjConverterFactory(const APSComp: TPSPascalCompiler);
procedure CompileTimeReg_CoordConverterSimple(const APSComp: TPSPascalCompiler);
procedure CompileTimeReg_SimpleHttpDownloader(const APSComp: TPSPascalCompiler);
procedure CompileTimeReg_PascalScriptGlobal(const APSComp: TPSPascalCompiler);
procedure CompileTimeReg_PascalScriptLogger(const APSComp: TPSPascalCompiler);
procedure CompileTimeReg_PascalScriptTileCache(const APSComp: TPSPascalCompiler);

implementation

uses
  i_ProjConverter,
  i_PascalScriptGlobal,
  i_PascalScriptLogger,
  i_PascalScriptTileCache,
  i_CoordConverterSimple,
  i_SimpleHttpDownloader;

procedure CompileTimeReg_CommonTypes(const APSComp: TPSPascalCompiler);
begin
  APSComp.AddTypeS('TPoint', 'record X, Y: Integer; end;');
  APSComp.AddTypeS('TDoublePoint', 'record X, Y: Double; end;');
  APSComp.AddTypeS('TRect', 'record Left, Top, Right, Bottom: Integer; end;');
  APSComp.AddTypeS('TDoubleRect', 'record Left, Top, Right, Bottom: Double; end;');
end;

procedure CompileTimeReg_ProjConverter(const APSComp: TPSPascalCompiler);
begin
  with APSComp.AddInterface(APSComp.FindInterface('IUnknown'), IProjConverter, 'IProjConverter') do begin
    RegisterMethod('function LonLat2XY(const AProjLP: TDoublePoint): TDoublePoint', cdRegister);
    RegisterMethod('function XY2LonLat(const AProjXY: TDoublePoint): TDoublePoint', cdRegister);
  end;
end;

procedure CompileTimeReg_ProjConverterFactory(const APSComp: TPSPascalCompiler);
begin
  with APSComp.AddInterface(APSComp.FindInterface('IUnknown'), IProjConverterFactory, 'IProjConverterFactory') do begin
    RegisterMethod('function GetByEPSG(const AEPSG: Integer): IProjConverter', cdRegister);
    RegisterMethod('function GetByInitString(const AArgs: AnsiString): IProjConverter', cdRegister);
  end;
end;

procedure CompileTimeReg_CoordConverterSimple(const APSComp: TPSPascalCompiler);
begin
  with APSComp.AddInterface(APSComp.FindInterface('IUnknown'), ICoordConverterSimple, 'ICoordConverter') do begin
    RegisterMethod('function Pos2LonLat(const XY: TPoint; Azoom: byte): TDoublePoint', cdStdCall);
    RegisterMethod('function LonLat2Pos(const Ll: TDoublePoint; Azoom: byte): Tpoint', cdStdCall);

    RegisterMethod('function LonLat2Metr(const Ll: TDoublePoint): TDoublePoint', cdStdCall);
    RegisterMethod('function Metr2LonLat(const Mm: TDoublePoint): TDoublePoint', cdStdCall);

    RegisterMethod('function TilesAtZoom(AZoom: byte): Longint', cdStdCall);
    RegisterMethod('function PixelsAtZoom(AZoom: byte): Longint', cdStdCall);

    RegisterMethod('function TilePos2PixelPos(const XY: TPoint; Azoom: byte): TPoint', cdStdCall);
    RegisterMethod('function TilePos2PixelRect(const XY: TPoint; Azoom: byte): TRect', cdStdCall);
  end;
end;

procedure CompileTimeReg_SimpleHttpDownloader(const APSComp: TPSPascalCompiler);
begin
  with APSComp.AddInterface(APSComp.FindInterface('IUnknown'), ISimpleHttpDownloader, 'ISimpleHttpDownloader') do begin
    RegisterMethod('function DoHttpRequest(const ARequestUrl, ARequestHeader, APostData: AnsiString; out AResponseHeader, AResponseData: AnsiString): Cardinal', cdRegister);
  end;
end;

procedure CompileTimeReg_PascalScriptGlobal(const APSComp: TPSPascalCompiler);
var
  VIntf: TPSInterface;
begin
  VIntf := APSComp.AddInterface(
    APSComp.FindInterface('IUnknown'), IPascalScriptGlobal, 'IPascalScriptGlobal'
  );
  with VIntf do begin
    RegisterMethod('procedure Lock;', cdRegister);
    RegisterMethod('procedure Unlock;', cdRegister);

    RegisterMethod('procedure LockRead;', cdRegister);
    RegisterMethod('procedure UnlockRead;', cdRegister);

    RegisterMethod('procedure SetVar(const AVarID: Integer; const AValue: Variant);', cdRegister);
    RegisterMethod('procedure SetVarTS(const AVarID: Integer; const AValue: Variant);', cdRegister);

    RegisterMethod('function GetVar(const AVarID: Integer): Variant;', cdRegister);
    RegisterMethod('function GetVarTS(const AVarID: Integer): Variant;', cdRegister);

    RegisterMethod('function Exists(const AVarID: Integer): Boolean;', cdRegister);
    RegisterMethod('function ExistsTS(const AVarID: Integer): Boolean;', cdRegister);
  end;
end;

procedure CompileTimeReg_PascalScriptLogger(const APSComp: TPSPascalCompiler);
var
  VIntf: TPSInterface;
begin
  VIntf := APSComp.AddInterface(
    APSComp.FindInterface('IUnknown'), IPascalScriptLogger, 'IPascalScriptLogger'
  );
  with VIntf do begin
    RegisterMethod('procedure Write(const AStr: AnsiString);', cdRegister);
    RegisterMethod('procedure WriteFmt(const AFormat: string; const AArgs: array of const);', cdRegister);
  end;
end;

procedure CompileTimeReg_PascalScriptTileCache(const APSComp: TPSPascalCompiler);
var
  VIntf: TPSInterface;
begin
  APSComp.AddTypeS(
    'TTileInfo',
    'record' +
    ' IsExists    : Boolean;' +
    ' IsExistsTne : Boolean;' +
    ' LoadDate    : Int64;' +
    ' Size        : Cardinal;' +
    ' Version     : string;' +
    ' ContentType : AnsiString;' +
    ' Data        : AnsiString; ' +
    'end;'
  );

  VIntf := APSComp.AddInterface(
    APSComp.FindInterface('IUnknown'), IPascalScriptTileCache, 'IPascalScriptTileCache'
  );
  with VIntf do begin
    RegisterMethod(
      'function Read(' +
        'const X: Integer;' +
        'const Y: Integer;' +
        'const AZoom: Byte;' +
        'const AVersion: string;' +
        'const AWithData: Boolean' +
      '): TTileInfo;', cdRegister
    );
    RegisterMethod(
      'function Write(' +
        'const X: Integer;' +
        'const Y: Integer;' +
        'const AZoom: Byte;' +
        'const AVersion: string;' +
        'const AContentType: AnsiString;' +
        'const AData: AnsiString;' +
        'const AIsOverwrite: Boolean' +
      '): Boolean;', cdRegister
    );
    RegisterMethod(
      'function WriteTne(' +
        'const X: Integer;' +
        'const Y: Integer;' +
        'const AZoom: Byte;' +
        'const AVersion: string' +
      '): Boolean;', cdRegister
    );
    RegisterMethod(
      'function Delete(' +
        'const X: Integer;' +
        'const Y: Integer;' +
        'const AZoom: Byte;' +
        'const AVersion: string' +
      '): Boolean;', cdRegister
    );
  end;
end;

end.
