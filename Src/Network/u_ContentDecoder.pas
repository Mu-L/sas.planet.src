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

unit u_ContentDecoder;

interface

uses
  Classes,
  SysUtils;

type
  TContentDecoder = record
    class function GetDecodersStr: AnsiString; static; inline;

    class procedure DoDecodeGZip(var AContent: TMemoryStream); static;
    class procedure DoDecodeDeflate(var AContent: TMemoryStream); static;

    class procedure Decode(const AContentEncoding: AnsiString; var AContent: TMemoryStream); static;
  end;

  EContentDecoderError = class(Exception);

implementation

uses
  SynZip;

type
  TContentEncodingType = (
    etGZip,
    etDeflate,
    etBrotli,
    etZstd,
    etIdentity,
    etUnknown
  );

function GetEncodingType(const AContentEncoding: AnsiString): TContentEncodingType; inline;
begin
  if AContentEncoding = 'gzip' then begin
    Result := etGZip;
  end else
  if AContentEncoding = 'deflate' then begin
    Result := etDeflate;
  end else
  if AContentEncoding = 'br' then begin
    Result := etBrotli;
  end else
  if AContentEncoding = 'zstd' then begin
    Result := etZstd;
  end else
  if AContentEncoding = 'identity' then begin
    Result := etIdentity;
  end else begin
    Result := etUnknown;
  end;
end;

{ TContentDecoder }

class function TContentDecoder.GetDecodersStr: AnsiString;
begin
  Result := 'gzip, deflate';
end;

class procedure TContentDecoder.DoDecodeGZip(var AContent: TMemoryStream);
var
  VGZRead: TGZRead;
  VStream: TMemoryStream;
begin
  VStream := TMemoryStream.Create;
  try
    if VGZRead.Init(AContent.Memory, AContent.Size) and VGZRead.ToStream(VStream) then begin
      FreeAndNil(AContent);
      AContent := VStream;
      AContent.Position := 0;
      VStream := nil;
    end else begin
      raise EContentDecoderError.Create('Gzip decompression failed!');
    end;
  finally
    VStream.Free;
  end;
end;

class procedure TContentDecoder.DoDecodeDeflate(var AContent: TMemoryStream);
var
  VStream: TMemoryStream;
begin
  VStream := TMemoryStream.Create;
  try
    try
      UnCompressStream(AContent.Memory, AContent.Size, VStream, nil, True {as zlib format});
    except
      on E1: ESynZipException do begin
        VStream.Clear;
        try
          UnCompressStream(AContent.Memory, AContent.Size, VStream, nil, False {as raw deflate});
        except
          on E2: ESynZipException do begin
            raise EContentDecoderError.CreateFmt(
              'Deflate decompression failed (zlib and raw formats): %s | %s', [E1.Message, E2.Message]
            );
          end;
        end;
      end;
    end;
    FreeAndNil(AContent);
    AContent := VStream;
    AContent.Position := 0;
    VStream := nil;
  finally
    VStream.Free;
  end;
end;

procedure DoDecodeBrotli(var AContent: TMemoryStream);
begin
  // ToDo
  raise EContentDecoderError.Create('Brotli encoding is not supported yet.');
end;

procedure DoDecodeZstd(var AContent: TMemoryStream);
begin
  // ToDo
  raise EContentDecoderError.Create('Zstd encoding is not supported yet.');
end;

class procedure TContentDecoder.Decode(const AContentEncoding: AnsiString; var AContent: TMemoryStream);
var
  VEncoding: TContentEncodingType;
begin
  if (AContent.Size = 0) or (AContentEncoding = '') then begin
    Exit;
  end;

  AContent.Position := 0;

  VEncoding := GetEncodingType(AContentEncoding);

  case VEncoding of
    etGZip     : DoDecodeGZip(AContent);
    etDeflate  : DoDecodeDeflate(AContent);
    etBrotli   : DoDecodeBrotli(AContent);
    etZstd     : DoDecodeZstd(AContent);
    etIdentity : { nothing to do } ;
    etUnknown  : raise EContentDecoderError.CreateFmt('Unknown Content-Encoding: "%s"', [AContentEncoding]);
  else
    raise EContentDecoderError.CreateFmt('Unexpected encoding type value: %d', [Integer(VEncoding)]);
  end;
end;

end.
