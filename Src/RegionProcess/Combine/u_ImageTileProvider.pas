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

unit u_ImageTileProvider;

interface

uses
  Types,
  t_Bitmap32,
  i_BinaryData,
  i_Bitmap32Static,
  i_BitmapTileProvider,
  i_Bitmap32BufferFactory,
  i_BitmapTileSaveLoad,
  i_BitmapTileSaveLoadFactory,
  i_ImageTileProvider,
  i_NotifierOperation,
  i_InternalPerformanceCounter,
  i_Projection,
  i_TileStorage,
  i_TileInfoBasic,
  i_MapVersionRequest,
  u_BaseInterfacedObject;

type
  TImageTileProviderAbstract = class(TBaseInterfacedObject, IImageTileProvider)
  private
    FBuffer: Pointer;
    FBufferSize: Integer;

    FGetTileCounter: IInternalPerformanceCounter;
    FImageProvider: IBitmapTileProvider;
    FBitmapFactory: IBitmap32StaticFactory;

    FTileSizeInPix: TPoint;
    FBytesPerPixel: Integer;

    function LoadAndPrepareTile(
      const AOperationID: Integer;
      const ACancelNotifier: INotifierOperation;
      const APoint: TPoint
    ): Pointer; inline;
  protected
    procedure PrepareTile(
      ASource: PColor32;
      ATarget: Pointer;
      ACount: Integer
    ); virtual; abstract;
  private
    { IImageTileProvider }
    function GetTileSize: TPoint;
    function GetBytesPerPixel: Integer;

    function GetTile(
      const AOperationID: Integer;
      const ACancelNotifier: INotifierOperation;
      const APoint: TPoint;
      out ASize: NativeInt
    ): Pointer; overload;

    function GetTile(
      const AOperationID: Integer;
      const ACancelNotifier: INotifierOperation;
      const APixelRect: TRect;
      out ASize: NativeInt
    ): Pointer; overload;
  public
    constructor Create(
      const AGetTileCounter: IInternalPerformanceCounter;
      const AImageProvider: IBitmapTileProvider;
      const ABitmapFactory: IBitmap32StaticFactory;
      const ABytesPerPixel: Integer
    );
    destructor Destroy; override;
  end;

  TImageTileProviderRGB = class(TImageTileProviderAbstract)
  protected
    procedure PrepareTile(
      ASource: PColor32;
      ATarget: Pointer;
      ACount: Integer
    ); override;
  public
    constructor Create(
      const AGetTileCounter: IInternalPerformanceCounter;
      const AImageProvider: IBitmapTileProvider;
      const ABitmapFactory: IBitmap32StaticFactory
    );
  end;

  TImageTileProviderRGBA = class(TImageTileProviderAbstract)
  protected
    procedure PrepareTile(
      ASource: PColor32;
      ATarget: Pointer;
      ACount: Integer
    ); override;
  public
    constructor Create(
      const AGetTileCounter: IInternalPerformanceCounter;
      const AImageProvider: IBitmapTileProvider;
      const ABitmapFactory: IBitmap32StaticFactory
    );
  end;

  TImageTileProviderRawJpeg = class(TBaseInterfacedObject, IImageTileProvider)
  private
    FZoom: Byte;
    FTileSizeInPix: TPoint;
    FGetTileCounter: IInternalPerformanceCounter;
    FImageProvider: IBitmapTileProvider;
    FTileStorage: ITileStorage;
    FMapVersionRequest: IMapVersionRequest;
    FEmptyTile: IBinaryData;
    FTileData: IBinaryData;
    FJpegSaver: IBitmapTileSaver;
  private
    { IImageTileProvider }
    function GetTileSize: TPoint;
    function GetBytesPerPixel: Integer;

    function GetTile(
      const AOperationID: Integer;
      const ACancelNotifier: INotifierOperation;
      const APoint: TPoint;
      out ASize: NativeInt
    ): Pointer; overload;

    function GetTile(
      const AOperationID: Integer;
      const ACancelNotifier: INotifierOperation;
      const APixelRect: TRect;
      out ASize: NativeInt
    ): Pointer; overload;
  public
    constructor Create(
      const AGetTileCounter: IInternalPerformanceCounter;
      const AImageProvider: IBitmapTileProvider;
      const ABitmapFactory: IBitmap32StaticFactory;
      const ABitmapTileSaveLoadFactory: IBitmapTileSaveLoadFactory;
      const ATileStorage: ITileStorage;
      const AMapVersionRequest: IMapVersionRequest;
      const ABgColor: TColor32;
      const AJpegQuality: Byte;
      const AZoom: Byte
    );
  end;

