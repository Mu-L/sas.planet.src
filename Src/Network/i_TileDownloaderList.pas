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

unit i_TileDownloaderList;

interface

uses
  i_Notifier,
  i_TileDownloader;

type
  ITileDownloaderListStatic = interface
    ['{09A9BF9E-8714-484F-9247-F9820138A8D7}']
    function GetCount: Integer;
    property Count: Integer read GetCount;

    function GetItem(AIndex: Integer): ITileDownloader;
    property Item[AIndex: Integer]: ITileDownloader read GetItem;
  end;

  ITileDownloaderList = interface
    ['{6271C038-A418-4FD8-B958-D1BA9B57A51F}']
    function GetStatic: ITileDownloaderListStatic;

    function GetChangeNotifier: INotifier;
    property ChangeNotifier: INotifier read GetChangeNotifier;
  end;

implementation

end.
