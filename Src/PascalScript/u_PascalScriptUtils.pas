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

unit u_PascalScriptUtils;

interface

uses
  uPSRuntime,
  uPSCompiler;

procedure CompileTimeReg_Utils(const APSComp: TPSPascalCompiler);
procedure ExecTimeReg_Utils(const APSExec: TPSExec);

implementation

uses
  SysUtils,
  StrUtils,
  Classes,
  DateUtils,
  MD5,
  u_AnsiStr,
  u_GeoToStrFunc,
  u_NetworkStrFunc,
  u_StrFunc;

procedure CompileTimeReg_Utils(const APSComp: TPSPascalCompiler);
begin
  // SysUtils
  APSComp.AddDelphiFunction('function IntToHex(Value: Integer; Digits: Integer): string');
  APSComp.AddDelphiFunction('function FileExists(const FileName: string): Boolean');
  APSComp.AddDelphiFunction('function Format(const Format: string; const Args: array of const): string');
  APSComp.AddDelphiFunction('function FormatEx(const Format: string; const Args: array of const; const ADecimalSeparator: Char): string');

  // StrUtils
  APSComp.AddDelphiFunction('function PosEx(const SubStr, S: string; Offset: Integer): Integer');

  // u_AnsiStr
  APSComp.AddTypeS('TReplaceFlag', '(rfReplaceAll, rfIgnoreCase)');
  APSComp.AddTypeS('TReplaceFlags', 'set of TReplaceFlag');
  APSComp.AddDelphiFunction('function StringReplace(const S, OldPattern, NewPattern: AnsiString; Flags: TReplaceFlags): AnsiString');

  // MD5
  APSComp.AddDelphiFunction('function MD5String(const AStr: AnsiString): String');

  // u_GeoToStrFunc
  APSComp.AddDelphiFunction('function RoundEx(const chislo: Double; const Precision: Integer): String');

  // u_StrFunc
  APSComp.AddDelphiFunction('function GetAfter(const SubStr, Str: AnsiString): AnsiString');
  APSComp.AddDelphiFunction('function GetBefore(const SubStr, Str: AnsiString): AnsiString');
  APSComp.AddDelphiFunction('function GetBetween(const Str, After, Before: AnsiString): AnsiString');

  // u_NetworkStrFunc
  APSComp.AddDelphiFunction('function SetHeaderValue(const AHeaders, AName, AValue: AnsiString): AnsiString');
  APSComp.AddDelphiFunction('function GetHeaderValue(const AHeaders, AName: AnsiString): AnsiString');
  APSComp.AddDelphiFunction('function DeleteHeaderEntry(const AHeaders, AName: AnsiString): AnsiString');

  // internal routines
  APSComp.AddDelphiFunction('function SubStrPos(const Str, SubStr: AnsiString; FromPos: Integer): Integer');

  APSComp.AddDelphiFunction('function GetNumberAfter(const ASubStr, AText: string): string');
  APSComp.AddDelphiFunction('function GetDiv3Path(const ANumber: string): string');

  APSComp.AddDelphiFunction('function GetUnixTime: Int64');
  APSComp.AddDelphiFunction('function SaveToLocalFile(const AFullLocalFilename: string; const AData: AnsiString): Integer');
end;

function SetHeaderValue_P(const AHeaders, AName, AValue: AnsiString): AnsiString;
var
  VHeaders: RawByteString;
  VNameUp: RawByteString;
begin
  VHeaders := AHeaders;
  VNameUp := UpperCaseA(AName);
  if ReplaceHeaderValueUp(VHeaders, VNameUp, AValue) then begin
    Result := VHeaders;
  end else begin
    Result := AName + ': ' + AValue + #13#10 + AHeaders;
  end;
end;

function GetHeaderValue_P(const AHeaders, AName: AnsiString): AnsiString;
var
  VNameUp: RawByteString;
begin
  VNameUp := UpperCaseA(AName);
  Result := GetHeaderValueUp(AHeaders, VNameUp);
end;

function DeleteHeaderEntry_P(const AHeaders, AName: AnsiString): AnsiString;
var
  VHeaders: RawByteString;
  VNameUp: RawByteString;
begin
  VHeaders := AHeaders;
  VNameUp := UpperCaseA(AName);
  DeleteHeaderValueUp(VHeaders, VNameUp);
  Result := VHeaders;
end;

function SubStrPos_P(const Str, SubStr: AnsiString; FromPos: Integer): Integer;
begin
  Result := PosA(SubStr, Str, FromPos);
end;

function GetNumberAfter_P(const ASubStr, AText: string): string;
var
  VPos: Integer;
