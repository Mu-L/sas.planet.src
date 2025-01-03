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

unit i_MarkCategoryDBSmlInternal;

interface

uses
  i_Category,
  i_MarkCategory,
  i_NotifierOperation;

type
  IMarkCategoryDBSmlInternal = interface
    ['{44BC212B-F9A2-4304-9E04-D44D16817445}']
    procedure Initialize(
      AOperationID: Integer;
      const ACancelNotifier: INotifierOperation
    );

    function IsCategoryFromThisDb(const ACategory: ICategory): Boolean;
    function GetCategoryByID(id: integer): IMarkCategory;
    function GetFirstCategoryByName(const AName: string): IMarkCategory;
    function GetCategoryByNameCount(const AName: string): Integer;
  end;

implementation

end.
