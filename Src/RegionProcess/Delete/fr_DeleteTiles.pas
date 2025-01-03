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

unit fr_DeleteTiles;

interface

uses
  SysUtils,
  Classes,
  Controls,
  Forms,
  ExtCtrls,
  StdCtrls,
  Spin,
  t_CommonTypes,
  i_LanguageManager,
  i_MapType,
  i_PredicateByTileInfo,
  i_GeometryLonLat,
  i_RegionProcessParamsFrame,
  fr_MapSelect,
  u_CommonFormAndFrameParents;

type
  TfrDeleteTiles = class(
      TFrame,
      IRegionProcessParamsFrameBase,
      IRegionProcessParamsFrameOneMap,
      IRegionProcessParamsFrameOneZoom,
      IRegionProcessParamsFrameProcessPredicate
    )
    seDelSize: TSpinEdit;
    chkDelBySize: TCheckBox;
    flwpnlDelBySize: TFlowPanel;
    lblDelSize: TLabel;
    rgTarget: TRadioGroup;
    pnlMapSelect: TPanel;
    pnlZoom: TPanel;
    Labelzoom: TLabel;
    cbbZoom: TComboBox;
    pnlFrame: TPanel;
    lblMapCaption: TLabel;
  private
    FfrMapSelect: TfrMapSelect;
  private
    procedure Init(
      const AZoom: byte;
      const APolygon: IGeometryLonLatPolygon
    );
    function Validate: Boolean;
  private
    function GetMapType: IMapType;
    function GetZoom: Byte;
    function CheckIsDeleteable(const AMapType: IMapType): boolean;
  private
    function GetPredicate: IPredicateByTileInfo;
  protected
    procedure OnShow(const AIsFirstTime: Boolean); override;
  public
    constructor Create(
      const ALanguageManager: ILanguageManager;
      const AMapSelectFrameBuilder: IMapSelectFrameBuilder
    ); reintroduce;
    destructor Destroy; override;
  end;

implementation

uses
  gnugettext,
  i_BinaryDataListStatic,
  i_PredicateByBinaryData,
  u_Dialogs,
  u_PredicateByStaticSampleList,
  u_PredicateByTileInfoBase;

{$R *.dfm}

{ TFrame3 }

constructor TfrDeleteTiles.Create(
  const ALanguageManager: ILanguageManager;
  const AMapSelectFrameBuilder: IMapSelectFrameBuilder
);
begin
  inherited Create(ALanguageManager);

  FfrMapSelect :=
    AMapSelectFrameBuilder.Build(
      mfAll, // show maps and layers
      False,  // add -NO- to combobox
      true,  // show disabled map
      CheckIsDeleteable
    );

  FPropertyState := CreateComponentPropertyState(
    Self, [pnlMapSelect], [], True, False, True, True
  );
end;

destructor TfrDeleteTiles.Destroy;
begin
  FreeAndNil(FfrMapSelect);
  inherited;
end;

function TfrDeleteTiles.GetMapType: IMapType;
begin
  Result := FfrMapSelect.GetSelectedMapType;
end;

function TfrDeleteTiles.GetPredicate: IPredicateByTileInfo;
var
  VMapType: IMapType;
  VEmptyTileSamples: IBinaryDataListStatic;
  VDataCheck: IPredicateByBinaryData;
begin
  Result := nil;
  if rgTarget.ItemIndex < 0 then begin
    rgTarget.ItemIndex := 0;
  end;
  case rgTarget.ItemIndex of
    0: begin
      if chkDelBySize.Checked and (seDelSize.Value >= 0) then begin
        Result := TPredicateByTileInfoEqualSize.Create(False, seDelSize.Value);
      end else begin
        Result := TPredicateByTileInfoExistsTile.Create;
      end;
    end;
    1: begin
      Result := TPredicateByTileInfoExistsTNE.Create;
    end;
    2: begin
      if chkDelBySize.Checked and (seDelSize.Value >= 0) then begin
        Result := TPredicateByTileInfoEqualSize.Create(True, seDelSize.Value);
      end else begin
        Result := TPredicateByTileInfoExistsTileOrTNE.Create;
      end;
    end;
    3: begin
      VMapType := GetMapType;
      VEmptyTileSamples := VMapType.Zmp.EmptyTileSamples;
      if Assigned(VEmptyTileSamples) and (VEmptyTileSamples.Count > 0) then begin
        VDataCheck := TPredicateByStaticSampleList.Create(VMapType.Zmp.EmptyTileSamples);
        Result := TPredicateByTileInfoExistsTileCheckData.Create(VDataCheck);
      end else begin
        Result := TPredicateByTileInfoEqualSize.Create(False, 0);
      end;
    end;
  end;
end;

function TfrDeleteTiles.GetZoom: Byte;
begin
  if cbbZoom.ItemIndex < 0 then begin
    cbbZoom.ItemIndex := 0;
  end;
  Result := cbbZoom.ItemIndex;
end;

function TfrDeleteTiles.CheckIsDeleteable(const AMapType: IMapType): boolean;
begin
  Result :=
    AMapType.StorageConfig.AllowDelete and
    AMapType.TileStorage.State.GetStatic.DeleteAccess;
end;

procedure TfrDeleteTiles.Init(
  const AZoom: byte;
  const APolygon: IGeometryLonLatPolygon
);
begin
  cbbZoom.ItemIndex := AZoom;
  FfrMapSelect.Show(pnlFrame);
end;

procedure TfrDeleteTiles.OnShow(const AIsFirstTime: Boolean);
var
  I: Integer;
begin
  inherited;

  if AIsFirstTime then begin
    with cbbZoom.Items do begin
      BeginUpdate;
      Clear;
      for I := 1 to 24 do begin
        Add(IntToStr(I));
      end;
      EndUpdate;
    end;
  end;
end;

function TfrDeleteTiles.Validate: Boolean;
var
  VMapType: IMapType;
  VEmptyTileSamples: IBinaryDataListStatic;
begin
  VMapType := GetMapType;
  if VMapType = nil then begin
    ShowErrorMessage(_('Please select a map'));
    Result := False;
  end else begin
    if rgTarget.ItemIndex = 3 then begin
      VEmptyTileSamples := VMapType.Zmp.EmptyTileSamples;
      Result := Assigned(VEmptyTileSamples) and (VEmptyTileSamples.Count > 0);
      if not Result then begin
        ShowErrorMessage(_('Empty tile samples do not exist for this map'));
      end;
    end else begin
      Result := True;
    end;
  end;
end;

end.
