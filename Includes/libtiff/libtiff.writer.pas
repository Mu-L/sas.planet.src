unit libtiff.writer;

interface

uses
  Types,
  SysUtils,
  Math,
  libtiff,
  libgeotiff;

type
  TTiffType = (
    ttClassicTiff,
    ttBigTiff
  );

  TTiffStorageType = (
    tstStripped,
    tstTiled
  );

  TTiffCompression = (
    tcNone,
    tcZip,
    tcLzw,
    tcJpeg
  );

  TTiffColorSpace = (
    tcsRGB,
    tcsYCbCr
  );

  TGetLineCallBack = function(
    const ARowNumber: Integer;
    const AOverView: Integer;
    out AData: Pointer;
    out ADataSize: NativeInt
  ): Boolean of object;

  TGetTileCallBack = function(
    const X, Y: Integer;
    const AOverView: Integer;
    out AData: Pointer;
    out ADataSize: NativeInt
  ): Boolean of object;

  TProjectionInfo = record
    EPSG: Integer;
    IsGeographic: Boolean;
    CellIncrementX: Double;
    CellIncrementY: Double;
    OriginX: Double;
    OriginY: Double;
  end;
  PProjectionInfo = ^TProjectionInfo;

  TTiffWriterParams = record
    TiffType: TTiffType;
    OutputFileName: string;
    ImageWidth: Integer;
    ImageHeight: Integer;
    TileWidth: Integer;
    TileHeight: Integer;
    OverViews: TIntegerDynArray;
    Compression: TTiffCompression;
    CompressionLevel: Integer;
    ColorSpace: TTiffColorSpace;
    GetLineCallBack: TGetLineCallBack;
    GetTileCallBack: TGetTileCallBack;
    StoreAlpha: Boolean;
    ProjectionInfo: PProjectionInfo;
    SoftwareId: AnsiString;
    WriteRawData: Boolean;
    WriteRawOverview: Boolean;
  end;
  PTiffWriterParams = ^TTiffWriterParams;

  TTiffWriter = class(TObject)
  private
    FParams: TTiffWriterParams;
    FWidth: Integer;
    FHeight: Integer;
    FWriteRawData: Boolean;
    FStorageType: TTiffStorageType;
    FErrorMessage: string;
    procedure SetupParams(
      const AParams: PTiffWriterParams
    );
    procedure CheckpointTiffDirectory(
      const ATiff: PTIFF
    ); inline;
    procedure WriteTIFFDirectory(
      const ATiff: PTIFF;
      const AIsSubImage: Boolean = False
    );
    procedure WriteGeoKeys(
      const ATiff: PTIFF;
      const AGTiff: PGTIFF;
      const AProjectionInfo: PProjectionInfo
    );
    function WriteImage(
      const ATiff: PTIFF;
      const AOverView: Integer = 0
    ): Boolean;
    function DoWrite: Boolean;
  public
    function WriteStripped(
      const AParams: PTiffWriterParams;
      out AErrorMessage: string
    ): Boolean;
    function WriteTiled(
      const AParams: PTiffWriterParams;
      out AErrorMessage: string
    ): Boolean;
  public
    constructor Create(
      const ALibTiffDllName: string = libtiff_dll;
      const ALibGeoTiffDllName: string = libgeotiff_dll
    );
  end;

const
  CTiffWriterParamsEmpty: TTiffWriterParams = (
    TiffType         : ttClassicTiff;
    OutputFileName   : '';
    ImageWidth       : 0;
    ImageHeight      : 0;
    TileWidth        : 256;
    TileHeight       : 256;
    OverViews        : nil;
    Compression      : tcNone;
    CompressionLevel : -1;
    ColorSpace       : tcsRGB;
    GetLineCallBack  : nil;
    GetTileCallBack  : nil;
    StoreAlpha       : False;
    ProjectionInfo   : nil;
    SoftwareId       : '';
    WriteRawData     : False;
    WriteRawOverview : False;
  );

implementation

{ TTiffWriter }

constructor TTiffWriter.Create(
  const ALibTiffDllName: string;
  const ALibGeoTiffDllName: string
);
begin
  inherited Create;

  InitLibTiff(ALibTiffDllName);
  InitLibGeoTiff(ALibGeoTiffDllName);
end;

procedure TTiffWriter.SetupParams(const AParams: PTiffWriterParams);
begin
  FParams := AParams^;

  Assert(FParams.OutputFileName <> '');
  Assert(FParams.ImageWidth > 0);
  Assert(FParams.ImageHeight > 0);

  if FParams.StoreAlpha and (FParams.Compression = tcJpeg) then begin
    Assert(False);
    FParams.StoreAlpha := False;
  end;

  if (FParams.ColorSpace = tcsYCbCr) and (FParams.Compression <> tcJpeg) then begin
    Assert(False);
    FParams.ColorSpace := tcsRGB;
  end;

  FWidth := FParams.ImageWidth;
  FHeight := FParams.ImageHeight;

  FWriteRawData := FParams.WriteRawData;
