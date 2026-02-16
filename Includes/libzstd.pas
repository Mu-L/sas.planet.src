unit libzstd;

interface

uses
  Windows,
  Classes,
  SysUtils;

type
  ELibZstdError = class(Exception);

const
  ZSTD_MIN_CLEVEL = 1;
  ZSTD_MAX_CLEVEL = 22;
  ZSTD_DEFAULT_CLEVEL = 3;
  ZSTD_FAST_MIN = -5; // ultra-fast

function CompressZstd(const AData: RawByteString; ACompressionLevel: Integer = ZSTD_DEFAULT_CLEVEL): RawByteString;
procedure DecompressZstd(const AData: Pointer; const ASize: NativeUInt; const ADest: TStream);

function LoadLibZstd(const ADllName: string = 'libzstd.dll'; const ARaiseException: Boolean = True): Boolean;
procedure UnLoadLibZstd;

function IsLibZstdLoaded: Boolean;

implementation

uses
  SyncObjs;

type
  PZSTD_DStream = Pointer;

  ZSTD_inBuffer = record
    src: Pointer;
    size: NativeUInt;
    pos: NativeUInt;
  end;

  ZSTD_outBuffer = record
    dst: Pointer;
    size: NativeUInt;
    pos: NativeUInt;
  end;

var
  ZSTD_compress: function(dst: Pointer; dstCapacity: NativeUInt; src: Pointer; srcSize: NativeUInt; ACompressionLevel: Integer): NativeUInt; cdecl;
  ZSTD_decompress: function(dst: Pointer; dstCapacity: NativeUInt; src: Pointer; compressedSize: NativeUInt): NativeUInt; cdecl;

  ZSTD_compressBound: function(srcSize: NativeUInt): NativeUInt; cdecl;
  ZSTD_getFrameContentSize: function(src: Pointer; srcSize: NativeUInt): UInt64; cdecl;

  ZSTD_isError: function(code: NativeUInt): Cardinal; cdecl;
  ZSTD_getErrorName: function(code: NativeUInt): PAnsiChar; cdecl;

  // Streaming decompression API
  ZSTD_createDStream: function: PZSTD_DStream; cdecl;
  ZSTD_freeDStream: function(zds: PZSTD_DStream): NativeUInt; cdecl;
  ZSTD_initDStream: function(zds: PZSTD_DStream): NativeUInt; cdecl;
  ZSTD_decompressStream: function(zds: PZSTD_DStream; var output: ZSTD_outBuffer; var input: ZSTD_inBuffer): NativeUInt; cdecl;
  ZSTD_DStreamInSize: function: NativeUInt; cdecl;
  ZSTD_DStreamOutSize: function: NativeUInt; cdecl;

const
  ZSTD_CONTENTSIZE_UNKNOWN = UInt64(-1);
  ZSTD_CONTENTSIZE_ERROR = UInt64(-2);

type
  TLibState = record
    FState: Integer;
    function GetValue: Integer; inline;
    procedure SetValue(const AValue: Integer); inline;
    property Value: Integer read GetValue write SetValue;
  end;

{ TLibState }

const
  LIBZSTD_STATE_NONE = 0;
  LIBZSTD_STATE_LOADED = 1;
  LIBZSTD_STATE_LOAD_ERROR = 2;

function TLibState.GetValue: Integer;
begin
  Result := InterlockedCompareExchange(FState, 0, 0);
end;

procedure TLibState.SetValue(const AValue: Integer);
begin
  InterlockedExchange(FState, AValue);
end;

var
  GState: TLibState;
  GHandle: THandle = 0;
  GLock: TCriticalSection;

function IsLibZstdLoaded: Boolean;
begin
  Result := GState.Value = LIBZSTD_STATE_LOADED;
end;

