unit libbrotli;

{
  Brotli DLLs are separated into three files:
  - libbrotlienc.dll (encoder)
  - libbrotlidec.dll (decoder)
  - libbrotlicommon.dll (common)
}

interface

uses
  Windows,
  Classes,
  SysUtils;

type
  ELibBrotliError = class(Exception);

const
  BROTLI_MIN_QUALITY = 0;
  BROTLI_MAX_QUALITY = 11;
  BROTLI_DEFAULT_QUALITY = 6;
  BROTLI_DEFAULT_WINDOW = 22;

  BROTLI_MODE_GENERIC = 0;
  BROTLI_MODE_TEXT = 1;
  BROTLI_MODE_FONT = 2;

function CompressBrotli(const AData: RawByteString; AQuality: Integer = BROTLI_DEFAULT_QUALITY;
  AWindowBits: Integer = BROTLI_DEFAULT_WINDOW; AMode: Integer = BROTLI_MODE_GENERIC): RawByteString;

procedure DecompressBrotli(const AData: Pointer; const ASize: NativeUInt; const ADest: TStream);

function LoadLibBrotliEnc(const AEncDllName: string = 'libbrotlienc.dll'; const ARaiseException: Boolean = True): Boolean;
procedure UnloadLibBrotliEnc;

function LoadLibBrotliDec(const ADecDllName: string = 'libbrotlidec.dll'; const ARaiseException: Boolean = True): Boolean;
procedure UnloadLibBrotliDec;

function IsLibBrotliEncLoaded: Boolean;
function IsLibBrotliDecLoaded: Boolean;

implementation

uses
  SyncObjs;

var
  BrotliEncoderCompress: function(quality: Integer; lgwin: Integer; mode: Integer;
    input_size: NativeUInt; input_buffer: PByte; encoded_size: PNativeUInt; encoded_buffer: PByte): Integer; cdecl;
  BrotliEncoderMaxCompressedSize: function(input_size: NativeUInt): NativeUInt; cdecl;

type
  PPByte = ^PByte;
  PBrotliDecoderState = Pointer;
  TBrotliDecoderResult = Integer;
  TBrotliDecoderParameter = Integer;

var
  BrotliDecoderCreateInstance: function(alloc_func: Pointer; free_func: Pointer; opaque: Pointer): PBrotliDecoderState; cdecl;
  BrotliDecoderDestroyInstance: procedure(state: PBrotliDecoderState); cdecl;
  BrotliDecoderSetParameter: function(state: PBrotliDecoderState; param: TBrotliDecoderParameter; value: Cardinal): Integer; cdecl;
  BrotliDecoderDecompressStream: function(state: PBrotliDecoderState; available_in: PNativeUInt; next_in: PPByte;
    available_out: PNativeUInt; next_out: PPByte; total_out: PNativeUInt): TBrotliDecoderResult; cdecl;
  BrotliDecoderIsFinished: function(state: PBrotliDecoderState): Integer; cdecl;
  BrotliDecoderGetErrorCode: function(state: PBrotliDecoderState): Integer; cdecl;
  BrotliDecoderErrorString: function(code: Integer): PAnsiChar; cdecl;

const
  BROTLI_DECODER_RESULT_ERROR = 0;
  BROTLI_DECODER_RESULT_SUCCESS = 1;
  BROTLI_DECODER_RESULT_NEEDS_MORE_INPUT = 2;
  BROTLI_DECODER_RESULT_NEEDS_MORE_OUTPUT = 3;

  BROTLI_DECODER_PARAM_DISABLE_RING_BUFFER_REALLOCATION = 0;
  BROTLI_DECODER_PARAM_LARGE_WINDOW = 1;

type
  TLibState = record
    FState: Integer;
    function GetValue: Integer; inline;
    procedure SetValue(const AValue: Integer); inline;
    property Value: Integer read GetValue write SetValue;
  end;

const
  LIBBROTLI_STATE_NONE = 0;
  LIBBROTLI_STATE_LOADED = 1;
  LIBBROTLI_STATE_LOAD_ERROR = 2;

function TLibState.GetValue: Integer;
begin
  Result := InterlockedCompareExchange(FState, 0, 0);
end;

procedure TLibState.SetValue(const AValue: Integer);
begin
  InterlockedExchange(FState, AValue);
end;

var
  GStateEnc: TLibState;
  GHandleEnc: THandle = 0;

var
  GStateDec: TLibState;
  GHandleDec: THandle = 0;

var
  GLock: TCriticalSection;

function IsLibBrotliEncLoaded: Boolean;
begin
  Result := GStateEnc.Value = LIBBROTLI_STATE_LOADED;
end;

function IsLibBrotliDecLoaded: Boolean;
begin
  Result := GStateDec.Value = LIBBROTLI_STATE_LOADED;
end;