end;

procedure TTiffWriter.CheckpointTiffDirectory(const ATiff: PTIFF);
begin
  if not FWriteRawData and (FParams.Compression = tcJpeg) then begin
    // Calling Checkpoint before writing a tile or strip causes TIFF corruption
    // (jpeg quantization table overwrites tile data)
    Exit;
  end;

  TIFFCheckpointDirectory(ATiff);
end;

function TTiffWriter.WriteStripped(
  const AParams: PTiffWriterParams;
  out AErrorMessage: string
): Boolean;
begin
  if not Assigned(AParams.GetLineCallBack) then begin
    Assert(False);
    Result := False;
    Exit;
  end;

  FStorageType := tstStripped;
  SetupParams(AParams);

  Result := Self.DoWrite;
  if not Result then begin
    AErrorMessage := FErrorMessage;
  end;
end;

function TTiffWriter.WriteTiled(
  const AParams: PTiffWriterParams;
  out AErrorMessage: string
): Boolean;
begin
  if not Assigned(AParams.GetTileCallBack) then begin
    Assert(False);
    Result := False;
    Exit;
  end;

  FStorageType := tstTiled;
  SetupParams(AParams);

  Result := Self.DoWrite;
  if not Result then begin
    AErrorMessage := FErrorMessage;
  end;
end;

function TTiffWriter.DoWrite: Boolean;
var
  I: Integer;
  VTiff: PTIFF;
  VGTiff: PGTIFF;
  VMode: AnsiString;
  VOverView: Integer;
begin
  Result := False;
  FErrorMessage := '';

  if FParams.ProjectionInfo <> nil then begin
    XTIFFInitialize; // Registration of a GeoTIFF extension with libtiff
  end;

  VMode := 'w';
  if FParams.TiffType = ttBigTiff then begin
    VMode := VMode + '8';
  end;

  {$IFDEF UNICODE}
  VTiff := TIFFOpenW(PWideChar(FParams.OutputFileName), PAnsiChar(VMode));
  {$ELSE}
  VTiff := TIFFOpen(PAnsiChar(FParams.OutputFileName), PAnsiChar(VMode));
  {$IFEND}

  if VTiff = nil then begin
    FErrorMessage := 'TIFFOpen() failed!';
    Exit;
  end;

  try
    WriteTIFFDirectory(VTiff);

    if FParams.ProjectionInfo <> nil then begin
      VGTiff := GTIFNew(VTiff);
      if VGTiff = nil then begin
        FErrorMessage := 'GTIFNew() failed!';
        Exit;
      end;
      try
        WriteGeoKeys(VTiff, VGTiff, FParams.ProjectionInfo);
      finally
        GTIFFree(VGTiff);
      end;
    end;

    Result := WriteImage(VTiff);
    if not Result then begin
      Exit;
    end;

    // write sub-images
    for I := 0 to Length(FParams.OverViews) - 1 do begin
      FWriteRawData := FParams.WriteRawOverview;

      VOverView := FParams.OverViews[I]; // 2, 4, 8, 16, 32, 64 etc

      FWidth := Ceil(FParams.ImageWidth / VOverView);
      FHeight := Ceil(FParams.ImageHeight / VOverView);

      if (FWidth < FParams.TileWidth) or (FHeight < FParams.TileHeight) then begin
        Break;
      end;

      WriteTIFFDirectory(VTiff, True);

      Result := WriteImage(VTiff, VOverView);
      if not Result then begin
        Exit;
      end;
    end;
  finally
    TIFFClose(VTiff);
  end;
end;

