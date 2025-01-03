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

unit u_MapVersionFactoryChangeable;

interface

uses
  i_MapVersionFactory,
  u_ChangeableBase;

type
  TMapVersionFactoryChangeable = class(TChangeableWithSimpleLockBase, IMapVersionFactoryChangeable, IMapVersionFactoryChangeableInternal)
  private
    FFactory: IMapVersionFactory;
  private
    procedure SetFactory(const AValue: IMapVersionFactory);
    function GetStatic: IMapVersionFactory;
  public
    constructor Create(
      const ADefFactory: IMapVersionFactory
    );
  end;

implementation

{ TMapVersionFactoryChangeable }

constructor TMapVersionFactoryChangeable.Create(
  const ADefFactory: IMapVersionFactory);
begin
  inherited Create;
  FFactory := ADefFactory;
end;

function TMapVersionFactoryChangeable.GetStatic: IMapVersionFactory;
begin
  CS.BeginRead;
  try
    Result := FFactory;
  finally
    CS.EndRead;
  end;
end;

procedure TMapVersionFactoryChangeable.SetFactory(
  const AValue: IMapVersionFactory
);
var
  VNeedNotify: Boolean;
begin
  VNeedNotify := False;
  CS.BeginWrite;
  try
    if not FFactory.IsSameFactoryClass(AValue) then begin
      FFactory := AValue;
      VNeedNotify := True;
    end;
  finally
    CS.EndWrite;
  end;
  if VNeedNotify then begin
    DoChangeNotify;
  end;
end;

end.
