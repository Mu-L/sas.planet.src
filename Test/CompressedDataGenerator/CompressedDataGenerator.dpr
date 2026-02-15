program CompressedDataGenerator;

{$APPTYPE CONSOLE}

uses
  Winapi.Windows,
  System.IOUtils,
  System.SysUtils,
  System.Zlib,
  SynZip,
  libzstd in '..\..\Includes\libzstd.pas',
  libbrotli in '..\..\Includes\libbrotli.pas';

const
  COutputPath = '..\..\Test\data\compressed\';

const
  CRawData: RawByteString = 'This is a test data for TContentDecoder';

procedure DoCompress(const AData: RawByteString; const APath: string);

  procedure SaveData(const AFileName: string; const AContent: RawByteString);
  begin
    TFile.WriteAllBytes(APath + AFileName, BytesOf(AContent));

    var VCrc32 := System.Zlib.crc32(0, PByte(AContent), Length(AContent));
    Writeln(AFileName, ': ', Length(AContent), ' bytes; crc32: 0x', IntToHex(VCrc32, 8));
  end;

var
  VCompressed: RawByteString;
begin
  // uncompressed
  SaveData('raw.bin', AData);

  // raw deflate
  VCompressed := AData;
  SynZip.CompressDeflate(VCompressed, True);
  SaveData('deflate-raw.bin', VCompressed);

  // zlib
  VCompressed := AData;
  SynZip.CompressZLib(VCompressed, True);
  SaveData('deflate-zlib.bin', VCompressed);

  // gzip
  VCompressed := AData;
  SynZip.CompressGZip(VCompressed, True);
  SaveData('gzip.bin', VCompressed);

  // zstd
  if LoadLibZstd then begin
    VCompressed := CompressZstd(AData);
    SaveData('zstd.bin', VCompressed);
  end;

  // brotli
  if LoadLibBrotliEnc then begin
    VCompressed := CompressBrotli(AData);
    SaveData('brotli.bin', VCompressed);
  end;
end;

begin
  try
    var VAppPath := ExtractFilePath(ParamStr(0));
    var VDllPath := VAppPath + 'lib' + {$IFDEF WIN32} '32' {$ELSE} '64' {$ENDIF} + '\';
    var VOutPath := ExpandFileName(VAppPath + COutputPath);

    Writeln('App path: ', VAppPath);
    Writeln('Dll path: ', VDllPath);
    Writeln('Out path: ', VOutPath);
    Writeln;

    SetDllDirectory(PChar(VDllPath));

    DoCompress(CRawData, VOutPath);
  except
    on E: Exception do begin
      Writeln(E.ClassName, ': ', E.Message);
    end;
  end;

  Writeln;
  Writeln('Press ENTER to exit...');
  Readln;
end.
