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

unit u_TreeByMapActiveMapsSet;

interface

uses
  i_StaticTreeItem,
  i_MapTypeSet,
  i_TreeChangeable,
  u_ChangeableBase;

type
  TTreeByMapActiveMapsSet = class(TChangeableWithSimpleLockBase, ITreeChangeable)
  private
    FMapsSet: IMapTypeSet;
    FStaticTree: IStaticTreeItem;
  protected
    function CreateStatic: IStaticTreeItem;
  protected
    function GetStatic: IStaticTreeItem;
  public
    constructor Create(const AMapsSet: IMapTypeSet);
  end;

implementation

{ TTreeByMapActiveMapsSet }

constructor TTreeByMapActiveMapsSet.Create(const AMapsSet: IMapTypeSet);
begin
  inherited Create;
  FMapsSet := AMapsSet;
  FStaticTree := CreateStatic;
end;

function TTreeByMapActiveMapsSet.CreateStatic: IStaticTreeItem;
begin
  Result := nil;
end;

function TTreeByMapActiveMapsSet.GetStatic: IStaticTreeItem;
begin
  Result := FStaticTree;
end;

end.
