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

unit fr_ExportOruxMapsSQLite;

interface

uses
  Types,
  SysUtils,
  Classes,
  Controls,
  Forms,
  StdCtrls,
  ExtCtrls,
  Spin,
  i_LanguageManager,
  i_GeometryLonLat,
  i_RegionProcessParamsFrame,
  i_Bitmap32BufferFactory,
  i_BitmapLayerProvider,
  i_BitmapTileSaveLoad,
  i_BitmapTileSaveLoadFactory,
  i_MapType,
  i_BinaryData,
  i_MapTypeListChangeable,
  fr_MapSelect,
  fr_ZoomsSelect,
  fr_ImageFormatSelect,
  u_CommonFormAndFrameParents;

type
  IRegionProcessParamsFrameOruxMapsSQLiteExport = interface(IRegionProcessParamsFrameBase)
    ['{AF048EAA-5AE3-45CD-94FD-443DFCB580B6}']
    function GetDirectTilesCopy: Boolean;
    property DirectTilesCopy: Boolean read GetDirectTilesCopy;

    function GetBlankTile: IBinaryData;
    property BlankTile: IBinaryData read GetBlankTile;

    function GetBitmapTileSaver: IBitmapTileSaver;
    property BitmapTileSaver: IBitmapTileSaver read GetBitmapTileSaver;
  end;

type
  TfrExportOruxMapsSQLite = class(
      TFrame,
      IRegionProcessParamsFrameBase,
      IRegionProcessParamsFrameZoomArray,
      IRegionProcessParamsFrameTargetPath,
      IRegionProcessParamsFrameOneMap,
      IRegionProcessParamsFrameImageProvider,
      IRegionProcessParamsFrameOruxMapsSQLiteExport
    )
    pnlCenter: TPanel;
    pnlTop: TPanel;
    lblTargetPath: TLabel;
    edtTargetPath: TEdit;
    btnSelectTargetPath: TButton;
    pnlMain: TPanel;
    lblMap: TLabel;
    pnlMap: TPanel;
    pnlZoom: TPanel;
    lblOverlay: TLabel;
    pnlOverlay: TPanel;
    pnlImageFormat: TPanel;
    chkUsePrevZoom: TCheckBox;
    chkStoreBlankTiles: TCheckBox;
    chkAddVisibleLayers: TCheckBox;
    procedure btnSelectTargetPathClick(Sender: TObject);
    procedure chkAddVisibleLayersClick(Sender: TObject);
  private
    FLastPath: string;
    FBitmap32StaticFactory: IBitmap32StaticFactory;
    FBitmapTileSaveLoadFactory: IBitmapTileSaveLoadFactory;
    FActiveMapsList: IMapTypeListChangeable;
    FfrMapSelect: TfrMapSelect;
    FfrOverlaySelect: TfrMapSelect;
    FfrZoomsSelect: TfrZoomsSelect;
    FfrImageFormatSelect: TfrImageFormatSelect;
  private
    procedure Init(
      const AZoom: byte;
      const APolygon: IGeometryLonLatPolygon
    );
    function Validate: Boolean;
  private
    function GetMapType: IMapType;
    function GetZoomArray: TByteDynArray;
    function GetPath: string;
    function GetDirectTilesCopy: Boolean;
    function GetAllowExport(const AMapType: IMapType): Boolean;
    function GetProvider: IBitmapTileUniProvider;
    function GetBitmapTileSaver: IBitmapTileSaver;
    function GetBlankTile: IBinaryData;
  protected
    procedure OnShow(const AIsFirstTime: Boolean); override;
    procedure OnHide; override;
  public
    constructor Create(
      const ALanguageManager: ILanguageManager;
      const AMapSelectFrameBuilder: IMapSelectFrameBuilder;
      const AActiveMapsList: IMapTypeListChangeable;
      const ABitmap32StaticFactory: IBitmap32StaticFactory;
      const ABitmapTileSaveLoadFactory: IBitmapTileSaveLoadFactory
    ); reintroduce;
    destructor Destroy; override;
  end;

implementation

uses
  Graphics,
  {$WARN UNIT_PLATFORM OFF}
  FileCtrl,
  {$WARN UNIT_PLATFORM ON}
  gnugettext,
  c_CoordConverter,
  t_Bitmap32,
  i_Bitmap32Static,
  i_MapVersionRequest,
  i_ContentTypeInfo,
  i_MapTypeListStatic,
  u_Dialogs,
  u_BitmapLayerProviderMapWithLayer;

