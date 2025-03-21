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

unit u_StringConfigDataElementWithDefByGetText;

interface

uses
  gnugettext,
  i_LanguageManager,
  u_StringConfigDataElementWithDefBase;

type
  TStringConfigDataElementWithDefByGetText = class(TStringConfigDataElementWithDefBase)
  private
    FGetTextMsgId: MsgIdString;
  protected
    function GetDefValueForCurrentLang: string; override;
  public
    constructor Create(
      const ALanguageManager: ILanguageManager;
      AUseSotre: Boolean;
      const AStoreIdentifier: string;
      AIsStoreDefault: Boolean;
      const AGetTextMsgId: MsgIdString
    ); overload;
    constructor Create(
      const ALanguageManager: ILanguageManager;
      const AGetTextMsgId: MsgIdString
    ); overload;
  end;


implementation

{ TStringConfigDataElementWithDefByGetText }

constructor TStringConfigDataElementWithDefByGetText.Create(
  const ALanguageManager: ILanguageManager;
  AUseSotre: Boolean;
  const AStoreIdentifier: string;
  AIsStoreDefault: Boolean;
  const AGetTextMsgId: MsgIdString
);
begin
  inherited Create(ALanguageManager, AUseSotre, AStoreIdentifier, AIsStoreDefault);
  FGetTextMsgId := AGetTextMsgId;
end;

constructor TStringConfigDataElementWithDefByGetText.Create(
  const ALanguageManager: ILanguageManager;
  const AGetTextMsgId: MsgIdString
);
begin
  inherited Create(ALanguageManager, False, '', False);
  FGetTextMsgId := AGetTextMsgId;
end;

function TStringConfigDataElementWithDefByGetText.GetDefValueForCurrentLang: string;
begin
  Result := gettext_NoExtract(FGetTextMsgId);
end;

end.
