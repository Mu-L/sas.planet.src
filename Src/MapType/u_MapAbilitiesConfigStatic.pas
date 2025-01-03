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

unit u_MapAbilitiesConfigStatic;

interface

uses
  i_MapAbilitiesConfig,
  u_BaseInterfacedObject;

type
  TMapAbilitiesConfigStatic = class(TBaseInterfacedObject, IMapAbilitiesConfigStatic)
  private
    FIsShowOnSmMap: Boolean;
    FUseDownload: Boolean;
  private
    function GetIsShowOnSmMap: Boolean;
    function GetUseDownload: Boolean;
  public
    constructor Create(
      AIsShowOnSmMap: Boolean;
      AUseDownload: Boolean
    );
  end;

implementation

{ TMapAbilitiesConfigStatic }

constructor TMapAbilitiesConfigStatic.Create(
  AIsShowOnSmMap,
  AUseDownload: boolean
);
begin
  inherited Create;
  FIsShowOnSmMap := AIsShowOnSmMap;
  FUseDownload := AUseDownload;
end;

function TMapAbilitiesConfigStatic.GetIsShowOnSmMap: Boolean;
begin
  Result := FIsShowOnSmMap;
end;

function TMapAbilitiesConfigStatic.GetUseDownload: Boolean;
begin
  Result := FUseDownload;
end;

end.
