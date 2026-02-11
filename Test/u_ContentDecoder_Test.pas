unit u_ContentDecoder_Test;

interface

uses
  TestFramework,
  Classes,
  SysUtils,
  u_SASTestCase;

type
  TestContentDecoder = class(TSASTestCase)
  private
    FUncompressed: TMemoryStream;
    procedure TestDecode(const AEncoding: AnsiString; const ATestDataFileName: string);
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestDecodeGZip;
    procedure TestDecodeZlibDeflate;
    procedure TestDecodeRawDeflate;
  end;

implementation

uses
  u_ContentDecoder;

const
  CTestDataPath = '.\..\..\Test\data\compressed\';

  CUncompressedFileName = 'raw.bin';

  CGZipFileName = 'gzip.bin';
  CRawDeflateFileName = 'deflate-raw.bin';
  CZlibDeflateFileName = 'deflate-zlib.bin';

function GetTestDataFullFileName(const AFileName: string): string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + CTestDataPath + AFileName;
  Result := ExpandFileName(Result); // Normalize path (resolve ..\ components)
end;

{ TestContentDecoder }

procedure TestContentDecoder.SetUp;
var
  VFileName: string;
begin
  VFileName := GetTestDataFullFileName(CUncompressedFileName);

  if not FileExists(VFileName) then begin
    raise Exception.Create('Uncompressed file not found: ' + VFileName);
  end;

  FUncompressed := TMemoryStream.Create;
  FUncompressed.LoadFromFile(VFileName);
end;

procedure TestContentDecoder.TearDown;
begin
  FreeAndNil(FUncompressed);
end;

procedure TestContentDecoder.TestDecode(const AEncoding: AnsiString; const ATestDataFileName: string);
var
  VFileName: string;
  VContent: TMemoryStream;
begin
  VFileName := GetTestDataFullFileName(ATestDataFileName);

  if not FileExists(VFileName) then begin
    CheckTrue(False, 'Test data file not found: ' + VFileName);
  end;

  VContent := TMemoryStream.Create;
  try
    VContent.LoadFromFile(VFileName);
    VContent.Position := 0;

    TContentDecoder.Decode(AEncoding, VContent);

    VContent.Position := 0;
    FUncompressed.Position := 0;

    CheckStreamsEqual(
      VContent,
      FUncompressed,
      Format('Decompressed content does not match original (encoding: %s)', [AEncoding])
    );
  finally
    VContent.Free;
  end;
end;

procedure TestContentDecoder.TestDecodeGZip;
begin
  TestDecode('gzip', CGZipFileName);
end;

procedure TestContentDecoder.TestDecodeZlibDeflate;
begin
  // 'deflate' encoding per RFC 2616/7230 refers to zlib-wrapped deflate format
  TestDecode('deflate', CZlibDeflateFileName);
end;

procedure TestContentDecoder.TestDecodeRawDeflate;
begin
  // Raw deflate (without zlib header) is successfully handled by TContentDecoder.
  // Note: the decoder may internally attempt zlib format first, catch a decompression exception,
  // and then fall back to raw deflate. This is expected behavior.
  // The debugger might break on the internal handled exception - simply continue execution.
  // The test itself must pass without raising any unhandled exceptions.
  TestDecode('deflate', CRawDeflateFileName);
end;

initialization
  RegisterTest(TestContentDecoder.Suite);

end.
