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

unit u_InternalBrowserImplByIE;

interface

uses
  Windows,
  Classes,
  Controls,
  EwbCore,
  EmbeddedWB,
  SHDocVw_EWB,
  i_ProxySettings,
  i_DownloadRequest,
  i_InternalDomainUrlHandler;

type
  TOnKeyDown = procedure(Sender: TObject; var Key: Word; ScanCode: Word; Shift: TShiftState) of object;
  TOnTitleChange = procedure(ASender: TObject; const Text: string) of object;

  TInternalBrowserImplByIE = class
  private
    FEmbeddedWB: TEmbeddedWB;
    FOnKeyDown: TOnKeyDown;
    FOnTitleChange: TOnTitleChange;
    FIsInvisible: Boolean;
    FProxyConfig: IProxyConfig;
    FInternalDomainUrlHandler: IInternalDomainUrlHandler;

    procedure OnAuthenticate(
      Sender: TCustomEmbeddedWB;
      var hwnd: HWND;
      var szUserName, szPassWord: WideString;
      var Rezult: HRESULT
    );
    procedure OnBeforeNavigate(
      ASender: TObject;
      const pDisp: IDispatch;
      var URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant;
      var Cancel: WordBool
    );
    procedure OnTitleChange(
      ASender: TObject;
      const Text: WideString
    );
    procedure OnKeyDown(
      Sender: TObject;
      var Key: Word;
      ScanCode: Word;
      Shift: TShiftState
    );
  public
    procedure AssignEmptyDocument;
    procedure Navigate(const AUrl: string); overload;
    procedure Navigate(const ARequest: IDownloadRequest); overload;
    function NavigateWait(const AUrl: string; const ATimeOut: Cardinal): Boolean;
    procedure SetHtmlText(const AText: string);
    procedure Stop;
  public
    constructor Create(
      const AParent: TWinControl;
      const AIsInvisible: Boolean;
      const AProxyConfig: IProxyConfig;
      const AInternalDomainUrlHandler: IInternalDomainUrlHandler;
      const AUserAgent: string = '';
      const AOnKeyDown: TOnKeyDown = nil;
      const AOnTitleChange: TOnTitleChange = nil
    );
    destructor Destroy; override;
  end;

implementation

uses
  Variants,
  SysUtils,
  gnugettext,
  u_Dialogs,
  u_HtmlDoc;

const
  CEmptyDocument = 'about:blank';

{ TInternalBrowserImplByIE }

constructor TInternalBrowserImplByIE.Create(
  const AParent: TWinControl;
  const AIsInvisible: Boolean;
  const AProxyConfig: IProxyConfig;
  const AInternalDomainUrlHandler: IInternalDomainUrlHandler;
  const AUserAgent: string;
  const AOnKeyDown: TOnKeyDown;
  const AOnTitleChange: TOnTitleChange
);
begin
  TP_GlobalIgnoreClassProperty(TEmbeddedWB, 'StatusText');
  TP_GlobalIgnoreClassProperty(TEmbeddedWB, 'UserAgent');
  TP_GlobalIgnoreClassProperty(TEmbeddedWB, 'About');

  inherited Create;

  FIsInvisible := AIsInvisible;
  FProxyConfig := AProxyConfig;
  FInternalDomainUrlHandler := AInternalDomainUrlHandler;
  FOnKeyDown := AOnKeyDown;
  FOnTitleChange := AOnTitleChange;

  FEmbeddedWB := TEmbeddedWB.Create(nil);

  FEmbeddedWB.Name := '';
  FEmbeddedWB.Parent := AParent;

  FEmbeddedWB.Left := 0;
  FEmbeddedWB.Top := 0;
  FEmbeddedWB.Align := alClient;

  if AIsInvisible then begin
    FEmbeddedWB.Silent := True;
    FEmbeddedWB.EnableMessageHandler := False;
    FEmbeddedWB.DisableErrors.EnableDDE := False;
    FEmbeddedWB.DisableErrors.fpExceptions := False;
    FEmbeddedWB.DisableErrors.ScriptErrorsSuppressed := False;
    FEmbeddedWB.DialogBoxes.ReplaceCaption := False;
    FEmbeddedWB.DialogBoxes.ReplaceIcon := False;
    FEmbeddedWB.DownloadOptions := [DownloadImages, DownloadVideos];
  end else begin
    FEmbeddedWB.Silent := False;
  end;

  if Assigned(FInternalDomainUrlHandler) then begin
    FEmbeddedWB.OnBeforeNavigate2 := Self.OnBeforeNavigate;
  end;
  if Assigned(FProxyConfig) then begin
    FEmbeddedWB.OnAuthenticate := Self.OnAuthenticate;
  end;
  if Assigned(FOnKeyDown) then begin
    FEmbeddedWB.OnKeyDown := Self.OnKeyDown;
  end;
  if Assigned(FOnTitleChange) then begin
    FEmbeddedWB.OnTitleChange := Self.OnTitleChange;
  end;

  FEmbeddedWB.DisableCtrlShortcuts := 'N';
  FEmbeddedWB.UserInterfaceOptions := [EnablesFormsAutoComplete, EnableThemes];

  FEmbeddedWB.About := '';

  FEmbeddedWB.PrintOptions.HTMLHeader.Clear;
  FEmbeddedWB.PrintOptions.HTMLHeader.Add('<HTML></HTML>');
  FEmbeddedWB.PrintOptions.Orientation := poPortrait;

  if AUserAgent <> '' then begin
    FEmbeddedWB.UserAgent := AUserAgent;
    FEmbeddedWB.UserAgentMode := uaInternal;
  end;
