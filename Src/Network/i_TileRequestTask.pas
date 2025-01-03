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

unit i_TileRequestTask;

interface

uses
  i_NotifierOperation,
  i_TileRequest,
  i_TileRequestResult;

type
  ITileRequestTask = interface
    ['{1B2C3DD6-4527-4366-B498-D1B825D05B23}']
    function GetTileRequest: ITileRequest;
    property TileRequest: ITileRequest read GetTileRequest;

    function GetSoftCancelNotifier: INotifierOneOperation;
    property SoftCancelNotifier: INotifierOneOperation read GetSoftCancelNotifier;

    function GetCancelNotifier: INotifierOperation;
    property CancelNotifier: INotifierOperation read GetCancelNotifier;

    function GetOperationID: Integer;
    property OperationID: Integer read GetOperationID;
  end;

  ITileRequestTaskInternal = interface(ITileRequestTask)
    ['{1F2A8AAD-A290-4019-8E81-7A33227EF877}']
    procedure SetFinished(const AResult: ITileRequestResult);
  end;

  ITileRequestTaskFinishNotifier = interface
    ['{FB5E77BB-C245-4FC2-B5CB-CA968632B67A}']
    procedure Notify(
      const ATask: ITileRequestTask;
      const AResult: ITileRequestResult
    );

    function GetEnabled: Boolean;
    procedure SetEnabled(const AValue: Boolean);
    property Enabled: Boolean read GetEnabled write SetEnabled;
  end;

implementation

end.