implementation

uses
  SysUtils,
  GR32,
  c_CoordConverter,
  i_ContentTypeInfo,
  u_BitmapFunc,
  u_ContentTypeFunc,
  u_TileIteratorByRect,
  u_Bitmap32ByStaticBitmap;

function GetProviderTileSize(const AImageProvider: IBitmapTileProvider): TPoint;
var
  VTileSplitCode: Integer;
begin
  VTileSplitCode := AImageProvider.Projection.GetTileSplitCode;
  if VTileSplitCode = CTileSplitQuadrate256x256 then begin
    Result := Types.Point(256, 256);
  end else begin
    raise Exception.CreateFmt('Unexpected TileSplitCode: %d', [VTileSplitCode]);
  end;
end;

{ TImageTileProviderAbstract }

constructor TImageTileProviderAbstract.Create(
  const AGetTileCounter: IInternalPerformanceCounter;
  const AImageProvider: IBitmapTileProvider;
  const ABitmapFactory: IBitmap32StaticFactory;
  const ABytesPerPixel: Integer
);
begin
  inherited Create;

  FGetTileCounter := AGetTileCounter;
  FImageProvider := AImageProvider;
  FBitmapFactory := ABitmapFactory;
  FBytesPerPixel := ABytesPerPixel;

  FTileSizeInPix := GetProviderTileSize(FImageProvider);

  FBufferSize := FTileSizeInPix.X * FTileSizeInPix.Y * FBytesPerPixel;
  GetMem(FBuffer, FBufferSize);
end;

destructor TImageTileProviderAbstract.Destroy;
begin
  FreeMem(FBuffer);
  inherited Destroy;
end;

function TImageTileProviderAbstract.GetTileSize: TPoint;
begin
  Result := FTileSizeInPix;
end;

function TImageTileProviderAbstract.GetBytesPerPixel: Integer;
begin
  Result := FBytesPerPixel;
end;

function TImageTileProviderAbstract.LoadAndPrepareTile(
  const AOperationID: Integer;
  const ACancelNotifier: INotifierOperation;
  const APoint: TPoint
): Pointer;
var
  VBitmap: IBitmap32Static;
begin
  VBitmap := FImageProvider.GetTile(AOperationID, ACancelNotifier, APoint);
  if VBitmap <> nil then begin
    PrepareTile(@VBitmap.Data[0], FBuffer, FBufferSize div FBytesPerPixel);
    Result := FBuffer;
  end else begin
    Result := nil;
  end;
end;

function TImageTileProviderAbstract.GetTile(
  const AOperationID: Integer;
  const ACancelNotifier: INotifierOperation;
  const APoint: TPoint;
  out ASize: NativeInt
): Pointer;
var
  VContext: TInternalPerformanceCounterContext;
begin
  ASize := FBufferSize;
  VContext := FGetTileCounter.StartOperation;
  try
    Result := LoadAndPrepareTile(AOperationID, ACancelNotifier, APoint);
  finally
    FGetTileCounter.FinishOperation(VContext);
  end;
end;

function TImageTileProviderAbstract.GetTile(
  const AOperationID: Integer;
  const ACancelNotifier: INotifierOperation;
  const APixelRect: TRect;
  out ASize: NativeInt
): Pointer;
var
  VProjection: IProjection;
  VPixelRectTarget: TRect;
  VTileRect: TRect;
  VTargetImageSize: TPoint;
  VPixelRectCurrTile: TRect;
  VIterator: TTileIteratorByRectRecord;
  VTile: TPoint;
  VTmp: IBitmap32Static;
  VSourceBounds: TRect;
  VTargetBounds: TRect;
  VBitmap: TBitmap32ByStaticBitmap;
  VContext: TInternalPerformanceCounterContext;
