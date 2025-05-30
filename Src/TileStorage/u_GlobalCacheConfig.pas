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

unit u_GlobalCacheConfig;

interface

uses
  i_PathConfig,
  i_GlobalCacheConfig,
  i_ConfigDataProvider,
  i_ConfigDataWriteProvider,
  u_ConfigDataElementComplexBase;

type
  TGlobalCacheConfig = class(TConfigDataElementComplexBase, IGlobalCacheConfig)
  private
    FCacheGlobalPath: IPathConfig;

    //������ ������� ���� ��-���������.
    FDefCache: Byte;

    //���� � ����� ������ �����
    FNewCPath: IPathConfig;
    FOldCPath: IPathConfig;
    FESCPath: IPathConfig;
    FGMTilesPath: IPathConfig;
    FMOBACPath: IPathConfig;
    FTMSPath: IPathConfig;
    FGECachePath: IPathConfig;
    FGCCachePath: IPathConfig;
    FBDBCachePath: IPathConfig;
    FBDBVerCachePath: IPathConfig;
    FDBMSCachePath: IPathConfig;
    FSQLiteCachePath: IPathConfig;
    FSQLiteMBTilesCachePath: IPathConfig;
    FSQLiteOsmAndCachePath: IPathConfig;
    FSQLiteLocusCachePath: IPathConfig;
    FSQLiteRMapsCachePath: IPathConfig;

    function GetDefCache: Byte;
    procedure SetDefCache(const AValue: Byte);

    function GetNewCPath: IPathConfig;
    function GetOldCPath: IPathConfig;
    function GetESCPath: IPathConfig;
    function GetGMTilesPath: IPathConfig;
    function GetMOBACTilesPath: IPathConfig;
    function GetTMSTilesPath: IPathConfig;
    function GetGECachePath: IPathConfig;
    function GetGCCachePath: IPathConfig;
    function GetBDBCachePath: IPathConfig;
    function GetBDBVerCachePath: IPathConfig;
    function GetDBMSCachePath: IPathConfig;
    function GetSQLiteCachePath: IPathConfig;
    function GetSQLiteMBTilesCachePath: IPathConfig;
    function GetSQLiteOsmAndCachePath: IPathConfig;
    function GetSQLiteLocusCachePath: IPathConfig;
    function GetSQLiteRMapsCachePath: IPathConfig;
  protected
    procedure DoReadConfig(const AConfigProvider: IConfigDataProvider); override;
    procedure DoWriteConfig(const AConfigProvider: IConfigDataWriteProvider); override;
  public
    constructor Create(
      const ACacheGlobalPath: IPathConfig
    );
  end;

implementation

uses
  c_CacheTypeCodes,
  u_PathConfig,
  u_ConfigSaveLoadStrategyBasicProviderSubItem;

{ TGlobalCacheConfig }

