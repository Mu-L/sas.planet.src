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

unit i_PathConfig;

interface

uses
  i_ConfigDataElement;

type
  IPathConfig = interface(IConfigDataElement)
    ['{0C315B68-7227-4AA0-981C-7CD14C4DA362}']
    function GetDefaultPath: string;
    property DefaultPath: string read GetDefaultPath;

    function GetBasePathConfig: IPathConfig;
    procedure SetBasePathConfig(const AValue: IPathConfig);
    property BasePathConfig: IPathConfig read GetBasePathConfig write SetBasePathConfig;

    function GetPath: string;
    procedure SetPath(const AValue: string);
    property Path: string read GetPath write SetPath;

    function GetIsRelative: Boolean;
    property IsRelative: Boolean read GetIsRelative;

    function GetFullPath: string;
    property FullPath: string read GetFullPath;
  end;

implementation

end.