begin
  Result := nil;
  ASize := FBufferSize;

  VContext := FGetTileCounter.StartOperation;
  try
    VTargetImageSize.X := APixelRect.Right - APixelRect.Left;
    VTargetImageSize.Y := APixelRect.Bottom - APixelRect.Top;

    if (VTargetImageSize.X <> FTileSizeInPix.X) or (VTargetImageSize.Y <> FTileSizeInPix.Y) then begin
      Assert(False);
      Exit;
    end;

    VProjection := FImageProvider.Projection;

    VPixelRectTarget := APixelRect;
    VProjection.ValidatePixelRect(VPixelRectTarget);
    VTileRect := VProjection.PixelRect2TileRect(VPixelRectTarget);

    if (VTileRect.Left = VTileRect.Right - 1) and
       (VTileRect.Top = VTileRect.Bottom - 1) then
    begin
      VPixelRectCurrTile := VProjection.TilePos2PixelRect(VTileRect.TopLeft);
      if Types.EqualRect(VPixelRectCurrTile, APixelRect) then begin
        Result := LoadAndPrepareTile(AOperationID, ACancelNotifier, VTileRect.TopLeft);
        Exit;
      end;
    end;

    VBitmap := TBitmap32ByStaticBitmap.Create(FBitmapFactory);
    try
      VBitmap.SetSize(VTargetImageSize.X, VTargetImageSize.Y);
      VBitmap.Clear(0);

      VIterator.Init(VTileRect);
      while VIterator.Next(VTile) do begin
        VTmp := FImageProvider.GetTile(AOperationID, ACancelNotifier, VTile);
        if VTmp <> nil then begin
          VPixelRectCurrTile := VProjection.TilePos2PixelRect(VTile);

          if VPixelRectCurrTile.Top < APixelRect.Top then begin
            VSourceBounds.Top := APixelRect.Top - VPixelRectCurrTile.Top;
          end else begin
            VSourceBounds.Top := 0;
          end;

          if VPixelRectCurrTile.Left < APixelRect.Left then begin
            VSourceBounds.Left := APixelRect.Left - VPixelRectCurrTile.Left;
          end else begin
            VSourceBounds.Left := 0;
          end;

          if VPixelRectCurrTile.Bottom < APixelRect.Bottom then begin
            VSourceBounds.Bottom := VPixelRectCurrTile.Bottom - VPixelRectCurrTile.Top;
          end else begin
            VSourceBounds.Bottom := APixelRect.Bottom - VPixelRectCurrTile.Top;
          end;

          if VPixelRectCurrTile.Right < APixelRect.Right then begin
            VSourceBounds.Right := VPixelRectCurrTile.Right - VPixelRectCurrTile.Left;
          end else begin
            VSourceBounds.Right := APixelRect.Right - VPixelRectCurrTile.Left;
          end;

          if VPixelRectCurrTile.Top < APixelRect.Top then begin
            VTargetBounds.Top := 0;
          end else begin
            VTargetBounds.Top := VPixelRectCurrTile.Top - APixelRect.Top;
          end;

          if VPixelRectCurrTile.Left < APixelRect.Left then begin
            VTargetBounds.Left := 0;
          end else begin
            VTargetBounds.Left := VPixelRectCurrTile.Left - APixelRect.Left;
          end;

          if VPixelRectCurrTile.Bottom < APixelRect.Bottom then begin
            VTargetBounds.Bottom := VPixelRectCurrTile.Bottom - APixelRect.Top;
          end else begin
            VTargetBounds.Bottom := APixelRect.Bottom - APixelRect.Top;
          end;

          if VPixelRectCurrTile.Right < APixelRect.Right then begin
            VTargetBounds.Right := VPixelRectCurrTile.Right - APixelRect.Left;
          end else begin
            VTargetBounds.Right := APixelRect.Right - APixelRect.Left;
          end;

          BlockTransfer(
            VBitmap,
            VTargetBounds.Left,
            VTargetBounds.Top,
            VTmp,
            VSourceBounds,
            dmOpaque
          );
        end;
      end;

      VTmp := VBitmap.MakeAndClear;
      PrepareTile(@VTmp.Data[0], FBuffer, FBufferSize div FBytesPerPixel);
      Result := FBuffer;
    finally
      VBitmap.Free;
    end;
  finally
    FGetTileCounter.FinishOperation(VContext);
  end;
end;

{ TImageTileProviderRGB }

constructor TImageTileProviderRGB.Create(
  const AGetTileCounter: IInternalPerformanceCounter;
  const AImageProvider: IBitmapTileProvider;
  const ABitmapFactory: IBitmap32StaticFactory
);
begin
  inherited Create(AGetTileCounter, AImageProvider, ABitmapFactory, 3);
end;

procedure TImageTileProviderRGB.PrepareTile(ASource: PColor32; ATarget: Pointer; ACount: Integer);
type
  TRGB  = packed record R,G,B: Byte; end;
var
  I: Integer;
  VSource: PColor32Entry absolute ASource;
  VTarget: ^TRGB absolute ATarget;