{$R *.dfm}

constructor TfrExportOruxMapsSQLite.Create(
  const ALanguageManager: ILanguageManager;
  const AMapSelectFrameBuilder: IMapSelectFrameBuilder;
  const AActiveMapsList: IMapTypeListChangeable;
  const ABitmap32StaticFactory: IBitmap32StaticFactory;
  const ABitmapTileSaveLoadFactory: IBitmapTileSaveLoadFactory
);
begin
  Assert(Assigned(ABitmap32StaticFactory));
  inherited Create(ALanguageManager);

  FLastPath := '';

  FActiveMapsList := AActiveMapsList;
  FBitmap32StaticFactory := ABitmap32StaticFactory;
  FBitmapTileSaveLoadFactory := ABitmapTileSaveLoadFactory;

  FfrMapSelect :=
    AMapSelectFrameBuilder.Build(
      mfMaps,          // show maps
      True,            // add -NO- to combobox
      False,           // show disabled map
      GetAllowExport
    );

  FfrOverlaySelect :=
    AMapSelectFrameBuilder.Build(
      mfLayers,        // show layers
      True,            // add -NO- to combobox
      False,           // show disabled map
      GetAllowExport
    );

  FfrZoomsSelect :=
    TfrZoomsSelect.Create(
      ALanguageManager
    );
  FfrZoomsSelect.Init(0, 23);

  FfrImageFormatSelect :=
    TfrImageFormatSelect.Create(
      ALanguageManager,
      FBitmapTileSaveLoadFactory,
      [iftAuto, iftJpeg, iftPng8bpp, iftPng24bpp, iftPng32bpp]
    );

  FPropertyState := CreateComponentPropertyState(
    Self, [pnlTop, pnlZoom], [], True, False, True, True
  );
end;

destructor TfrExportOruxMapsSQLite.Destroy;
begin
  FreeAndNil(FfrMapSelect);
  FreeAndNil(FfrOverlaySelect);
  FreeAndNil(FfrZoomsSelect);
  FreeAndNil(FfrImageFormatSelect);
  inherited;
end;

procedure TfrExportOruxMapsSQLite.OnHide;
begin
  inherited;
  FfrImageFormatSelect.Hide;
end;

procedure TfrExportOruxMapsSQLite.OnShow(const AIsFirstTime: Boolean);
begin
  inherited;
  if not AIsFirstTime then begin
    FfrImageFormatSelect.Visible := True;
  end;
end;

procedure TfrExportOruxMapsSQLite.chkAddVisibleLayersClick(Sender: TObject);
begin
  FfrOverlaySelect.SetEnabled(not chkAddVisibleLayers.Checked);
end;

procedure TfrExportOruxMapsSQLite.btnSelectTargetPathClick(Sender: TObject);
begin
  if SelectDirectory('', '', FLastPath, [sdNewFolder, sdNewUI, sdShowEdit, sdShowShares]) then begin
    FLastPath := IncludeTrailingPathDelimiter(FLastPath);
    edtTargetPath.Text := FLastPath;
  end;
end;

function TfrExportOruxMapsSQLite.GetAllowExport(const AMapType: IMapType): Boolean;
begin
  Result := AMapType.IsBitmapTiles;
end;

function TfrExportOruxMapsSQLite.GetBlankTile: IBinaryData;
const
  cOruxMapsBackground = TColor32($FFCBD3F3);
var
  VBuffer: IBitmap32Buffer;
  VBitmapStatic: IBitmap32Static;
  VBitmapSaver: IBitmapTileSaver;
begin
  Result := nil;
  if chkStoreBlankTiles.Checked then begin
    VBuffer :=
      FBitmap32StaticFactory.BufferFactory.BuildEmptyClear(
        Point(256, 256),
        cOruxMapsBackground
      );
    VBitmapStatic := FBitmap32StaticFactory.BuildWithOwnBuffer(VBuffer);
    VBitmapSaver := Self.GetBitmapTileSaver;
    Result := VBitmapSaver.Save(VBitmapStatic);
  end;
end;

function TfrExportOruxMapsSQLite.GetMapType: IMapType;
var
  VMapType: IMapType;
begin
  VMapType := FfrMapSelect.GetSelectedMapType;
  if not Assigned(VMapType) then begin
    VMapType := FfrOverlaySelect.GetSelectedMapType;
  end;
  Result := VMapType;
