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

unit u_TextDrawerBasic;

interface

uses
  SysUtils,
  GR32,
  t_Hash,
  i_HashFunction,
  i_InternalPerformanceCounter,
  i_Bitmap32Static,
  i_Bitmap32BufferFactory,
  i_HashInterfaceCache,
  i_TextDrawerBasic,
  u_BaseInterfacedObject;

type
  TTextDrawerBasic = class(TBaseInterfacedObject, ITextDrawerBasic)
  private
    FBitmap32StaticFactory: IBitmap32StaticFactory;
    FHashFunction: IHashFunction;
    FMaxSize: Integer;
    FAntiAliased: Boolean;

    FSync: IReadWriteSync;
    FCache: IHashInterfaceCache;

    FBitmapWithText: TBitmap32;

    function GetCaptionBitmap(
      const AText: string;
      const AFontSize: Integer;
      const ATextColor: TColor32;
      const ATextBgColor: TColor32;
      const ASolidBgDraw: Boolean
    ): IBitmap32Static;

    function CreateByKey(
      const AKey: THashValue;
      const AData: Pointer
    ): IInterface;
  private
    function DrawText(
      const AText: string;
      const AFontSize: Integer;
      const ATextColor: TColor32;
      const ATextBgColor: TColor32;
      const ASolidBgDraw: Boolean
    ): IBitmap32Static;
  public
    constructor Create(
      const APerfCounterList: IInternalPerformanceCounterList;
      const AHashFunction: IHashFunction;
      const ABitmap32StaticFactory: IBitmap32StaticFactory;
      const AMaxSize: Integer;
      const AAntiAliased: Boolean;
      const AFontName: string
    );
    destructor Destroy; override;
  end;


implementation

uses
  Types,
  GR32_Resamplers,
  u_HashInterfaceCache2Q,
  u_Bitmap32ByStaticBitmap,
  u_Synchronizer;

type
  PDataRecord = ^TDataRecord;

  TDataRecord = record
    Text: string;
    FontSize: Integer;
    TextColor: TColor32;
    TextBgColor: TColor32;
    SolidBgDraw: Boolean;
  end;

{ TTextDrawerBasic }

constructor TTextDrawerBasic.Create(
  const APerfCounterList: IInternalPerformanceCounterList;
  const AHashFunction: IHashFunction;
  const ABitmap32StaticFactory: IBitmap32StaticFactory;
  const AMaxSize: Integer;
  const AAntiAliased: Boolean;
  const AFontName: string
);
begin
  Assert(Assigned(AHashFunction));
  Assert(Assigned(ABitmap32StaticFactory));
  Assert(AMaxSize > 0);
  inherited Create;
  FHashFunction := AHashFunction;
  FBitmap32StaticFactory := ABitmap32StaticFactory;
  FMaxSize := AMaxSize;
  FAntiAliased := AAntiAliased;

  FCache :=
    THashInterfaceCache2Q.Create(
      GSync.SyncVariable.Make(Self.ClassName + 'Cache'),
      APerfCounterList.CreateAndAddNewSubList('Cache'),
      Self.CreateByKey,
      14,  // 2^14 elements in hash-table
      1000,
      4000,
      1000
    );
  FSync := GSync.SyncVariable.Make(Self.ClassName);

  FBitmapWithText := TBitmap32.Create;
  FBitmapWithText.Font.Name := AFontName;
  FBitmapWithText.Font.Style := [];
  FBitmapWithText.DrawMode := dmBlend;
  FBitmapWithText.CombineMode := cmMerge;
  FBitmapWithText.Resampler := TLinearResampler.Create;
end;

destructor TTextDrawerBasic.Destroy;
begin
  FreeAndNil(FBitmapWithText);
  inherited;
end;

function TTextDrawerBasic.CreateByKey(
  const AKey: THashValue;
  const AData: Pointer
): IInterface;
var
  VData: PDataRecord;
begin
  VData := PDataRecord(AData);
  FSync.BeginWrite;
  try
    Result := GetCaptionBitmap(VData.Text, VData.FontSize, VData.TextColor, VData.TextBgColor, VData.SolidBgDraw);
  finally
    FSync.EndWrite;
  end;
end;

function TTextDrawerBasic.GetCaptionBitmap(
  const AText: string;
  const AFontSize: Integer;
  const ATextColor, ATextBgColor: TColor32;
  const ASolidBgDraw: Boolean
): IBitmap32Static;
var
  VTextSize: TSize;
  VBitmap: TBitmap32ByStaticBitmap;
begin
  Result := nil;
  if (AFontSize > 0) and (AText <> '') then begin
    FBitmapWithText.MasterAlpha := AlphaComponent(ATextColor);
    FBitmapWithText.Font.Size := AFontSize;
    VTextSize := FBitmapWithText.TextExtent(AText);
    VTextSize.cx := VTextSize.cx + 2;
    VTextSize.cy := VTextSize.cy + 2;
    if VTextSize.cx > FMaxSize then begin
      VTextSize.cx := FMaxSize;
    end;
    if VTextSize.cy > FMaxSize then begin
      VTextSize.cy := FMaxSize;
    end;
    FBitmapWithText.SetSize(VTextSize.cx + 2, VTextSize.cy + 2);
    if ASolidBgDraw then begin
      FBitmapWithText.Clear(ATextBgColor);
      FBitmapWithText.RenderText(2, 2, AText, SetAlpha(ATextColor, 255), FAntiAliased);
    end else begin
      FBitmapWithText.Clear(0);
      FBitmapWithText.RenderText(2, 2, AText, SetAlpha(ATextBgColor, 255), FAntiAliased);
      FBitmapWithText.RenderText(1, 1, AText, SetAlpha(ATextColor, 255), FAntiAliased);
    end;
    VBitmap := TBitmap32ByStaticBitmap.Create(FBitmap32StaticFactory);
    try
      VBitmap.SetSizeFrom(FBitmapWithText);
      VBitmap.Clear(0);
      VBitmap.Draw(0, 0, FBitmapWithText);
      Result := VBitmap.MakeAndClear;
    finally
      VBitmap.Free;
    end;
  end;
end;

function TTextDrawerBasic.DrawText(
  const AText: string;
  const AFontSize: Integer;
  const ATextColor, ATextBgColor: TColor32;
  const ASolidBgDraw: Boolean
): IBitmap32Static;
var
  VData: TDataRecord;
  VHash: THashValue;
begin
  Result := nil;
  if (AText <> '') and (AFontSize > 0) then begin
    if ASolidBgDraw then begin
      VHash := $5cb476450dc0c297;
    end else begin
      VHash := $dc5ef652521ef6a2;
    end;
    FHashFunction.UpdateHashByString(VHash, AText);
    FHashFunction.UpdateHashByInteger(VHash, AFontSize);
    FHashFunction.UpdateHashByInteger(VHash, ATextColor);
    FHashFunction.UpdateHashByInteger(VHash, ATextBgColor);

    VData.Text := AText;
    VData.FontSize := AFontSize;
    VData.TextColor := ATextColor;
    VData.TextBgColor := ATextBgColor;
    VData.SolidBgDraw := ASolidBgDraw;

    Result := IBitmap32Static(FCache.GetOrCreateItem(VHash, @VData));
  end;
end;

end.
