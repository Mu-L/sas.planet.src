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

unit i_TileDownloadRequestBuilder;

interface

uses
  i_NotifierOperation,
  i_TileRequest,
  i_LastResponseInfo,
  i_TileDownloadRequest;

type
  ITileDownloadRequestBuilder = interface
    ['{3F65B989-F693-460B-AE98-FD1DAECEA04B}']
    function BuildRequest(
      const ASource: ITileRequest;
      const ALastResponseInfo: ILastResponseInfo;
      const ACancelNotifier: INotifierOperation;
      AOperationID: Integer
    ): ITileDownloadRequest;
  end;


implementation

end.