function LoadLibZstd(const ADllName: string; const ARaiseException: Boolean): Boolean;

  procedure GetProc(var AProcAddr: Pointer; const AProcName: string);
  begin
    AProcAddr := GetProcAddress(GHandle, PChar(AProcName));
    if not Assigned(AProcAddr) then begin
      raise ELibZstdError.Create('Cannot load function "' + AProcName + '" from ' + ADllName);
    end;
  end;

var
  VState: Integer;
begin
  VState := GState.Value;

  if VState = LIBZSTD_STATE_LOADED then begin
    Result := True;
    Exit;
  end;

  if VState = LIBZSTD_STATE_LOAD_ERROR then begin
    Result := False;
    Exit;
  end;

  GLock.Acquire;
  try
    VState := GState.Value;

    if VState = LIBZSTD_STATE_LOADED then begin
      Result := True;
      Exit;
    end;

    if VState = LIBZSTD_STATE_LOAD_ERROR then begin
      Result := False;
      Exit;
    end;

    GHandle := LoadLibrary(PChar(ADllName));
    try
      if GHandle = 0 then begin
        raise ELibZstdError.Create('Cannot load ' + ADllName);
      end;

      GetProc(@ZSTD_compress, 'ZSTD_compress');
      GetProc(@ZSTD_decompress, 'ZSTD_decompress');
      GetProc(@ZSTD_compressBound, 'ZSTD_compressBound');
      GetProc(@ZSTD_getFrameContentSize, 'ZSTD_getFrameContentSize');
      GetProc(@ZSTD_isError, 'ZSTD_isError');
      GetProc(@ZSTD_getErrorName, 'ZSTD_getErrorName');

      // Streaming decompression API
      GetProc(@ZSTD_createDStream, 'ZSTD_createDStream');
      GetProc(@ZSTD_freeDStream, 'ZSTD_freeDStream');
      GetProc(@ZSTD_initDStream, 'ZSTD_initDStream');
      GetProc(@ZSTD_decompressStream, 'ZSTD_decompressStream');
      GetProc(@ZSTD_DStreamInSize, 'ZSTD_DStreamInSize');
      GetProc(@ZSTD_DStreamOutSize, 'ZSTD_DStreamOutSize');

      GState.Value := LIBZSTD_STATE_LOADED;
      Result := True;
    except
      on E: Exception do begin
        GState.Value := LIBZSTD_STATE_LOAD_ERROR;

        if GHandle <> 0 then begin
          FreeLibrary(GHandle);
          GHandle := 0;
        end;

        if ARaiseException then begin
          raise;
        end else begin
          Result := False;
        end;
      end;
    end;
  finally
    GLock.Release;
  end;
end;

procedure UnLoadLibZstd;
begin
  GLock.Acquire;
  try
    GState.Value := LIBZSTD_STATE_NONE;

    @ZSTD_compress := nil;
    @ZSTD_decompress := nil;
    @ZSTD_compressBound := nil;
    @ZSTD_getFrameContentSize := nil;
    @ZSTD_isError := nil;
    @ZSTD_getErrorName := nil;

    // Streaming decompression API
    @ZSTD_createDStream := nil;
    @ZSTD_freeDStream := nil;
    @ZSTD_initDStream := nil;
    @ZSTD_decompressStream := nil;
    @ZSTD_DStreamInSize := nil;
    @ZSTD_DStreamOutSize := nil;

    if GHandle <> 0 then begin
      FreeLibrary(GHandle);
      GHandle := 0;
    end;
  finally
    GLock.Release;
  end;
end;

function CompressZstd(const AData: RawByteString; ACompressionLevel: Integer): RawByteString;
var
  VInputSize: NativeUInt;
  VMaxOutputSize: NativeUInt;
  VResult: NativeUInt;
