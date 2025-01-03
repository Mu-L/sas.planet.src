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

unit u_ArchiveReadWriteConfig;

interface

uses
  i_ArchiveReadWriteConfig,
  u_BaseInterfacedObject;

type
  TArchiveWriteZipConfig = class(TBaseInterfacedObject, IArchiveWriteZipConfig)
  private
    FCompressionLevel: TZipCompressionLevel;
    FCompressionMethod: TZipCompressionMethod;
    FVolumeSize: Int64;
  private
    { IArchiveWriteZipConfig }
    function GetCompressionLevel: TZipCompressionLevel;
    function GetCompressionMethod: TZipCompressionMethod;
    function GetVolumeSize: Int64;
  public
    constructor Create(
      const ACompressionLevel: TZipCompressionLevel;
      const ACompressionMethod: TZipCompressionMethod;
      const AVolumeSize: Int64
    );
  end;

implementation

{ TArchiveWriteZipConfig }

constructor TArchiveWriteZipConfig.Create(
  const ACompressionLevel: TZipCompressionLevel;
  const ACompressionMethod: TZipCompressionMethod;
  const AVolumeSize: Int64
);
begin
  inherited Create;
  FCompressionLevel := ACompressionLevel;
  FCompressionMethod := ACompressionMethod;
  FVolumeSize := AVolumeSize;
end;

function TArchiveWriteZipConfig.GetCompressionLevel: TZipCompressionLevel;
begin
  Result := FCompressionLevel;
end;

function TArchiveWriteZipConfig.GetCompressionMethod: TZipCompressionMethod;
begin
  Result := FCompressionMethod;
end;

function TArchiveWriteZipConfig.GetVolumeSize: Int64;
begin
  Result := FVolumeSize;
end;

end.
