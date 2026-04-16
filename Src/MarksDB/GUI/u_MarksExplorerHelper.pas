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

unit u_MarksExplorerHelper;

interface

uses
  Classes,
  TBX,
  TB2Item,
  CityHash,
  i_Category,
  i_MarkSystemConfig;

type
  TCategoryUniqueID = Cardinal;

  TCategoryInfo = record
    UID: TCategoryUniqueID;
    Index: Integer;
    Category: ICategory;
  end;
  PCategoryInfo = ^TCategoryInfo;

  TCategoryInfoArray = array of TCategoryInfo;

const
  CEmptyUniqueID: TCategoryUniqueID = 0;

function CategoryInfoToString(const AInfo: TCategoryInfo): string;
function CategoryInfoArrayToString(const AInfo: TCategoryInfoArray): string;

function CategoryInfoFromString(const AStr: string): TCategoryInfo;
function CategoryInfoArrayFromString(const AStr: string): TCategoryInfoArray;

function GetCategoryUniqueID(const ACategory: ICategory): TCategoryUniqueID; inline;

procedure RefreshConfigListMenu(
  const ASubmenuItem: TTBXSubmenuItem;
  const ARefreshCaption: Boolean;
  const AOnClick: TNotifyEvent;
  const AMarkSystemConfig: IMarkSystemConfigListChangeable
);

implementation

uses
  SysUtils,
  System.Generics.Collections,
  System.Generics.Defaults,
  c_MarkSystem,
  i_InterfaceListStatic;

const
  cSep1 = ',';
  cSep2 = ':';

function CategoryInfoToString(const AInfo: TCategoryInfo): string;
begin
  if AInfo.UID = CEmptyUniqueID then begin
    Result := '';
  end else begin
    Result := IntToHex(AInfo.UID, 8) + cSep2 + IntToStr(AInfo.Index);
  end;
end;

function CategoryInfoArrayToString(const AInfo: TCategoryInfoArray): string;
var
  I: Integer;
  VStrings: TStringList;
begin
  VStrings := TStringList.Create;
  try
    VStrings.Delimiter := cSep1;
    VStrings.NameValueSeparator := cSep2;
    for I := 0 to Length(AInfo) - 1 do begin
      VStrings.Values[IntToHex(AInfo[I].UID, 8)] := IntToStr(AInfo[I].Index);
    end;
    Result := VStrings.DelimitedText;
  finally
    VStrings.Free;
  end;
end;

function CategoryInfoFromString(const AStr: string): TCategoryInfo;
var
  VArr: TCategoryInfoArray;
begin
  VArr := CategoryInfoArrayFromString(AStr);
  if Length(VArr) >= 1 then begin
    Result.UID := VArr[0].UID;
    Result.Index := VArr[0].Index;
  end else begin
    Result.UID := CEmptyUniqueID;
    Result.Index := -1;
  end;
  Result.Category := nil;
end;

function CategoryInfoArrayFromString(const AStr: string): TCategoryInfoArray;
var
  I: Integer;
  VCount: Integer;
  VStrings: TStringList;
begin
  VCount := 0;
  if AStr <> '' then begin
    VStrings := TStringList.Create;
    try
      VStrings.Delimiter := cSep1;
      VStrings.NameValueSeparator := cSep2;
      VStrings.DelimitedText := AStr;
      SetLength(Result, VStrings.Count);
      for I := 0 to Length(Result) - 1 do begin
        if TryStrToUInt('$' + VStrings.Names[I], Result[VCount].UID) and
           TryStrToInt(VStrings.ValueFromIndex[I], Result[VCount].Index)
        then begin
          Result[VCount].Category := nil;
          Inc(VCount);
        end;
      end;
    finally
      VStrings.Free;
    end;
  end;

  SetLength(Result, VCount);

  if VCount > 1 then begin
    TArray.Sort<TCategoryInfo>(Result, TComparer<TCategoryInfo>.Construct(
      function(const Left, Right: TCategoryInfo): Integer
      begin
        Result := Left.Index - Right.Index;
      end));
  end;
end;

function GetCategoryUniqueID(const ACategory: ICategory): TCategoryUniqueID;
var
  VName: string;
begin
  Result := CEmptyUniqueID;
  if ACategory <> nil then begin
    VName := ACategory.Name;
    if VName <> '' then begin
      Result := CityHash32(@VName[1], Length(VName) * SizeOf(Char));
    end;
  end;
end;

procedure RefreshConfigListMenu(
  const ASubmenuItem: TTBXSubmenuItem;
  const ARefreshCaption: Boolean;
  const AOnClick: TNotifyEvent;
  const AMarkSystemConfig: IMarkSystemConfigListChangeable
);

  function _DatabaseToHint(const ADB: TGUID): string;
  begin
    if IsEqualGUID(ADB, cSMLMarksDbGUID) then begin
      Result := rsSMLMarksDbName;
    end else
    if IsEqualGUID(ADB, cORMSQLiteMarksDbGUID) then begin
      Result := rsORMSQLiteMarksDbName;
    end else
    if IsEqualGUID(ADB, cORMMongoDbMarksDbGUID) then begin
      Result := rsORMMongoDbMarksDbName;
    end else
    if IsEqualGUID(ADB, cORMODBCMarksDbGUID) then begin
      Result := rsORMODBCMarksDbName;
    end else
    if IsEqualGUID(ADB, cORMZDBCMarksDbGUID) then begin
      Result := rsORMZDBCMarksDbName;
    end else begin
      Result := '';
      Exit;
    end;
    Result := Format(' [%s]', [Result]);
  end;

var
  I: Integer;
  VList: IInterfaceListStatic;
  VActiveID: Integer;
  VMenuItem: TTBXItem;
  VConfigItem: IMarkSystemConfigStatic;
begin
  ASubmenuItem.Clear;

  if ARefreshCaption then begin
    ASubmenuItem.Caption := '';
  end;

  VList := AMarkSystemConfig.GetIDListStatic;
  if Assigned(VList) and (VList.Count > 0) then begin
    ASubmenuItem.Enabled := True;
    ASubmenuItem.Options := ASubmenuItem.Options + [tboDropdownArrow];
  end else begin
    ASubmenuItem.Enabled := False;
    ASubmenuItem.Options := ASubmenuItem.Options - [tboDropdownArrow];
    Exit;
  end;

  VActiveID := AMarkSystemConfig.ActiveConfigID;

  for I := 0 to VList.Count - 1 do begin
    VConfigItem := IMarkSystemConfigStatic(VList.Items[I]);
    VMenuItem := TTBXItem.Create(ASubmenuItem);
    VMenuItem.Tag := VConfigItem.ID;
    VMenuItem.Caption := VConfigItem.DisplayName + _DatabaseToHint(VConfigItem.DatabaseGUID);
    VMenuItem.Checked := (VConfigItem.ID = VActiveID);
    VMenuItem.RadioItem := True;
    VMenuItem.GroupIndex := 1;
    VMenuItem.OnClick := AOnClick;

    ASubmenuItem.Add(VMenuItem);

    if VMenuItem.Checked and ARefreshCaption then begin
      ASubmenuItem.Caption := VMenuItem.Caption;
    end;
  end;
end;

end.