begin
  Result := '';

  VInputSize := Length(AData);

  if VInputSize = 0 then begin
    Exit;
  end;

  // Validate compression level
  if ACompressionLevel < ZSTD_FAST_MIN then begin
    ACompressionLevel := ZSTD_FAST_MIN;
  end else
  if ACompressionLevel > ZSTD_MAX_CLEVEL then begin
    ACompressionLevel := ZSTD_MAX_CLEVEL;
  end;

  VMaxOutputSize := ZSTD_compressBound(VInputSize);

  // Allocate output buffer
  SetLength(Result, VMaxOutputSize);

  // Compress
  VResult := ZSTD_compress(PByte(Result), VMaxOutputSize, PByte(AData), VInputSize, ACompressionLevel);

  // Check for error
  if ZSTD_isError(VResult) <> 0 then begin
    Result := '';
    raise ELibZstdError.CreateFmt('Zstd compression failed: %s', [string(ZSTD_getErrorName(VResult))]);
  end;

  // Resize to actual compressed size
  SetLength(Result, VResult);
end;

procedure DecompressZstd(const AData: Pointer; const ASize: NativeUInt; const ADest: TStream);
const
  ZSTD_BLOCKSIZE_MAX = 131072; // 128 kB
const
  cMaxTrustedSize = 10 * 1024 * 1024; // 10 MB
var
  VResult: NativeUInt;
  VDecompressedSize: UInt64;
  VDStream: PZSTD_DStream;
  VInBuffer: ZSTD_inBuffer;
  VOutBuffer: ZSTD_outBuffer;
  VTempBuffer: array [0..ZSTD_BLOCKSIZE_MAX-1] of Byte;
begin
  if ASize = 0 then begin
    Exit;
  end;

  VDecompressedSize := ZSTD_getFrameContentSize(AData, ASize);

  if VDecompressedSize = ZSTD_CONTENTSIZE_ERROR then begin
    raise ELibZstdError.Create('Zstd decompression failed: invalid frame header!');
  end;

  if not (ADest is TMemoryStream) or
     (VDecompressedSize = ZSTD_CONTENTSIZE_UNKNOWN) or
     (VDecompressedSize > cMaxTrustedSize)
  then begin
    VDStream := ZSTD_createDStream;
    if VDStream = nil then begin
      raise ELibZstdError.Create('Failed to create Zstd decompression stream!');
    end;

    try
      VResult := ZSTD_initDStream(VDStream);
      if ZSTD_isError(VResult) <> 0 then begin
        raise ELibZstdError.CreateFmt('Failed to initialize Zstd decompression stream: %s', [string(ZSTD_getErrorName(VResult))]);
      end;

      VInBuffer.src := AData;
      VInBuffer.size := ASize;
      VInBuffer.pos := 0;

      repeat
        VOutBuffer.dst := @VTempBuffer[0];
        VOutBuffer.size := Length(VTempBuffer);
        VOutBuffer.pos := 0;

        VResult := ZSTD_decompressStream(VDStream, VOutBuffer, VInBuffer);

        if ZSTD_isError(VResult) <> 0 then begin
          raise ELibZstdError.CreateFmt('Zstd decompression failed: %s', [string(ZSTD_getErrorName(VResult))]);
        end;

        if VOutBuffer.pos > 0 then begin
          ADest.WriteBuffer(VTempBuffer[0], VOutBuffer.pos);
        end;

      until (VInBuffer.pos >= VInBuffer.size) and (VOutBuffer.pos <> VOutBuffer.size);
    finally
      ZSTD_freeDStream(VDStream);
    end;
  end else begin
    Assert(ADest is TMemoryStream);

    ADest.Size := VDecompressedSize; // Allocate output buffer

    VResult := ZSTD_decompress(TMemoryStream(ADest).Memory, VDecompressedSize, AData, ASize);

    if ZSTD_isError(VResult) <> 0 then begin
      raise ELibZstdError.CreateFmt('Zstd decompression failed: %s', [string(ZSTD_getErrorName(VResult))]);
    end;

    if VResult <> ADest.Size then begin
      ADest.Size := VResult;
    end;
  end;
end;

initialization
  GLock := TCriticalSection.Create;
  GState.FState := LIBZSTD_STATE_NONE;

finalization
  UnLoadLibZstd;
  FreeAndNil(GLock);

end.