end;

function TfrExportOruxMapsSQLite.GetPath: string;
begin
  Result := IncludeTrailingPathDelimiter(edtTargetPath.Text);
end;

function TfrExportOruxMapsSQLite.GetDirectTilesCopy: Boolean;

  function _IsValidMap(const AMapType: IMapType): Boolean;
  begin
    Result := False;
    if AMapType.IsBitmapTiles then begin
      case AMapType.ProjectionSet.Zooms[0].ProjectionType.ProjectionEPSG of
        CGoogleProjectionEPSG,
        CYandexProjectionEPSG,
        CGELonLatProjectionEPSG: Result := True;
      end;
    end;
  end;

var
  VMap: IMapType;
  VLayer: IMapType;
begin
  Result := False;
  if chkAddVisibleLayers.Checked or chkUsePrevZoom.Checked then begin
    Exit;
  end;
  VMap := FfrMapSelect.GetSelectedMapType;
  VLayer := FfrOverlaySelect.GetSelectedMapType;
  if Assigned(VMap) and not Assigned(VLayer) then begin
    Result := _IsValidMap(VMap);
  end else if not Assigned(VMap) and Assigned(VLayer) then begin
    Result := _IsValidMap(VLayer);
  end;
  Result := Result and (FfrImageFormatSelect.SelectedFormat = iftAuto);
end;

function TfrExportOruxMapsSQLite.GetZoomArray: TByteDynArray;
begin
  Result := FfrZoomsSelect.GetZoomList;
end;

function TfrExportOruxMapsSQLite.GetProvider: IBitmapTileUniProvider;
var
  VMap: IMapType;
  VMapVersion: IMapVersionRequest;
  VLayer: IMapType;
  VLayerVersion: IMapVersionRequest;
  VActiveMapsSet: IMapTypeListStatic;
begin
  VMap := FfrMapSelect.GetSelectedMapType;
  if Assigned(VMap) then begin
    VMapVersion := VMap.VersionRequest.GetStatic;
  end else begin
    VMapVersion := nil;
  end;

  VLayer := FfrOverlaySelect.GetSelectedMapType;
  if Assigned(VLayer) then begin
    VLayerVersion := VLayer.VersionRequest.GetStatic;
  end else begin
    VLayerVersion := nil;
  end;

  if chkAddVisibleLayers.Checked then begin
    VLayer := nil;
    VLayerVersion := nil;
    VActiveMapsSet := FActiveMapsList.List;
  end else begin
    VActiveMapsSet := nil;
  end;

  Result :=
    TBitmapLayerProviderMapWithLayer.Create(
      FBitmap32StaticFactory,
      VMap,
      VMapVersion,
      VLayer,
      VLayerVersion,
      VActiveMapsSet,
      chkUsePrevZoom.Checked,
      chkUsePrevZoom.Checked
    );
end;

function TfrExportOruxMapsSQLite.GetBitmapTileSaver: IBitmapTileSaver;
begin
  Result := FfrImageFormatSelect.GetBitmapTileSaver(Self.GetMapType, nil);

  if Result = nil then begin
    Assert(FfrImageFormatSelect.SelectedFormat = iftAuto);
    if FfrMapSelect.GetSelectedMapType <> nil then begin
      Result := FfrImageFormatSelect.GetBitmapTileSaver(iftJpeg);
    end else begin
      Result := FfrImageFormatSelect.GetBitmapTileSaver(iftPng32bpp);
    end;
  end;
end;

procedure TfrExportOruxMapsSQLite.Init;
begin
  FfrMapSelect.Show(pnlMap);
  FfrOverlaySelect.Show(pnlOverlay);
  FfrZoomsSelect.Show(pnlZoom);
  FfrImageFormatSelect.Show(pnlImageFormat);
end;

function TfrExportOruxMapsSQLite.Validate: Boolean;
begin
  Result := False;

  if Trim(edtTargetPath.Text) = '' then begin
    ShowErrorMessage(_('Please select output folder'));
    Exit;
  end;

  if not FfrZoomsSelect.Validate then begin
    ShowErrorMessage(_('Please select at least one zoom'));
    Exit;
  end;

  if
    (FfrMapSelect.GetSelectedMapType = nil) and
    (FfrOverlaySelect.GetSelectedMapType = nil) then
  begin
    ShowErrorMessage(_('Please select at least one map or overlay layer'));
    Exit;
  end;

  Result := True;
end;

end.