procedure TTiffWriter.WriteTIFFDirectory(
  const ATiff: PTIFF;
  const AIsSubImage: Boolean
);

  procedure _SetCompression;
  var
    VCompression: Word;
  begin
    case FParams.Compression of
      tcZip: VCompression := COMPRESSION_ADOBE_DEFLATE;
      tcLzw: VCompression := COMPRESSION_LZW;
      tcJpeg: VCompression := COMPRESSION_JPEG;
    else
      VCompression := COMPRESSION_NONE;
    end;

    TIFFSetField(ATiff, TIFFTAG_COMPRESSION, VCompression);

    if FParams.CompressionLevel >= 0 then begin
      Assert( SizeOf(FParams.CompressionLevel) = 4 );
      case VCompression of
        COMPRESSION_JPEG: begin
          TIFFSetField(ATiff, TIFFTAG_JPEGQUALITY, FParams.CompressionLevel); // 0..100
        end;
        COMPRESSION_ADOBE_DEFLATE, COMPRESSION_DEFLATE: begin
          TIFFSetField(ATiff, TIFFTAG_ZIPQUALITY, FParams.CompressionLevel); // 0..9
        end;
      end;
    end;
  end;

  procedure _SetColorspace;
  begin
    if FParams.ColorSpace = tcsRGB then begin
      if FWriteRawData and (FParams.Compression = tcJpeg) then begin
        TIFFSetField(ATiff, TIFFTAG_PHOTOMETRIC, PHOTOMETRIC_YCBCR);
      end else begin
        TIFFSetField(ATiff, TIFFTAG_PHOTOMETRIC, PHOTOMETRIC_RGB);
      end;
    end else begin // YCbCr
      TIFFSetField(ATiff, TIFFTAG_PHOTOMETRIC, PHOTOMETRIC_YCBCR);
      TIFFSetField(ATiff, TIFFTAG_YCBCRSUBSAMPLING, 2, 2);
      if FParams.Compression = tcJpeg then begin
        TIFFSetField(ATiff, TIFFTAG_JPEGCOLORMODE, JPEGCOLORMODE_RGB);
      end;
    end;
  end;

  procedure _SetRowsPerStrip;
  var
    VRowsPerStrip: Word;
  begin
    VRowsPerStrip := 1;
    if FParams.ColorSpace = tcsYCbCr then begin
      VRowsPerStrip := 2;
    end;
    if FParams.Compression = tcJpeg then begin
      VRowsPerStrip := VRowsPerStrip * 8; // value must be multiply 8
    end;
    TIFFSetField(ATiff, TIFFTAG_ROWSPERSTRIP, VRowsPerStrip);
  end;

var
  VExtras: array of Word;
  VTiePoints: array [0..5] of Double;
  VPixScale: array [0..2] of Double;
begin
  if (FParams.SoftwareId <> '') and not AIsSubImage then begin
    TIFFSetField(ATiff, TIFFTAG_SOFTWARE, PAnsiChar(FParams.SoftwareId));
  end;

	TIFFSetField(ATiff, TIFFTAG_IMAGEWIDTH, FWidth);
	TIFFSetField(ATiff, TIFFTAG_IMAGELENGTH, FHeight);

  if FStorageType = tstTiled then begin
    TIFFSetField(ATiff, TIFFTAG_TILEWIDTH, FParams.TileWidth);
    TIFFSetField(ATiff, TIFFTAG_TILELENGTH, FParams.TileHeight);
  end else begin
    _SetRowsPerStrip;
  end;

  if FParams.StoreAlpha then begin
    SetLength(VExtras, 1);
    VExtras[0] := EXTRASAMPLE_ASSOCALPHA;
    TIFFSetField(ATiff, TIFFTAG_SAMPLESPERPIXEL, 4);
    TIFFSetField(ATiff, TIFFTAG_EXTRASAMPLES, 1, VExtras);
  end else begin
    TIFFSetField(ATiff, TIFFTAG_SAMPLESPERPIXEL, 3);
  end;

  TIFFSetField(ATiff, TIFFTAG_PLANARCONFIG, PLANARCONFIG_CONTIG);
  TIFFSetField(ATiff, TIFFTAG_BITSPERSAMPLE, 8);
  TIFFSetField(ATiff, TIFFTAG_SAMPLEFORMAT, SAMPLEFORMAT_UINT);
  //TIFFSetField(ATiff, TIFFTAG_ORIENTATION, ORIENTATION_TOPLEFT);

  // Always setup Compression before Colorspace
  _SetCompression;
  _SetColorspace;

  if (FParams.ProjectionInfo <> nil) and not AIsSubImage then begin
    // GeoTiff info in Tiff Directory
    VTiePoints[0] := 0;
    VTiePoints[1] := 0;
    VTiePoints[2] := 0;
    VTiePoints[3] := FParams.ProjectionInfo.OriginX;
    VTiePoints[4] := FParams.ProjectionInfo.OriginY;
    VTiePoints[5] := 0;

    VPixScale[0] := FParams.ProjectionInfo.CellIncrementX;
    VPixScale[1] := FParams.ProjectionInfo.CellIncrementY;
    VPixScale[2] := 0;

    TIFFSetField(ATiff, TIFFTAG_GEOTIEPOINTS, 6, VTiePoints);
    TIFFSetField(ATiff, TIFFTAG_GEOPIXELSCALE, 3, VPixScale);
  end;

  if AIsSubImage then begin
    TIFFSetField(ATiff, TIFFTAG_SUBFILETYPE, FILETYPE_REDUCEDIMAGE);
  end;

  CheckpointTiffDirectory(ATiff);
end;

procedure TTiffWriter.WriteGeoKeys(
  const ATiff: PTIFF;
  const AGTiff: PGTIFF;
  const AProjectionInfo: PProjectionInfo
);
const
  cWGS84_a: Double = 6378137;
  cWGS84_b: Double = 6356752.314245;
  cWGS84_f: Double = 298.257223560493;
