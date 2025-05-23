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

unit u_JpegWithExifImportConfig;

interface

uses
  i_Category,
  i_ImportConfig,
  i_JpegWithExifImportConfig,
  u_ImportConfig;

type
  TJpegWithExifImportConfig = class(TImportConfig, IJpegWithExifImportConfig)
  private
    FUseThumbnailAsIcon: Boolean;
    FResolutionLimit: Integer;
  private
    { IJpegWithExifImportConfig }
    function GetUseThumbnailAsIcon: Boolean;
    function GetResolutionLimit: Integer;
  public
    constructor Create(
      const ARootCategory: ICategory;
      const ACategoryParams: IImportCategoryParams;
      const APointParams: IImportPointParams;
      const AUseThumbnailAsIcon: Boolean;
      const AResolutionLimit: Integer
    );
  end;

implementation

{ TJpegWithExifImporterConfig }

constructor TJpegWithExifImportConfig.Create(
  const ARootCategory: ICategory;
  const ACategoryParams: IImportCategoryParams;
  const APointParams: IImportPointParams;
  const AUseThumbnailAsIcon: Boolean;
  const AResolutionLimit: Integer
);
begin
  inherited Create(
    ARootCategory,
    ACategoryParams,
    APointParams,
    nil,
    nil
  );
  FUseThumbnailAsIcon := AUseThumbnailAsIcon;
  FResolutionLimit := AResolutionLimit;
end;

function TJpegWithExifImportConfig.GetUseThumbnailAsIcon: Boolean;
begin
  Result := FUseThumbnailAsIcon;
end;

function TJpegWithExifImportConfig.GetResolutionLimit: Integer;
begin
  Result := FResolutionLimit;
end;

end.
