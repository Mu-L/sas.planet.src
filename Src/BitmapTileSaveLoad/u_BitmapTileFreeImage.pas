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

unit u_BitmapTileFreeImage;

interface

uses
  FreeImage,
  i_BinaryData,
  i_Bitmap32Static,
  i_Bitmap32BufferFactory,
  i_Bitmap32To8Converter,
  i_BitmapTileSaveLoad,
  i_InternalPerformanceCounter,
  u_BaseInterfacedObject;

type
  TBitmapTileFreeImageLoader = class(TBaseInterfacedObject, IBitmapTileLoader)
  private
    FCounter: IInternalPerformanceCounter;
    FBitmap32StaticFactory: IBitmap32StaticFactory;
  private
    function Load(const AData: IBinaryData): IBitmap32Static;
  public
    constructor Create(
      const APerfCounterList: IInternalPerformanceCounterList;
      const ABitmap32StaticFactory: IBitmap32StaticFactory
    );
  end;

  TBitmapTileFreeImageLoaderBmp = class(TBitmapTileFreeImageLoader)
  public
    constructor Create(
      const APerfCounterList: IInternalPerformanceCounterList;
      const ABitmap32StaticFactory: IBitmap32StaticFactory
    );
  end;

  TBitmapTileFreeImageLoaderIco = class(TBitmapTileFreeImageLoader)
  public
    constructor Create(
      const APerfCounterList: IInternalPerformanceCounterList;
      const ABitmap32StaticFactory: IBitmap32StaticFactory
    );
  end;

  TBitmapTileFreeImageLoaderGif = class(TBitmapTileFreeImageLoader)
  public
    constructor Create(
      const APerfCounterList: IInternalPerformanceCounterList;
      const ABitmap32StaticFactory: IBitmap32StaticFactory
    );
  end;

  TBitmapTileFreeImageLoaderPng = class(TBitmapTileFreeImageLoader)
  public
    constructor Create(
      const APerfCounterList: IInternalPerformanceCounterList;
      const ABitmap32StaticFactory: IBitmap32StaticFactory
    );
  end;

  TBitmapTileFreeImageLoaderWebp = class(TBitmapTileFreeImageLoader)
  public
    constructor Create(
      const APerfCounterList: IInternalPerformanceCounterList;
      const ABitmap32StaticFactory: IBitmap32StaticFactory
    );
  end;

  TBitmapTileFreeImageSaver = class(TBaseInterfacedObject, IBitmapTileSaver)
  private
    FFormat: FREE_IMAGE_FORMAT;
    FBitPerPixel: Byte;
    FFlag: Integer;
    FBitmap32To8Converter: IBitmap32To8Converter;
    FCounter: IInternalPerformanceCounter;
  private
    function Save(const ABitmap: IBitmap32Static): IBinaryData;
  public
    constructor Create(
      const AFormat: FREE_IMAGE_FORMAT;
      const ACompress: Integer;
      const ABitPerPixel: Byte;
      const ABitmap32To8Converter: IBitmap32To8Converter;
      const APerfCounterList: IInternalPerformanceCounterList
    );
  end;

  TBitmapTileFreeImageSaverBmp = class(TBitmapTileFreeImageSaver)
  public
    constructor Create(
      const APerfCounterList: IInternalPerformanceCounterList
    );
  end;

  TBitmapTileFreeImageSaverGif = class(TBitmapTileFreeImageSaver)
  public
    constructor Create(
      const ABitmap32To8Converter: IBitmap32To8Converter;
      const APerfCounterList: IInternalPerformanceCounterList
    );
  end;

  TBitmapTileFreeImageSaverPng = class(TBitmapTileFreeImageSaver)
  public
    constructor Create(
      const ACompress: Byte;
      const ABitPerPixel: Integer;
      const ABitmap32To8Converter: IBitmap32To8Converter;
      const APerfCounterList: IInternalPerformanceCounterList
    );
  end;

  TBitmapTileFreeImageSaverWebp = class(TBitmapTileFreeImageSaver)
  public
    constructor Create(
      const AQuality: Byte;
      const APerfCounterList: IInternalPerformanceCounterList
    );
  end;

  TBitmapTileFreeImageSaverWebpLossless = class(TBitmapTileFreeImageSaver)
  public
    constructor Create(
      const APerfCounterList: IInternalPerformanceCounterList
    );
  end;

implementation

