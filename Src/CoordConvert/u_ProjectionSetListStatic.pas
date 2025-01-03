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

unit u_ProjectionSetListStatic;

interface

uses
  SysUtils,
  Classes,
  i_ProjectionSet,
  i_ProjectionSetList,
  u_BaseInterfacedObject;

type
  TProjectionSetListStatic = class(TBaseInterfacedObject, IProjectionSetList)
  private
    FList: TStringList;
    FCS: IReadWriteSync;
  protected
    procedure Add(
      const AItem: IProjectionSet;
      const ACaption: string
    );
  private
    function Count: Integer;
    function Get(AIndex: Integer): IProjectionSet;
    function GetCaption(AIndex: Integer): string;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  u_Synchronizer;

{ TProjectionSetListStatic }

constructor TProjectionSetListStatic.Create;
begin
  inherited;
  FCS := GSync.SyncVariable.Make(Self.ClassName);
  FList := TStringList.Create;
end;

destructor TProjectionSetListStatic.Destroy;
var
  i: Integer;
begin
  if FList <> nil then begin
    for i := 0 to FList.Count - 1 do begin
      if FList.Objects[i] <> nil then begin
        IInterface(Pointer(FList.Objects[i]))._Release;
        FList.Objects[i] := nil;
      end;
    end;
  end;
  FreeAndNil(FList);
  FCS := nil;
  inherited;
end;

procedure TProjectionSetListStatic.Add(
  const AItem: IProjectionSet;
  const ACaption: string
);
begin
  FCS.BeginWrite;
  try
    FList.AddObject(ACaption, TObject(Pointer(AItem)));
    AItem._AddRef;
  finally
    FCS.EndWrite;
  end;
end;

function TProjectionSetListStatic.Count: Integer;
begin
  FCS.BeginRead;
  try
    Result := FList.Count;
  finally
    FCS.EndRead;
  end;
end;

function TProjectionSetListStatic.Get(
  AIndex: Integer
): IProjectionSet;
begin
  FCS.BeginRead;
  try
    Result := IProjectionSet(Pointer(FList.Objects[AIndex]));
  finally
    FCS.EndRead;
  end;
end;

function TProjectionSetListStatic.GetCaption(AIndex: Integer): string;
begin
  FCS.BeginRead;
  try
    Result := FList.Strings[AIndex];
  finally
    FCS.EndRead;
  end;
end;

end.
