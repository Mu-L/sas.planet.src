program CompressedDataGenerator;

{$APPTYPE CONSOLE}

uses
  SynZip,
  System.IOUtils,
  System.SysUtils;

const
  CRawData: RawByteString = 'This is a test data for TContentDecoder';

procedure DoCompress(const AData: RawByteString);
var
  VCompressed: RawByteString;
begin
  // uncompressed
  TFile.WriteAllBytes('raw.bin', BytesOf(AData));

  // raw deflate
  VCompressed := AData;
  SynZip.CompressDeflate(VCompressed, True);

  TFile.WriteAllBytes('deflate-raw.bin', BytesOf(VCompressed));

  // zlib
  VCompressed := AData;
  SynZip.CompressZLib(VCompressed, True);

  TFile.WriteAllBytes('deflate-zlib.bin', BytesOf(VCompressed));

  // gzip
  VCompressed := AData;
  SynZip.CompressGZip(VCompressed, True);

  TFile.WriteAllBytes('gzip.bin', BytesOf(VCompressed));
end;

begin
  try
    DoCompress(CRawData);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
