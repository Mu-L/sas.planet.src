{******************************************************************************}
{* This file is part of SAS.Planet project.                                   *}
{*                                                                            *}
{* Copyright (C) 2007-2022, SAS.Planet development team.                      *}
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

unit u_MarkCategorySmlDbInternal;

interface

uses
  i_Category,
  i_MarkCategory,
  i_MarkDbSmlInternal,
  u_BaseInterfacedObject;

type
  TMarkCategorySmlDbInternal = class(TBaseInterfacedObject, ICategory, IMarkCategory, IMarkCategorySMLInternal)
  private
    FId: Integer;
    FDbId: NativeInt;
    FName: string;
    FVisible: Boolean;
    FAfterScale: Integer;
    FBeforeScale: Integer;
  private
    function GetId: Integer;
    function GetDbId: NativeInt;
  private
    function GetName: string;
    function IsSame(const ACategory: ICategory): Boolean;
    function IsEqual(const ACategory: ICategory): Boolean;
  private
    function GetVisible: boolean;
    function GetAfterScale: Integer;
    function GetBeforeScale: Integer;
  public
    constructor Create(
      AId: Integer;
      ADbId: NativeInt;
      const AName: string;
      AVisible: Boolean;
      AAfterScale: Integer;
      ABeforeScale: Integer
    );
  end;

implementation

uses
  SysUtils;

{ TMarkCategorySmlDbInternal }

constructor TMarkCategorySmlDbInternal.Create(
  AId: Integer;
  ADbId: NativeInt;
  const AName: string;
  AVisible: Boolean;
  AAfterScale, ABeforeScale: Integer
);
begin
  Assert(AId >= 0);
  Assert(ADbId <> 0);
  Assert(AName <> '');
  Assert(AAfterScale >= 0);
  Assert(ABeforeScale >= 0);
  inherited Create;
  FId := AId;
  FDbId := ADbId;
  FName := AName;
  FVisible := AVisible;
  FAfterScale := AAfterScale;
  FBeforeScale := ABeforeScale;
end;

function TMarkCategorySmlDbInternal.GetAfterScale: Integer;
begin
  Result := FAfterScale;
end;

function TMarkCategorySmlDbInternal.GetBeforeScale: Integer;
begin
  Result := FBeforeScale;
end;

function TMarkCategorySmlDbInternal.GetDbId: NativeInt;
begin
  Result := FDbId;
end;

function TMarkCategorySmlDbInternal.GetId: Integer;
begin
  Result := FId;
end;

function TMarkCategorySmlDbInternal.GetName: string;
begin
  Result := FName;
end;

function TMarkCategorySmlDbInternal.GetVisible: boolean;
begin
  Result := FVisible;
end;

function TMarkCategorySmlDbInternal.IsEqual(const ACategory: ICategory): Boolean;
var
  VCategory: IMarkCategory;
begin
  if ACategory = nil then begin
    Result := False;
    Exit;
  end;
  if ACategory = ICategory(Self) then begin
    Result := True;
    Exit;
  end;
  if ACategory.Name <> FName then begin
    Result := False;
    Exit;
  end;
  if Supports(ACategory, IMarkCategory, VCategory) then begin
    Result :=
      (VCategory.Visible = FVisible) and
      (VCategory.AfterScale = FAfterScale) and
      (VCategory.BeforeScale = FBeforeScale);
  end else begin
    Result := False;
  end;
end;

function TMarkCategorySmlDbInternal.IsSame(const ACategory: ICategory): Boolean;
var
  VCategoryInternal: IMarkCategorySMLInternal;
begin
  Result := False;
  if ACategory <> nil then begin
    if Supports(ACategory, IMarkCategorySMLInternal, VCategoryInternal) then begin
      Result := FId = VCategoryInternal.Id;
    end;
  end;
end;

end.
