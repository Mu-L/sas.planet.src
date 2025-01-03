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

unit u_TileDownloaderStateStatic;

interface

uses
  i_TileDownloaderState,
  u_BaseInterfacedObject;

type
  TTileDownloaderStateStatic = class(TBaseInterfacedObject, ITileDownloaderStateStatic)
  private
    FEnabled: Boolean;
    FReason: string;
  private
    function GetEnabled: Boolean;
    function GetDisableReason: string;
  public
    constructor Create(
      AEnabled: Boolean;
      const AReason: string
    );
  end;

implementation

uses
  gnugettext;

{ TTileDownloaderStateStatic }

constructor TTileDownloaderStateStatic.Create(
  AEnabled: Boolean;
  const AReason: string
);
begin
  inherited Create;
  FEnabled := AEnabled;
  FReason := AReason;
end;

function TTileDownloaderStateStatic.GetDisableReason: string;
begin
  Result := FReason;
end;

function TTileDownloaderStateStatic.GetEnabled: Boolean;
begin
  Result := FEnabled;
end;

end.
