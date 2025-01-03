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

unit u_BitmapTileProviderByBitmapTileUniProvider;

interface

uses
  Types,
  i_NotifierOperation,
  i_Bitmap32Static,
  i_Projection,
  i_BitmapTileProvider,
  i_BitmapLayerProvider,
  u_BaseInterfacedObject;

type
  TBitmapTileProviderByBitmapTileUniProvider = class(TBaseInterfacedObject, IBitmapTileProvider)
  private
    FProjection: IProjection;
    FSource: IBitmapTileUniProvider;
  private
    function GetProjection: IProjection;
    function GetTile(
      AOperationID: Integer;
      const ACancelNotifier: INotifierOperation;
      const ATile: TPoint
    ): IBitmap32Static;
  public
    constructor Create(
      const AProjection: IProjection;
      const ASource: IBitmapTileUniProvider
    );
  end;

implementation

{ TBitmapTileProviderByBitmapUniTileProvider }

constructor TBitmapTileProviderByBitmapTileUniProvider.Create(
  const AProjection: IProjection;
  const ASource: IBitmapTileUniProvider
);
begin
  Assert(Assigned(AProjection));
  Assert(Assigned(ASource));
  inherited Create;
  FProjection := AProjection;
  FSource := ASource;
end;

function TBitmapTileProviderByBitmapTileUniProvider.GetProjection: IProjection;
begin
  Result := FProjection;
end;

function TBitmapTileProviderByBitmapTileUniProvider.GetTile(
  AOperationID: Integer;
  const ACancelNotifier: INotifierOperation;
  const ATile: TPoint
): IBitmap32Static;
begin
  Result := FSource.GetTile(AOperationID, ACancelNotifier, FProjection, ATile);
end;

end.
