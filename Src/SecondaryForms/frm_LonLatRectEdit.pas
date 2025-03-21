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

unit frm_LonLatRectEdit;

interface

uses
  SysUtils,
  Classes,
  Controls,
  Forms,
  StdCtrls,
  ExtCtrls,
  u_CommonFormAndFrameParents,
  t_GeoTypes,
  i_LanguageManager,
  i_ProjectionSetChangeable,
  i_CoordFromStringParser,
  i_CoordToStringConverter,
  i_CoordRepresentationConfig,
  i_LocalCoordConverterChangeable,
  fr_LonLat;

type
  TfrmLonLatRectEdit = class(TFormWitghLanguageManager)
    btnOk: TButton;
    btnCancel: TButton;
    grpTopLeft: TGroupBox;
    grpBottomRight: TGroupBox;
    pnlBottomButtons: TPanel;
    grdpnlMain: TGridPanel;
    procedure FormCloseQuery(
      Sender: TObject;
      var CanClose: Boolean
    );
    procedure FormShow(Sender: TObject);
  private
    FfrLonLatTopLeft: TfrLonLat;
    FfrLonLatBottomRight: TfrLonLat;
  public
    constructor Create(
      const ALanguageManager: ILanguageManager;
      const AProjectionSet: IProjectionSetChangeable;
      const AViewPortState: ILocalCoordConverterChangeable;
      const ACoordRepresentationConfig: ICoordRepresentationConfig;
      const ACoordFromStringParser: ICoordFromStringParser;
      const ACoordToStringConverter: ICoordToStringConverterChangeable
    ); reintroduce;
    destructor Destroy; override;
    function Execute(var ALonLatRect: TDoubleRect): Boolean;
  end;

implementation

uses
  u_Dialogs,
  u_ResStrings;

{$R *.dfm}

constructor TfrmLonLatRectEdit.Create(
  const ALanguageManager: ILanguageManager;
  const AProjectionSet: IProjectionSetChangeable;
  const AViewPortState: ILocalCoordConverterChangeable;
  const ACoordRepresentationConfig: ICoordRepresentationConfig;
  const ACoordFromStringParser: ICoordFromStringParser;
  const ACoordToStringConverter: ICoordToStringConverterChangeable
);
begin
  inherited Create(ALanguageManager);
  FfrLonLatTopLeft :=
    TfrLonLat.Create(
      ALanguageManager,
      AProjectionSet,
      AViewPortState,
      ACoordRepresentationConfig,
      ACoordFromStringParser,
      ACoordToStringConverter,
      tssTopLeft
    );
  FfrLonLatBottomRight :=
    TfrLonLat.Create(
      ALanguageManager,
      AProjectionSet,
      AViewPortState,
      ACoordRepresentationConfig,
      ACoordFromStringParser,
      ACoordToStringConverter,
      tssBottomRight
    );
end;

destructor TfrmLonLatRectEdit.Destroy;
begin
  FreeAndNil(FfrLonLatTopLeft);
  FreeAndNil(FfrLonLatBottomRight);
  inherited;
end;

function TfrmLonLatRectEdit.Execute(var ALonLatRect: TDoubleRect): Boolean;
begin
  FfrLonLatTopLeft.LonLat := ALonLatRect.TopLeft;
  FfrLonLatBottomRight.LonLat := ALonLatRect.BottomRight;
  Result := ShowModal = mrOK;
  if Result then begin
    ALonLatRect.TopLeft := FfrLonLatTopLeft.LonLat;
    ALonLatRect.BottomRight := FfrLonLatBottomRight.LonLat;
    if (ALonLatRect.Left > ALonLatRect.Right) then begin
      ShowErrorMessage(SAS_ERR_LonLat2);
      Result := False;
    end else if (ALonLatRect.Top < ALonLatRect.Bottom) then begin
      ShowErrorMessage(SAS_ERR_LonLat1);
      Result := False;
    end;
  end;
end;

procedure TfrmLonLatRectEdit.FormCloseQuery(
  Sender: TObject;
  var CanClose:
  Boolean
);
begin
  if ModalResult = mrOk then begin
    CanClose := FfrLonLatTopLeft.Validate;
    if CanClose then begin
      CanClose := FfrLonLatBottomRight.Validate;
    end;
  end;
end;

procedure TfrmLonLatRectEdit.FormShow(Sender: TObject);
begin
  FfrLonLatTopLeft.Parent := grpTopLeft;
  FfrLonLatBottomRight.Parent := grpBottomRight;
end;

end.
