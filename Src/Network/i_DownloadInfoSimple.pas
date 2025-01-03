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

unit i_DownloadInfoSimple;

interface

type
  IDownloadInfoSimple = interface
    ['{5B404464-7B4B-4966-8FFD-BBDE2A13D72B}']
    function GetTileCount: UInt64;
    property TileCount: UInt64 read GetTileCount;

    function GetSize: UInt64;
    property Size: UInt64 read GetSize;

    procedure Reset;
    procedure Add(
      ACount: UInt64;
      ASize: UInt64
    );
  end;

implementation

end.
