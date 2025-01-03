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

unit i_UsedMarksConfig;

interface

uses
  i_ConfigDataElement;

type
  IUsedMarksConfigStatic = interface
    ['{77A54AD4-2B5B-48CE-BD5F-1F4B89763FF2}']
    function GetIsUseMarks: Boolean;
    property IsUseMarks: Boolean read GetIsUseMarks;
    function GetIgnoreCategoriesVisible: Boolean;
    property IgnoreCategoriesVisible: Boolean read GetIgnoreCategoriesVisible;
    function GetIgnoreMarksVisible: Boolean;
    property IgnoreMarksVisible: Boolean read GetIgnoreMarksVisible;
  end;

  IUsedMarksConfig = interface(IConfigDataElement)
    ['{5E07CEB8-C461-4994-A2CD-3A38269060F9}']
    function GetIsUseMarks: Boolean;
    procedure SetIsUseMarks(AValue: Boolean);
    property IsUseMarks: Boolean read GetIsUseMarks write SetIsUseMarks;

    function GetIgnoreCategoriesVisible: Boolean;
    procedure SetIgnoreCategoriesVisible(AValue: Boolean);
    property IgnoreCategoriesVisible: Boolean read GetIgnoreCategoriesVisible write SetIgnoreCategoriesVisible;

    function GetIgnoreMarksVisible: Boolean;
    procedure SetIgnoreMarksVisible(AValue: Boolean);
    property IgnoreMarksVisible: Boolean read GetIgnoreMarksVisible write SetIgnoreMarksVisible;

    function GetStatic: IUsedMarksConfigStatic;
  end;

implementation

end.
