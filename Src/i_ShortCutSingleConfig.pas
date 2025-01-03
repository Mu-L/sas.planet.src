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

unit i_ShortCutSingleConfig;

interface

uses
  Classes,
  i_Bitmap32Static,
  i_ConfigDataElement;

type
  IShortCutSingleConfig = interface(IConfigDataElement)
    ['{B8B92915-98D2-4254-ACE7-92ACFC081513}']
    function GetCaption: String;
    property Caption: String read GetCaption;

    function GetIconBitmap: IBitmap32Static;
    property IconBitmap: IBitmap32Static read GetIconBitmap;

    function GetShortCut: TShortCut;
    procedure SetShortCut(AValue: TShortCut);
    property ShortCut: TShortCut read GetShortCut write SetShortCut;

    procedure ResetToDefault;

    procedure ResetShortCut;
    procedure ApplyShortCut;
  end;

implementation

end.