uses
  Windows,
  Types,
  Classes,
  SysUtils,
  FreeBitmap,
  t_Bitmap32,
  i_Bitmap8Static,
  u_BinaryDataByMemStream,
  u_GlobalDllName;

type
  EBitmapTileFreeImageLoader = class(Exception);
  EBitmapTileFreeImageSaver = class(Exception);

const
  CWebpLosslessQuality = -1;

{ TBitmapTileFreeImageLoader }

constructor TBitmapTileFreeImageLoader.Create(
  const APerfCounterList: IInternalPerformanceCounterList;
  const ABitmap32StaticFactory: IBitmap32StaticFactory
);
begin
  Assert(Assigned(ABitmap32StaticFactory));
  inherited Create;
  FCounter := APerfCounterList.CreateAndAddNewCounter('Load');
  FBitmap32StaticFactory := ABitmap32StaticFactory;

  InitFreeImageLib(GDllName.FreeImage);
end;

function TBitmapTileFreeImageLoader.Load(
  const AData: IBinaryData
): IBitmap32Static;
var
  I: Integer;
  VScanLineSize: Integer;
  VFreeBitmap: TFreeWinBitmap;
  VFreeMemoryIO: TFreeMemoryIO;
  VCounterContext: TInternalPerformanceCounterContext;
  VSize: TPoint;
  VData: PColor32Array;
  VBuffer: IBitmap32Buffer;
begin
  Result := nil;
  VCounterContext := FCounter.StartOperation;
  try
    VFreeMemoryIO := TFreeMemoryIO.Create(AData.Buffer, AData.Size);
    try
      VFreeBitmap := TFreeWinBitmap.Create(FIT_BITMAP);
      try
        if VFreeBitmap.LoadFromMemory(VFreeMemoryIO) then begin
          if VFreeBitmap.ConvertTo32Bits then begin
            VBuffer :=
              FBitmap32StaticFactory.BufferFactory.BuildEmpty(
                Point(VFreeBitmap.GetWidth, VFreeBitmap.GetHeight)
              );
            if VBuffer <> nil then begin
              VSize := VBuffer.Size;
              VData := VBuffer.Data;
              VScanLineSize := VFreeBitmap.GetScanWidth;

              Assert(VScanLineSize = VSize.X * 4);
              for I := 0 to VSize.Y - 1 do begin
                Move(
                  VFreeBitmap.GetScanLine(VSize.Y - 1 - I)^,
                  VData[I * VSize.X],
                  VScanLineSize
                );
              end;
              Result := FBitmap32StaticFactory.BuildWithOwnBuffer(VBuffer);
            end;
          end else begin
            raise EBitmapTileFreeImageLoader.Create(
              'FreeBitmap.ConvertTo32Bits FAIL!'
            );
          end;
        end else begin
          raise EBitmapTileFreeImageLoader.Create(
            'FreeBitmap.LoadFromMemory FAIL!'
          );
        end;
      finally
        VFreeBitmap.Free;
      end;
    finally
      VFreeMemoryIO.Free;
    end;
  finally
    FCounter.FinishOperation(VCounterContext);
  end;
end;

{ TBitmapTileFreeImageLoaderBmp }

constructor TBitmapTileFreeImageLoaderBmp.Create(
  const APerfCounterList: IInternalPerformanceCounterList;
  const ABitmap32StaticFactory: IBitmap32StaticFactory
);
begin
  inherited Create(
    APerfCounterList.CreateAndAddNewSubList('FreeImage/Bmp'),
    ABitmap32StaticFactory
  );
end;

{ TBitmapTileFreeImageLoaderIco }

constructor TBitmapTileFreeImageLoaderIco.Create(
  const APerfCounterList: IInternalPerformanceCounterList;
  const ABitmap32StaticFactory: IBitmap32StaticFactory
);
begin
  inherited Create(
    APerfCounterList.CreateAndAddNewSubList('FreeImage/Ico'),
    ABitmap32StaticFactory
  );
end;

{ TBitmapTileFreeImageLoaderGif }

constructor TBitmapTileFreeImageLoaderGif.Create(
  const APerfCounterList: IInternalPerformanceCounterList;
  const ABitmap32StaticFactory: IBitmap32StaticFactory
);
begin
  inherited Create(
    APerfCounterList.CreateAndAddNewSubList('FreeImage/Gif'),
    ABitmap32StaticFactory
  );
end;

{ TBitmapTileFreeImageLoaderPng }