function LoadLibBrotliEnc(const AEncDllName: string; const ARaiseException: Boolean): Boolean;

  procedure GetProc(var AProcAddr: Pointer; const AProcName: string);
  begin
    AProcAddr := GetProcAddress(GHandleEnc, PChar(AProcName));
    if not Assigned(AProcAddr) then begin
      raise ELibBrotliError.Create('Cannot load function "' + AProcName + '" from ' + AEncDllName);
    end;
  end;

var
  VState: Integer;
begin
  VState := GStateEnc.Value;

  if VState = LIBBROTLI_STATE_LOADED then begin
    Result := True;
    Exit;
  end;

  if VState = LIBBROTLI_STATE_LOAD_ERROR then begin
    Result := False;
    Exit;
  end;

  GLock.Acquire;
  try
    VState := GStateEnc.Value;
    if VState = LIBBROTLI_STATE_LOADED then begin
      Result := True;
      Exit;
    end;

    if VState = LIBBROTLI_STATE_LOAD_ERROR then begin
      Result := False;
      Exit;
    end;

    try
      GHandleEnc := LoadLibrary(PChar(AEncDllName));
      if GHandleEnc = 0 then begin
        raise ELibBrotliError.Create('Cannot load ' + AEncDllName);
      end;

      // Get encoder function pointers
      GetProc(@BrotliEncoderCompress, 'BrotliEncoderCompress');
      GetProc(@BrotliEncoderMaxCompressedSize, 'BrotliEncoderMaxCompressedSize');

      GStateEnc.Value := LIBBROTLI_STATE_LOADED;
      Result := True;
    except
      on E: Exception do begin
        GStateEnc.Value := LIBBROTLI_STATE_LOAD_ERROR;

        if GHandleEnc <> 0 then begin
          FreeLibrary(GHandleEnc);
          GHandleEnc := 0;
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

function LoadLibBrotliDec(const ADecDllName: string; const ARaiseException: Boolean): Boolean;

  procedure GetProc(var AProcAddr: Pointer; const AProcName: string);
  begin
    AProcAddr := GetProcAddress(GHandleDec, PChar(AProcName));
    if not Assigned(AProcAddr) then
      raise ELibBrotliError.Create('Cannot load function "' + AProcName + '" from ' + ADecDllName);
  end;

var
  VState: Integer;
begin
  VState := GStateDec.Value;

  if VState = LIBBROTLI_STATE_LOADED then
  begin
    Result := True;
    Exit;
  end;

  if VState = LIBBROTLI_STATE_LOAD_ERROR then
  begin
    Result := False;
    Exit;
  end;

  GLock.Acquire;
  try
    VState := GStateDec.Value;
    if VState = LIBBROTLI_STATE_LOADED then
    begin
      Result := True;
      Exit;
    end;

    if VState = LIBBROTLI_STATE_LOAD_ERROR then
    begin
      Result := False;
      Exit;
    end;

    try
      GHandleDec := LoadLibrary(PChar(ADecDllName));
      if GHandleDec = 0 then begin
        raise ELibBrotliError.Create('Cannot load ' + ADecDllName);
      end;

      // Get decoder function pointers
      GetProc(@BrotliDecoderCreateInstance, 'BrotliDecoderCreateInstance');
      GetProc(@BrotliDecoderDestroyInstance, 'BrotliDecoderDestroyInstance');
      GetProc(@BrotliDecoderSetParameter, 'BrotliDecoderSetParameter');
      GetProc(@BrotliDecoderDecompressStream, 'BrotliDecoderDecompressStream');
      GetProc(@BrotliDecoderIsFinished, 'BrotliDecoderIsFinished');
      GetProc(@BrotliDecoderGetErrorCode, 'BrotliDecoderGetErrorCode');
      GetProc(@BrotliDecoderErrorString, 'BrotliDecoderErrorString');

      GStateDec.Value := LIBBROTLI_STATE_LOADED;
      Result := True;
    except
      on E: Exception do begin
        GStateDec.Value := LIBBROTLI_STATE_LOAD_ERROR;

        if GHandleDec <> 0 then begin
          FreeLibrary(GHandleDec);
          GHandleDec := 0;
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

procedure UnloadLibBrotliEnc;
begin
  GLock.Acquire;
  try
    GStateEnc.Value := LIBBROTLI_STATE_NONE;

    @BrotliEncoderCompress := nil;
    @BrotliEncoderMaxCompressedSize := nil;

    if GHandleEnc <> 0 then begin
      FreeLibrary(GHandleEnc);
      GHandleEnc := 0;
    end;
  finally
    GLock.Release;
  end;
end;

