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

unit u_DatumFactory;

interface

uses
  i_Datum,
  i_DatumFactory,
  i_HashFunction,
  u_BaseInterfacedObject;

type
  TDatumFactory = class(TBaseInterfacedObject, IDatumFactory)
  private
    FHashFunction: IHashFunction;
    FDatumGoogle: IDatum;
    FDatumWGS84: IDatum;
    FDatum53004: IDatum;
  private
    function GetByCode(ADatumEPSG: Integer): IDatum;
    function GetByRadius(const ARadiusA, ARadiusB: Double): IDatum;
  public
    constructor Create(
      const AHashFunction: IHashFunction
    );
  end;

implementation

uses
  t_Hash,
  c_CoordConverter,
  u_Datum;

{ TDatumFactory }

constructor TDatumFactory.Create(
  const AHashFunction: IHashFunction
);
var
  VRadiusA: Double;
  VRadiusB: Double;
  VHash: THashValue;
begin
  inherited Create;
  FHashFunction := AHashFunction;

  VRadiusA := 6378137.0;
  VRadiusB := VRadiusA;
  VHash := FHashFunction.CalcHashByDouble(VRadiusA);
  FHashFunction.UpdateHashByDouble(VHash, VRadiusB);
  FDatumGoogle := TDatum.Create(VHash, CGoogleDatumEPSG, VRadiusA, VRadiusA);

  VRadiusA := 6378137.0;
  VRadiusB := 6356752.3142;
  VHash := FHashFunction.CalcHashByDouble(VRadiusA);
  FHashFunction.UpdateHashByDouble(VHash, VRadiusB);
  FDatumWGS84 := TDatum.Create(VHash, CWGS84DatumEPSG, VRadiusA, VRadiusB);

  VRadiusA := 6371000;
  VRadiusB := VRadiusA;
  VHash := FHashFunction.CalcHashByDouble(VRadiusA);
  FHashFunction.UpdateHashByDouble(VHash, VRadiusB);
  FDatum53004 := TDatum.Create(VHash, 53004, VRadiusA, VRadiusA);
end;

function TDatumFactory.GetByCode(ADatumEPSG: Integer): IDatum;
begin
  Result := nil;
  case ADatumEPSG of
    CGoogleDatumEPSG: begin
      Result := FDatumGoogle;
    end;
    CWGS84DatumEPSG: begin
      Result := FDatumWGS84;
    end;
    53004: begin
      Result := FDatum53004;
    end;
  end;
end;

function TDatumFactory.GetByRadius(
  const ARadiusA, ARadiusB: Double
): IDatum;
var
  VEPSG: Integer;
  VHash: THashValue;
begin
  VEPSG := 0;
  if (Abs(ARadiusA - 6378137) < 1) and (Abs(ARadiusB - 6378137) < 1) then begin
    VEPSG := CGoogleDatumEPSG;
  end;
  if (Abs(ARadiusA - 6378137) < 1) and (Abs(ARadiusB - 6356752) < 1) then begin
    VEPSG := CWGS84DatumEPSG;
  end;
  if VEPSG > 0 then begin
    Result := GetByCode(VEPSG);
  end else begin
    VHash := FHashFunction.CalcHashByDouble(ARadiusA);
    FHashFunction.UpdateHashByDouble(VHash, ARadiusB);
    Result := TDatum.Create(VHash, 0, ARadiusA, ARadiusB);
  end;
end;

end.