constructor TBitmapTileFreeImageLoaderPng.Create(
  const APerfCounterList: IInternalPerformanceCounterList;
  const ABitmap32StaticFactory: IBitmap32StaticFactory
);
begin
  inherited Create(
    APerfCounterList.CreateAndAddNewSubList('FreeImage/Png'),
    ABitmap32StaticFactory
  );
end;

{ TBitmapTileFreeImageLoaderWebp }

constructor TBitmapTileFreeImageLoaderWebp.Create(
  const APerfCounterList: IInternalPerformanceCounterList;
  const ABitmap32StaticFactory: IBitmap32StaticFactory
);
begin
  inherited Create(
    APerfCounterList.CreateAndAddNewSubList('FreeImage/Webp'),
    ABitmap32StaticFactory
  );
end;

{ TBitmapTileFreeImageSaver }

constructor TBitmapTileFreeImageSaver.Create(
  const AFormat: FREE_IMAGE_FORMAT;
  const ACompress: Integer;
  const ABitPerPixel: Byte;
  const ABitmap32To8Converter: IBitmap32To8Converter;
  const APerfCounterList: IInternalPerformanceCounterList
);
begin
  inherited Create;
  FFormat := AFormat;
  FBitPerPixel := ABitPerPixel;
  FBitmap32To8Converter := ABitmap32To8Converter;
  FCounter := APerfCounterList.CreateAndAddNewCounter('Save');
  case FFormat of
    FIF_PNG: begin
      case ACompress of
        0: FFlag := PNG_Z_NO_COMPRESSION;
        1..9: FFlag := ACompress;
      else
        Assert(False, 'Invalid PNG compression level: ' + IntToStr(ACompress));
      end;
    end;
    FIF_WEBP: begin
      case ACompress of
        1..100: FFlag := ACompress;
        CWebpLosslessQuality: FFlag := WEBP_LOSSLESS;
      else
        Assert(False, 'Invalid WebP quality value: ' + IntToStr(ACompress));
      end;
    end
  else // FIF_BMP, FIF_GIF
    FFlag := 0;
  end;

  InitFreeImageLib(GDllName.FreeImage);
end;

function TBitmapTileFreeImageSaver.Save(
  const ABitmap: IBitmap32Static
): IBinaryData;
var
  I: Integer;
  VScanLineSize: Integer;
  VMemStream: TMemoryStream;
  VFreeBitmap: TFreeWinBitmap;
  VCounterContext: TInternalPerformanceCounterContext;
  VPalette: PRGBQUAD;
  VSize: TPoint;
  VData: PByte;
  VBitmap8: IBitmap8Static;
  VBkColor: RGBQUAD;
  VTransparencyTable: array [0..255] of Byte;
