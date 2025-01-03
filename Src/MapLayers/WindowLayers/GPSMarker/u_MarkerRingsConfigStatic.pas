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

unit u_MarkerRingsConfigStatic;

interface

uses
  i_MarkerRingsConfig,
  u_BaseInterfacedObject;

type
  TMarkerRingsConfigStatic = class(TBaseInterfacedObject, IMarkerRingsConfigStatic)
  private
    FCount: Integer;
    FStepDistance: Double;
  private
    function GetCount: Integer;
    function GetStepDistance: Double;
  public
    constructor Create(
      ACount: Integer;
      const AStepDistance: Double
    );
  end;

implementation

{ TMarkerRingsConfigStatic }

constructor TMarkerRingsConfigStatic.Create(
  ACount: Integer;
  const AStepDistance: Double
);
begin
  inherited Create;
  FCount := ACount;
  FStepDistance := AStepDistance;
end;

function TMarkerRingsConfigStatic.GetCount: Integer;
begin
  Result := FCount;
end;

function TMarkerRingsConfigStatic.GetStepDistance: Double;
begin
  Result := FStepDistance;
end;

end.
