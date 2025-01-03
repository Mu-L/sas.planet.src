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

unit u_ContentConverterBitmap;

interface

uses
  i_BinaryData,
  i_ContentTypeInfo,
  i_BitmapTileSaveLoad,
  u_ContentConverterBase;

type
  TContentConverterBitmap = class(TContentConverterBase)
  private
    FSourceLoader: IBitmapTileLoader;
    FTargetSaver: IBitmapTileSaver;
  protected
    function Convert(const AData: IBinaryData): IBinaryData; override;
  public
    constructor Create(
      const ASource: IContentTypeInfoBasic;
      const ATarget: IContentTypeInfoBasic
    );
  end;

implementation

uses
  SysUtils,
  u_ResStrings;

{ TContentConverterBitmap }

constructor TContentConverterBitmap.Create(
  const ASource, ATarget: IContentTypeInfoBasic
);
var
  VSource: IContentTypeInfoBitmap;
  VTarget: IContentTypeInfoBitmap;
begin
  inherited;
  VSource := GetSource as IContentTypeInfoBitmap;
  FSourceLoader := VSource.GetLoader;
  if FSourceLoader = nil then begin
    raise Exception.Create(SAS_ERR_CantLoadBitmapFromSourceType);
  end;

  VTarget := GetTarget as IContentTypeInfoBitmap;
  FTargetSaver := VTarget.GetSaver;
  if FTargetSaver = nil then begin
    raise Exception.Create(SAS_ERR_CantSaveBitmapToTargetType);
  end;
end;

function TContentConverterBitmap.Convert(const AData: IBinaryData): IBinaryData;
begin
  Result := FTargetSaver.Save(FSourceLoader.Load(AData));
end;

end.