begin
  for I := 0 to ACount - 1 do begin
    VTarget.B := VSource.B;
    VTarget.G := VSource.G;
    VTarget.R := VSource.R;
    Inc(VSource);
    Inc(VTarget);
  end;
end;

{ TImageTileProviderRGBA }

constructor TImageTileProviderRGBA.Create(
  const AGetTileCounter: IInternalPerformanceCounter;
  const AImageProvider: IBitmapTileProvider;
  const ABitmapFactory: IBitmap32StaticFactory
);
begin
  inherited Create(AGetTileCounter, AImageProvider, ABitmapFactory, 4);
end;

procedure TImageTileProviderRGBA.PrepareTile(ASource: PColor32; ATarget: Pointer; ACount: Integer);
type
  TRGBA = packed record R,G,B,A: Byte; end;
var
  I: Integer;
  VSource: PColor32Entry absolute ASource;
  VTarget: ^TRGBA absolute ATarget;
begin
  for I := 0 to ACount - 1 do begin
    VTarget.B := VSource.B;
    VTarget.G := VSource.G;
    VTarget.R := VSource.R;
    VTarget.A := VSource.A;
    Inc(VSource);
    Inc(VTarget);
  end;
end;

{ TImageTileProviderRawJpeg }

constructor TImageTileProviderRawJpeg.Create(
  const AGetTileCounter: IInternalPerformanceCounter;
  const AImageProvider: IBitmapTileProvider;
  const ABitmapFactory: IBitmap32StaticFactory;
  const ABitmapTileSaveLoadFactory: IBitmapTileSaveLoadFactory;
  const ATileStorage: ITileStorage;
  const AMapVersionRequest: IMapVersionRequest;
  const ABgColor: TColor32;
  const AJpegQuality: Byte;
  const AZoom: Byte
);
begin
  FGetTileCounter := AGetTileCounter;
  FImageProvider := AImageProvider;
  FTileStorage := ATileStorage;
  FMapVersionRequest := AMapVersionRequest;
  FZoom := AZoom;

  FJpegSaver := ABitmapTileSaveLoadFactory.CreateJpegSaver(AJpegQuality);
  FTileSizeInPix := GetProviderTileSize(FImageProvider);

  with TBitmap32ByStaticBitmap.Create(ABitmapFactory) do
  try
    SetSize(FTileSizeInPix.X, FTileSizeInPix.Y);
    Clear(ABgColor);
    FEmptyTile := FJpegSaver.Save(MakeAndClear);
  finally
    Free;
  end;
end;

function TImageTileProviderRawJpeg.GetBytesPerPixel: Integer;
begin
  Result := 3;
end;

function TImageTileProviderRawJpeg.GetTileSize: TPoint;
begin
  Result := FTileSizeInPix;
end;

function TImageTileProviderRawJpeg.GetTile(
  const AOperationID: Integer;
  const ACancelNotifier: INotifierOperation;
  const APoint: TPoint;
  out ASize: NativeInt
): Pointer;
var
  VTileInfo: ITileInfoBasic;
  VTileInfoWithData: ITileInfoWithData;
  VBitmap: IBitmap32Static;
  VContext: TInternalPerformanceCounterContext;
begin
  VContext := FGetTileCounter.StartOperation;
  try
    if ACancelNotifier.IsOperationCanceled(AOperationID) then begin
      Result := nil;
      Exit;
    end;

    VTileInfo := FTileStorage.GetTileInfoEx(APoint, FZoom, FMapVersionRequest, gtimWithData);

    if (VTileInfo = nil) or
       not VTileInfo.IsExists or
       not Supports(VTileInfo, ITileInfoWithData, VTileInfoWithData) then
    begin
      Result := FEmptyTile.Buffer;
      ASize := FEmptyTile.Size;
      Exit;
    end;

    if IsJpegContentType(VTileInfoWithData.ContentType) then begin
      FTileData := VTileInfoWithData.TileData;
    end else begin
      VBitmap := FImageProvider.GetTile(AOperationID, ACancelNotifier, APoint);
      FTileData := FJpegSaver.Save(VBitmap);
    end;

    Assert(FTileData <> nil);

    Result := FTileData.Buffer;
    ASize := FTileData.Size;
  finally
    FGetTileCounter.FinishOperation(VContext);
  end;
end;

function TImageTileProviderRawJpeg.GetTile(
  const AOperationID: Integer;
  const ACancelNotifier: INotifierOperation;
  const APixelRect: TRect;
  out ASize: NativeInt
): Pointer;
begin
  Assert(False);
  Result := nil;
end;

end.