procedure UnloadLibBrotliDec;
begin
  GLock.Acquire;
  try
    GStateDec.Value := LIBBROTLI_STATE_NONE;

    @BrotliDecoderCreateInstance := nil;
    @BrotliDecoderDestroyInstance := nil;
    @BrotliDecoderSetParameter := nil;
    @BrotliDecoderDecompressStream := nil;
    @BrotliDecoderIsFinished := nil;
    @BrotliDecoderGetErrorCode := nil;
    @BrotliDecoderErrorString := nil;

    if GHandleDec <> 0 then begin
      FreeLibrary(GHandleDec);
      GHandleDec := 0;
    end;
  finally
    GLock.Release;
  end;
end;

function CompressBrotli(const AData: RawByteString; AQuality, AWindowBits, AMode: Integer): RawByteString;
var
  VInputSize: NativeUInt;
  VOutputSize: NativeUInt;
  VMaxOutputSize: NativeUInt;
  VSuccess: Integer;
begin
  Result := '';

  VInputSize := Length(AData);
  if VInputSize = 0 then begin
    Exit;
  end;

  // Validate quality
  if AQuality < BROTLI_MIN_QUALITY then begin
    AQuality := BROTLI_MIN_QUALITY;
  end else
  if AQuality > BROTLI_MAX_QUALITY then begin
    AQuality := BROTLI_MAX_QUALITY;
  end;

  VMaxOutputSize := BrotliEncoderMaxCompressedSize(VInputSize);
  if VMaxOutputSize = 0 then begin
    raise ELibBrotliError.CreateFmt('Input is too large for one-shot API (size = %d bytes)!', [VInputSize]);
  end;

  SetLength(Result, VMaxOutputSize);
  VOutputSize := VMaxOutputSize;

  VSuccess := BrotliEncoderCompress(AQuality, AWindowBits, AMode, VInputSize, PByte(AData),
    @VOutputSize, PByte(Result));

  if VSuccess = 0 then begin
    Result := '';
    raise ELibBrotliError.Create('Brotli compression failed!');
  end;

  SetLength(Result, VOutputSize);
end;

procedure DecompressBrotli(const AData: Pointer; const ASize: NativeUInt; const ADest: TStream);
const
  BUFFER_SIZE = 65536; // 64 kB
var
  VState: PBrotliDecoderState;
  VResult: TBrotliDecoderResult;
  VAvailableIn: NativeUInt;
  VNextIn: PByte;
  VAvailableOut: NativeUInt;
  VNextOut: PByte;
  VBuffer: array [0..BUFFER_SIZE-1] of Byte;
  VErrorCode: Integer;
  VProduced: NativeUInt;
begin
  if (ASize = 0) or not Assigned(AData) then begin
    Exit;
  end;

  VState := BrotliDecoderCreateInstance(nil, nil, nil);
  if not Assigned(VState) then begin
    raise ELibBrotliError.Create('Failed to create Brotli decoder instance!');
  end;

  try
    if BrotliDecoderSetParameter(VState, BROTLI_DECODER_PARAM_LARGE_WINDOW, 1) = 0 then begin
      raise ELibBrotliError.Create('Failed to set Brotli decoder parameter!');
    end;

    VAvailableIn := ASize;
    VNextIn := AData;

    repeat
      VAvailableOut := Length(VBuffer);
      VNextOut := @VBuffer[0];

      VResult := BrotliDecoderDecompressStream(VState, @VAvailableIn, @VNextIn, @VAvailableOut, @VNextOut, nil);

      if VResult = BROTLI_DECODER_RESULT_ERROR then begin
        VErrorCode := BrotliDecoderGetErrorCode(VState);
        raise ELibBrotliError.CreateFmt('Brotli decompression failed: %s', [string(BrotliDecoderErrorString(VErrorCode))]);
      end;

      VProduced := PAnsiChar(VNextOut) - PAnsiChar(@VBuffer[0]);
      if VProduced > 0 then begin
        ADest.WriteBuffer(VBuffer[0], VProduced);
      end;

      if VResult = BROTLI_DECODER_RESULT_SUCCESS then begin
        Break; // Decompression finished successfully
      end;

    until (VResult = BROTLI_DECODER_RESULT_NEEDS_MORE_INPUT) and (VAvailableIn = 0);

    if BrotliDecoderIsFinished(VState) = 0 then begin
      // Handle case where stream ends but brotli expects more data
      if VResult <> BROTLI_DECODER_RESULT_SUCCESS then begin
        VErrorCode := BrotliDecoderGetErrorCode(VState);
        if VErrorCode <> 0 then begin
          raise ELibBrotliError.CreateFmt('Brotli stream error: %s', [string(BrotliDecoderErrorString(VErrorCode))]);
        end;
      end;
    end;
  finally
    BrotliDecoderDestroyInstance(VState);
  end;
end;

initialization
  GLock := TCriticalSection.Create;
  GStateEnc.FState := LIBBROTLI_STATE_NONE;
  GStateDec.FState := LIBBROTLI_STATE_NONE;

finalization
  UnloadLibBrotliEnc;
  UnloadLibBrotliDec;
  FreeAndNil(GLock);

end.