begin
  VCounterContext := FCounter.StartOperation;
  try
    VSize := ABitmap.Size;

    // PNG with palette, GIF
    if FBitPerPixel = 8 then begin
      Assert(FBitmap32To8Converter <> nil);
      VBitmap8 := FBitmap32To8Converter.Convert(ABitmap);
      if Assigned(VBitmap8) then begin
        VFreeBitmap := TFreeWinBitmap.Create(FIT_BITMAP, VSize.X, VSize.Y, 8);
        try
          Assert(VFreeBitmap.GetScanWidth >= VSize.X);
          VScanLineSize := VSize.X;
          VData := VBitmap8.Data;
          for I := 0 to VSize.Y - 1 do begin
            Move(
              VData^,
              VFreeBitmap.GetScanLine(VSize.Y - 1 - I)^,
              VScanLineSize
            );
            Inc(VData, VScanLineSize);
          end;

          VPalette := VFreeBitmap.GetPalette;
          Assert(VFreeBitmap.GetPaletteSize div SizeOf(RGBQUAD) = 256);

          if not VFreeBitmap.GetFileBkColor(VBkColor) then begin
            VBkColor.rgbBlue := 0;
            VBkColor.rgbGreen := 0;
            VBkColor.rgbRed := 0;
            VBkColor.rgbReserved := 0;
          end;

          for I := 0 to VBitmap8.PaletteSize - 1 do begin
            Move(VBitmap8.Palette[I], VPalette^, 4);

            if (VPalette.rgbBlue = VBkColor.rgbBlue) and
              (VPalette.rgbGreen = VBkColor.rgbGreen) and
              (VPalette.rgbRed = VBkColor.rgbRed) then begin
              VTransparencyTable[I] := VBkColor.rgbReserved;
            end else begin
              VTransparencyTable[I] := VPalette.rgbReserved;
            end;

            Inc(VPalette);
          end;

          VFreeBitmap.SetTransparencyTable(@VTransparencyTable[0],
            VBitmap8.PaletteSize
          );

          VMemStream := TMemoryStream.Create;
          try
            if not VFreeBitmap.SaveToStream(FFormat, VMemStream, FFlag) then begin
              raise EBitmapTileFreeImageSaver.Create(
                'FreeBitmap.SaveToStream FAIL!'
              );
            end;
            Result := TBinaryDataByMemStream.CreateWithOwn(VMemStream);
            VMemStream := nil;
          finally
            VMemStream.Free;
          end;
        finally
          VFreeBitmap.Free;
        end;
      end;
    end else begin
      VFreeBitmap := TFreeWinBitmap.Create(FIT_BITMAP, VSize.X, VSize.Y, 32);
      try
        VScanLineSize := VFreeBitmap.GetScanWidth;
        Assert(VScanLineSize = VSize.X * 4);
        for I := 0 to VSize.Y - 1 do begin
          Move(
            ABitmap.Data[I * VSize.X],
            VFreeBitmap.GetScanLine(VSize.Y - 1 - I)^,
            VScanLineSize
          );
        end;
        if FBitPerPixel = 24 then begin // PNG without alfa
          if not VFreeBitmap.ConvertTo24Bits then begin
            raise EBitmapTileFreeImageSaver.Create(
              'FreeBitmap.ConvertTo24Bits FAIL!'
            );
          end;
        end;

        VMemStream := TMemoryStream.Create;
        try
          if not VFreeBitmap.SaveToStream(FFormat, VMemStream, FFlag) then begin
            raise EBitmapTileFreeImageSaver.Create(
              'FreeBitmap.SaveToStream FAIL!'
            );
          end;
          Result := TBinaryDataByMemStream.CreateWithOwn(VMemStream);
          VMemStream := nil;
        finally
          VMemStream.Free;
        end;
      finally
        VFreeBitmap.Free;
      end;
    end;
  finally
    FCounter.FinishOperation(VCounterContext);
  end;
end;

{ TBitmapTileFreeImageSaverBmp }

constructor TBitmapTileFreeImageSaverBmp.Create(
  const APerfCounterList: IInternalPerformanceCounterList
);
begin
  inherited Create(
    FIF_BMP,
    0,
    32,
    nil,
    APerfCounterList.CreateAndAddNewSubList('FreeImage/Bmp')
  );
end;

{ TBitmapTileFreeImageSaverGif }

constructor TBitmapTileFreeImageSaverGif.Create(
  const ABitmap32To8Converter: IBitmap32To8Converter;
  const APerfCounterList: IInternalPerformanceCounterList
);
begin
  inherited Create(
    FIF_GIF,
    0,
    8,
    ABitmap32To8Converter,
    APerfCounterList.CreateAndAddNewSubList('FreeImage/Gif')
  );
end;

{ TBitmapTileFreeImageSaverPng }

constructor TBitmapTileFreeImageSaverPng.Create(
  const ACompress: Byte;
  const ABitPerPixel: Integer;
  const ABitmap32To8Converter: IBitmap32To8Converter;
  const APerfCounterList: IInternalPerformanceCounterList
);
begin
  inherited Create(
    FIF_PNG,
    ACompress,
    ABitPerPixel,
    ABitmap32To8Converter,
    APerfCounterList.CreateAndAddNewSubList('FreeImage/Png' + IntToStr(ABitPerPixel) + 'bpp')
  );
end;

{ TBitmapTileFreeImageSaverWebp }

constructor TBitmapTileFreeImageSaverWebp.Create(
  const AQuality: Byte;
  const APerfCounterList: IInternalPerformanceCounterList
);
begin
  inherited Create(
    FIF_WEBP,
    AQuality,
    32,
    nil,
    APerfCounterList.CreateAndAddNewSubList('FreeImage/Webp')
  );
end;

{ TBitmapTileFreeImageSaverWebpLossless }

constructor TBitmapTileFreeImageSaverWebpLossless.Create(
  const APerfCounterList: IInternalPerformanceCounterList
);
begin
  inherited Create(
    FIF_WEBP,
    CWebpLosslessQuality,
    32,
    nil,
    APerfCounterList.CreateAndAddNewSubList('FreeImage/WebpLossless')
  );
end;

end.