constructor TGlobalCacheConfig.Create(
  const ACacheGlobalPath: IPathConfig
);
begin
  inherited Create;
  FCacheGlobalPath := ACacheGlobalPath;
  FDefCache := c_File_Cache_Id_SQLite;

  FOldCPath := TPathConfig.Create('GMVC', c_File_Cache_Default_GMV, FCacheGlobalPath);
  Add(FOldCPath, TConfigSaveLoadStrategyBasicProviderSubItem.Create('PathToCache'), False, False, False, False);

  FNewCPath := TPathConfig.Create('SASC', c_File_Cache_Default_SAS, FCacheGlobalPath);
  Add(FNewCPath, TConfigSaveLoadStrategyBasicProviderSubItem.Create('PathToCache'), False, False, False, False);

  FESCPath := TPathConfig.Create('ESC', c_File_Cache_Default_ES, FCacheGlobalPath);
  Add(FESCPath, TConfigSaveLoadStrategyBasicProviderSubItem.Create('PathToCache'), False, False, False, False);

  FGMTilesPath := TPathConfig.Create('GMTiles', c_File_Cache_Default_GM, FCacheGlobalPath);
  Add(FGMTilesPath, TConfigSaveLoadStrategyBasicProviderSubItem.Create('PathToCache'), False, False, False, False);

  FMOBACPath := TPathConfig.Create('MOBACTiles', c_File_Cache_Default_MA, FCacheGlobalPath);
  Add(FMOBACPath, TConfigSaveLoadStrategyBasicProviderSubItem.Create('PathToCache'), False, False, False, False);

  FTMSPath := TPathConfig.Create('TMSTiles', c_File_Cache_Default_TMS, FCacheGlobalPath);
  Add(FTMSPath, TConfigSaveLoadStrategyBasicProviderSubItem.Create('PathToCache'), False, False, False, False);

  FGECachePath := TPathConfig.Create('GECache', c_File_Cache_Default_GE, FCacheGlobalPath);
  Add(FGECachePath, TConfigSaveLoadStrategyBasicProviderSubItem.Create('PathToCache'), False, False, False, False);

  FGCCachePath := TPathConfig.Create('GCCache', c_File_Cache_Default_GC, FCacheGlobalPath);
  Add(FGCCachePath, TConfigSaveLoadStrategyBasicProviderSubItem.Create('PathToCache'), False, False, False, False);

  FBDBCachePath := TPathConfig.Create('BDBCache', c_File_Cache_Default_BDB, FCacheGlobalPath);
  Add(FBDBCachePath, TConfigSaveLoadStrategyBasicProviderSubItem.Create('PathToCache'), False, False, False, False);

  FBDBVerCachePath := TPathConfig.Create('BDBVerCache', c_File_Cache_Default_BDBv, FCacheGlobalPath);
  Add(FBDBVerCachePath, TConfigSaveLoadStrategyBasicProviderSubItem.Create('PathToCache'), False, False, False, False);

  FDBMSCachePath := TPathConfig.Create('DBMSCache', c_File_Cache_Default_DBMS, FCacheGlobalPath);
  Add(FDBMSCachePath, TConfigSaveLoadStrategyBasicProviderSubItem.Create('PathToCache'), False, False, False, False);

  FSQLiteCachePath := TPathConfig.Create('SQLiteCache', c_File_Cache_Default_SQLite, FCacheGlobalPath);
  Add(FSQLiteCachePath, TConfigSaveLoadStrategyBasicProviderSubItem.Create('PathToCache'), False, False, False, False);

  FSQLiteMBTilesCachePath := TPathConfig.Create('MBTilesCache', c_File_Cache_Default_SQLite_MBTiles, FCacheGlobalPath);
  Add(FSQLiteMBTilesCachePath, TConfigSaveLoadStrategyBasicProviderSubItem.Create('PathToCache'), False, False, False, False);

  FSQLiteOsmAndCachePath := TPathConfig.Create('OsmAndCache', c_File_Cache_Default_SQLite_OsmAnd, FCacheGlobalPath);
  Add(FSQLiteOsmAndCachePath, TConfigSaveLoadStrategyBasicProviderSubItem.Create('PathToCache'), False, False, False, False);

  FSQLiteLocusCachePath := TPathConfig.Create('LocusCache', c_File_Cache_Default_SQLite_Locus, FCacheGlobalPath);
  Add(FSQLiteLocusCachePath, TConfigSaveLoadStrategyBasicProviderSubItem.Create('PathToCache'), False, False, False, False);

  FSQLiteRMapsCachePath := TPathConfig.Create('RMaps', c_File_Cache_Default_SQLite_RMaps, FCacheGlobalPath);
  Add(FSQLiteRMapsCachePath, TConfigSaveLoadStrategyBasicProviderSubItem.Create('PathToCache'), False, False, False, False);
end;

procedure TGlobalCacheConfig.DoReadConfig(const AConfigProvider: IConfigDataProvider);
var
  VViewConfig: IConfigDataProvider;
