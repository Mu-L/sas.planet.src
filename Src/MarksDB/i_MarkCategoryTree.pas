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

unit i_MarkCategoryTree;

interface

uses
  i_MarkCategory;

type
  IMarkCategoryTree = interface
    ['{CC49C2B3-34DA-40F8-A443-33E6F0EED1E2}']
    function GetMarkCategory: IMarkCategory;
    property MarkCategory: IMarkCategory read GetMarkCategory;

    function GetName: string;
    property Name: string read GetName;

    function GetSubItemCount: Integer;
    property SubItemCount: Integer read GetSubItemCount;

    function GetSubItem(AIndex: Integer): IMarkCategoryTree;
    property SubItem[AIndex: Integer]: IMarkCategoryTree read GetSubItem;
  end;

implementation

end.