end;

destructor TInternalBrowserImplByIE.Destroy;
begin
  FreeAndNil(FEmbeddedWB);
  inherited;
end;

procedure TInternalBrowserImplByIE.OnAuthenticate(
  Sender: TCustomEmbeddedWB;
  var hwnd: HWND;
  var szUserName, szPassWord: WideString;
  var Rezult: HRESULT
);
var
  VUseLogin: Boolean;
  VProxyConfig: IProxyConfigStatic;
begin
  VProxyConfig := FProxyConfig.GetStatic;
  VUseLogin := (not VProxyConfig.UseIESettings) and VProxyConfig.UseProxy and VProxyConfig.UseLogin;
  if VUseLogin then begin
    szUserName := VProxyConfig.Login;
    szPassWord := VProxyConfig.Password;
  end;
end;

procedure TInternalBrowserImplByIE.OnBeforeNavigate(
  ASender: TObject;
  const pDisp: IDispatch;
  var URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
  var Cancel: WordBool
);
begin
  if Cancel then begin
    Exit;
  end;

  try
    if SameText(URL, CEmptyDocument) then begin
      Exit;
    end;

    if FInternalDomainUrlHandler.Process(URL) then begin
      Cancel := True;
      Exit;
    end;
  except
    on E: Exception do begin
      Cancel := True;
      if not FIsInvisible then begin
        ShowErrorMessage(E.Message);
      end;
    end;
  end;
end;

procedure TInternalBrowserImplByIE.OnKeyDown(Sender: TObject; var Key: Word;
  ScanCode: Word; Shift: TShiftState);
begin
  FOnKeyDown(Sender, Key, ScanCode, Shift);
end;

procedure TInternalBrowserImplByIE.OnTitleChange(ASender: TObject; const Text: WideString);
begin
  FOnTitleChange(ASender, string(Text));
end;

procedure TInternalBrowserImplByIE.Navigate(const AUrl: string);
begin
  FEmbeddedWB.Navigate(AUrl);
end;

procedure TInternalBrowserImplByIE.Navigate(const ARequest: IDownloadRequest);
var
  VPostData, VHeaders: OleVariant;
  VFlags: OleVariant;
  VTargetFrameName: OleVariant;
  VPostRequest: IDownloadPostRequest;
  VSafeArray: PVarArray;
begin
  VPostData := EmptyParam;
  if Supports(ARequest, IDownloadPostRequest, VPostRequest) then begin
    VPostData := VarArrayCreate([0, VPostRequest.PostData.Size - 1], varByte);
    VSafeArray := VarArrayAsPSafeArray(VPostData);
    Move(VPostRequest.PostData.Buffer^, VSafeArray.Data^, VPostRequest.PostData.Size);
  end;
  VHeaders := ARequest.RequestHeader;
  VFlags := EmptyParam;
  VTargetFrameName := EmptyParam;

  FEmbeddedWB.Navigate(ARequest.Url, VFlags, VTargetFrameName, VPostData, VHeaders);
end;

function TInternalBrowserImplByIE.NavigateWait(
  const AUrl: string;
  const ATimeOut: Cardinal
): Boolean;
begin
  Result := FEmbeddedWB.NavigateWait(AUrl, ATimeOut);
end;

procedure TInternalBrowserImplByIE.AssignEmptyDocument;
begin
  FEmbeddedWB.NavigateWait(CEmptyDocument);
end;

procedure TInternalBrowserImplByIE.SetHtmlText(const AText: string);
begin
  FEmbeddedWB.HTMLCode.Text := THtmlDoc.FormattedTextToHtml(AText);
end;

procedure TInternalBrowserImplByIE.Stop;
begin
  FEmbeddedWB.Stop;
end;

end.