begin
  inherited;
  if AConfigProvider <> nil then begin
    VViewConfig := AConfigProvider.GetSubItem('VIEW');
    if VViewConfig <> nil then begin
      SetDefCache(VViewConfig.ReadInteger('DefCache', FDefCache));
    end;
  end;
end;

procedure TGlobalCacheConfig.DoWriteConfig(
  const AConfigProvider: IConfigDataWriteProvider
);
var
  VViewConfig: IConfigDataWriteProvider;
begin
  inherited;
  VViewConfig := AConfigProvider.GetOrCreateSubItem('VIEW');
  VViewConfig.WriteInteger('DefCache', FDefCache);
end;

function TGlobalCacheConfig.GetBDBCachePath: IPathConfig;
begin
  Result := FBDBCachePath;
end;

function TGlobalCacheConfig.GetBDBVerCachePath: IPathConfig;
begin
  Result := FBDBVerCachePath;
end;

function TGlobalCacheConfig.GetDBMSCachePath: IPathConfig;
begin
  Result := FDBMSCachePath;
end;

function TGlobalCacheConfig.GetDefCache: Byte;
begin
  LockRead;
  try
    Result := FDefCache;
  finally
    UnlockRead;
  end;
end;

function TGlobalCacheConfig.GetESCPath: IPathConfig;
begin
  Result := FESCPath;
end;

function TGlobalCacheConfig.GetGCCachePath: IPathConfig;
begin
  Result := FGCCachePath;
end;

function TGlobalCacheConfig.GetGECachePath: IPathConfig;
begin
  Result := FGECachePath;
end;

function TGlobalCacheConfig.GetGMTilesPath: IPathConfig;
begin
  Result := FGMTilesPath;
end;

function TGlobalCacheConfig.GetMOBACTilesPath: IPathConfig;
begin
  Result := FMOBACPath;
end;

function TGlobalCacheConfig.GetTMSTilesPath: IPathConfig;
begin
  Result := FTMSPath;
end;

function TGlobalCacheConfig.GetNewCPath: IPathConfig;
begin
  Result := FNewCPath;
end;

function TGlobalCacheConfig.GetOldCPath: IPathConfig;
begin
  Result := FOldCPath;
end;

function TGlobalCacheConfig.GetSQLiteCachePath: IPathConfig;
begin
  Result := FSQLiteCachePath;
end;

function TGlobalCacheConfig.GetSQLiteLocusCachePath: IPathConfig;
begin
  Result := FSQLiteLocusCachePath;
end;

function TGlobalCacheConfig.GetSQLiteMBTilesCachePath: IPathConfig;
begin
  Result := FSQLiteMBTilesCachePath;
end;

function TGlobalCacheConfig.GetSQLiteOsmAndCachePath: IPathConfig;
begin
  Result := FSQLiteOsmAndCachePath;
end;

function TGlobalCacheConfig.GetSQLiteRMapsCachePath: IPathConfig;
begin
  Result := FSQLiteRMapsCachePath;
end;

procedure TGlobalCacheConfig.SetDefCache(const AValue: Byte);
begin
  LockWrite;
  try
    if AValue in [
        c_File_Cache_Id_GMV,
        c_File_Cache_Id_SAS,
        c_File_Cache_Id_ES,
        c_File_Cache_Id_GM,
        c_File_Cache_Id_GM_Aux,
        c_File_Cache_Id_MOBAC,
        c_File_Cache_Id_TMS,
        c_File_Cache_Id_DBMS,
        c_File_Cache_Id_SQLite,
        c_File_Cache_Id_RAM,
        c_File_Cache_Id_BDB,
        c_File_Cache_Id_BDB_Versioned,
        c_File_Cache_Id_SQLite_MBTiles,
        c_File_Cache_Id_SQLite_OsmAnd,
        c_File_Cache_Id_SQLite_Locus,
        c_File_Cache_Id_SQLite_RMaps
      ]
    then begin
      if FDefCache <> AValue then begin
        FDefCache := AValue;
        SetChanged;
      end;
    end;
  finally
    UnlockWrite;
  end;
end;

end.