var
  VEpsg: Word;
  VProjCSCitation: AnsiString;
begin
  Assert(AProjectionInfo <> nil);
  Assert(AProjectionInfo.EPSG > 0);
  Assert(AProjectionInfo.EPSG < $FFFF);

  VEpsg := Word(AProjectionInfo.EPSG);
  VProjCSCitation := 'EPSG:' + AnsiString(IntToStr(VEpsg));

  if not AProjectionInfo.IsGeographic then begin
    GTIFKeySet(AGTiff, GTModelTypeGeoKey, TYPE_SHORT, 1, ModelTypeProjected);
    GTIFKeySet(AGTiff, GTRasterTypeGeoKey, TYPE_SHORT, 1, RasterPixelIsArea);
    GTIFKeySet(AGTiff, GTCitationGeoKey, TYPE_ASCII, 0, PAnsiChar(VProjCSCitation));

    GTIFKeySet(AGTiff, ProjectedCSTypeGeoKey, TYPE_SHORT, 1, VEpsg);
    GTIFKeySet(AGTiff, ProjLinearUnitsGeoKey, TYPE_SHORT, 1, Linear_Meter);
  end else begin
    GTIFKeySet(AGTiff, GTModelTypeGeoKey, TYPE_SHORT, 1, ModelTypeGeographic);
    GTIFKeySet(AGTiff, GTRasterTypeGeoKey, TYPE_SHORT, 1, RasterPixelIsArea);
    GTIFKeySet(AGTiff, GTCitationGeoKey, TYPE_ASCII, 0, PAnsiChar(VProjCSCitation));

    GTIFKeySet(AGTiff, GeographicTypeGeoKey, TYPE_SHORT, 1, GCS_WGS_84);
    GTIFKeySet(AGTiff, GeogAngularUnitsGeoKey, TYPE_SHORT, 1, Angular_Degree);

    GTIFKeySet(AGTiff, GeogEllipsoidGeoKey, TYPE_SHORT, 1, Ellipse_WGS_84);
    GTIFKeySet(AGTiff, GeogSemiMajorAxisGeoKey, TYPE_DOUBLE, 1, cWGS84_a);
    GTIFKeySet(AGTiff, GeogSemiMinorAxisGeoKey, TYPE_DOUBLE, 1, cWGS84_b);
    GTIFKeySet(AGTiff, GeogInvFlatteningGeoKey, TYPE_DOUBLE, 1, cWGS84_f);
  end;

  GTIFWriteKeys(AGTiff);
  CheckpointTiffDirectory(ATiff);
end;

function TTiffWriter.WriteImage(
  const ATiff: PTIFF;
  const AOverView: Integer
): Boolean;
var
  I: Integer;
  X, Y: Integer;
  W, H: Integer;
  VData: Pointer;
  VSize: NativeInt;
  VTileNum: Cardinal;
begin
  Result := False;

  if FStorageType = tstStripped then begin
    for I := 0 to FHeight - 1 do begin
      if not FParams.GetLineCallBack(I, AOverView, VData, VSize) then begin
        FErrorMessage := 'Aborted by user!';
        Exit;
      end;
      if (VData = nil) or (VSize <= 0) then begin
        FErrorMessage := 'GetLineCallBack() failed!';
        Exit;
      end;
      if TIFFWriteScanline(ATiff, VData, I, 0) < 0 then begin
        FErrorMessage := 'TIFFWriteScanline() failed!';
        Exit;
      end;
    end;
  end else begin
    // tstTiled
    W := FParams.TileWidth;
    H := FParams.TileHeight;
    VTileNum := 0;

    for Y := 0 to Ceil(FHeight / H) - 1 do begin
      for X := 0 to Ceil(FWidth / W) - 1 do begin
        if not FParams.GetTileCallBack(X, Y, AOverView, VData, VSize) then begin
          FErrorMessage := 'Aborted by user!';
          Exit;
        end;
        if (VData = nil) or (VSize <= 0) then begin
          FErrorMessage := 'GetTileCallBack() failed!';
          Exit;
        end;
        if FWriteRawData then begin
          if TIFFWriteRawTile(ATiff, VTileNum, VData, VSize) < 0 then begin
            FErrorMessage := 'TIFFWriteRawTile() failed!';
            Exit;
          end;
        end else
        if TIFFWriteTile(ATiff, VData, X * W, Y * H, 0, 0) < 0 then begin
          FErrorMessage := 'TIFFWriteTile() failed!';
          Exit;
        end;
        Inc(VTileNum);
      end;
    end;
  end;

  if TIFFWriteDirectory(ATiff) <> 1 then begin
    FErrorMessage := 'TIFFWriteDirectory() failed!';
    Exit;
  end;

  Result := True;
end;

end.