begin
  Result := '';
  VPos := System.Pos(ASubStr, AText);
  if (VPos > 0) then begin
    VPos := VPos + Length(ASubStr);
    while ((VPos <= System.Length(AText)) and CharInSet(AText[VPos], ['0', '1'..'9'])) do begin
      Result := Result + AText[VPos];
      Inc(VPos);
    end;
  end;
end;

function GetDiv3Path_P(const ASource: string): string;
var
  i: Integer;
begin
  Result := '';

  if (0 < Length(ASource)) then begin
    for i := Length(ASource) downto 1 do begin
      if (0 = ((Length(ASource) - i) mod 3)) then begin
        Result := '\' + Result;
      end;
      Result := ASource[i] + Result;
    end;
  end;

  if (Length(Result) > 0) then begin
    if ('\' = Result[1]) then begin
      System.Delete(Result, 1, 1);
    end;
  end;

  i := System.Pos('\', Result);
  if (i < 4) then begin
    System.Delete(Result, 1, i);
  end;
end;

function GetUnixTime_P: Int64;
begin
  Result := DateTimeToUnix(now);
end;

function SaveToLocalFile_P(
  const AFullLocalFilename: string;
  const AData: AnsiString
): Integer;
var
  VPath: String;
  VStream: TFileStream;
  VSize: Integer;
begin
  try
    VPath := ExtractFilePath(AFullLocalFilename);
    if (not DirectoryExists(VPath)) then begin
      ForceDirectories(VPath);
    end;
    VStream := TFileStream.Create(AFullLocalFilename, fmCreate);
    try
      VSize := Length(AData);
      if VSize > 0 then begin
        VStream.WriteBuffer(AData[1], VSize);
      end;
      Result := VSize;
    finally
      VStream.Free;
    end;
  except
    Result := 0;
  end;
end;

function MD5String_P(const AStr: AnsiString): string;
begin
  Result := MD5DigestToStr(MD5Buffer(PAnsiChar(AStr)^, Length(AStr)));
end;

function IntToHex_P(AValue: Integer; ADigits: Integer): string;
begin
  Result := IntToHex(AValue, ADigits);
end;

function Format_P(const Format: string; const Args: array of const): string;
begin
  Result := SysUtils.Format(Format, Args);
end;

function FormatEx_P(const Format: string; const Args: array of const;
  const ADecimalSeparator: Char): string;
var
  VFormatSettings: TFormatSettings;
begin
  VFormatSettings.DecimalSeparator := ADecimalSeparator;
  Result := SysUtils.Format(Format, Args, VFormatSettings);
end;

procedure ExecTimeReg_Utils(const APSExec: TPSExec);
begin
  // SysUtils
  APSExec.RegisterDelphiFunction(@IntToHex_P, 'IntToHex', cdRegister);
  APSExec.RegisterDelphiFunction(@FileExists, 'FileExists', cdRegister);
  APSExec.RegisterDelphiFunction(@Format_P, 'Format', cdRegister);
  APSExec.RegisterDelphiFunction(@FormatEx_P, 'FormatEx', cdRegister);

  // StrUtils
  APSExec.RegisterDelphiFunction(@StrUtils.PosEx, 'PosEx', cdRegister);

  // MD5
  APSExec.RegisterDelphiFunction(@MD5String_P, 'MD5String', cdRegister);

  // u_GeoToStrFunc
  APSExec.RegisterDelphiFunction(@RoundEx, 'RoundEx', cdRegister);

  // u_StrFunc
  APSExec.RegisterDelphiFunction(@GetAfter, 'GetAfter', cdRegister);
  APSExec.RegisterDelphiFunction(@GetBefore, 'GetBefore', cdRegister);
  APSExec.RegisterDelphiFunction(@GetBetween, 'GetBetween', cdRegister);

  APSExec.RegisterDelphiFunction(@SetHeaderValue_P, 'SetHeaderValue', cdRegister);
  APSExec.RegisterDelphiFunction(@GetHeaderValue_P, 'GetHeaderValue', cdRegister);
  APSExec.RegisterDelphiFunction(@DeleteHeaderEntry_P, 'DeleteHeaderEntry', cdRegister);

  // u_AnsiStr
  APSExec.RegisterDelphiFunction(@StringReplaceA, 'StringReplace', cdRegister);

  // internal routines
  APSExec.RegisterDelphiFunction(@SubStrPos_P, 'SubStrPos', cdRegister);

  APSExec.RegisterDelphiFunction(@GetNumberAfter_P, 'GetNumberAfter', cdRegister);
  APSExec.RegisterDelphiFunction(@GetDiv3Path_P, 'GetDiv3Path', cdRegister);

  APSExec.RegisterDelphiFunction(@GetUnixTime_P, 'GetUnixTime', cdRegister);
  APSExec.RegisterDelphiFunction(@SaveToLocalFile_P, 'SaveToLocalFile', cdRegister);
end;

end.
