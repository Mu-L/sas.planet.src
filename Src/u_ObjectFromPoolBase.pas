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

unit u_ObjectFromPoolBase;

interface

uses
  u_ObjectPoolBase,
  u_ObjectFromPoolAbstract;

type
  TObjectFromPoolBase = class(TObjectFromPoolAbstract, IInterface)
  private
    FOnFreeObject: IFreeObjectProcedure;
  protected
    function CheckNeedDestroyObject: Boolean; override;
  public
    constructor Create(const AOnFreeObject: IFreeObjectProcedure);
  end;

implementation

{ TObjectFromPoolBase }

constructor TObjectFromPoolBase.Create(
  const AOnFreeObject: IFreeObjectProcedure);
begin
  Assert(AOnFreeObject <> nil);
  inherited Create;
  FOnFreeObject := AOnFreeObject;
end;

function TObjectFromPoolBase.CheckNeedDestroyObject: Boolean;
begin
  Result := FOnFreeObject.IsNeedDestroyObject(Self);
end;

end.
