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

unit frm_ShortCutEdit;

interface

uses
  Forms,
  Classes,
  Controls,
  ComCtrls,
  StdCtrls,
  Buttons,
  ExtCtrls,
  i_ShortCutSingleConfig,
  u_CommonFormAndFrameParents;

type
  TfrmShortCutEdit = class(TFormWitghLanguageManager)
    GroupBox1: TGroupBox;
    HotKey: THotKey;
    btnOk: TButton;
    btnCancel: TButton;
    btnClear: TSpeedButton;
    pnlBottom: TPanel;
    procedure FormShow(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
  private
  public
    function EditHotKeyModal(const AShortCutInfo: IShortCutSingleConfig): Boolean;
  end;

implementation

{$R *.dfm}

procedure TfrmShortCutEdit.btnClearClick(Sender: TObject);
begin
  HotKey.HotKey := 0;
end;

function TfrmShortCutEdit.EditHotKeyModal(
  const AShortCutInfo: IShortCutSingleConfig
): Boolean;
begin
  HotKey.HotKey := AShortCutInfo.ShortCut;
  if ShowModal = mrOK then begin
    AShortCutInfo.ShortCut := HotKey.HotKey;
    Result := True;
  end else begin
    Result := False;
  end;
end;

procedure TfrmShortCutEdit.FormShow(Sender: TObject);
begin
  HotKey.SetFocus;
end;

end.
