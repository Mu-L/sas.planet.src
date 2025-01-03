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

unit u_RegionProcessTaskCombine;

interface

uses
  Classes,
  Types,
  i_Projection,
  i_BitmapTileProvider,
  i_RegionProcessProgressInfo,
  i_GeometryLonLat,
  i_MapCalibration,
  i_BitmapMapCombiner,
  u_RegionProcessTaskAbstract;

type
  TRegionProcessTaskCombine = class(TRegionProcessTaskAbstract)
  private
    FImageProvider: IBitmapTileProvider;
    FMapRect: TRect;
    FMapCalibrationList: IMapCalibrationList;
    FSplitCount: TPoint;
    FSkipExistingFiles: Boolean;
    FRoundToTileRect: Boolean;
    FFileName: string;
    FFilePath: string;
    FFileExt: string;
    FCombiner: IBitmapMapCombiner;
    FCombinerCustomParams: IInterface;
  protected
    procedure ProgressFormUpdateOnProgress(AProgress: Double);
    procedure ProcessRegion; override;
  public
    constructor Create(
      const AProgressInfo: IRegionProcessProgressInfoInternal;
      const APolygon: IGeometryLonLatPolygon;
      const AMapRect: TRect;
      const ACombiner: IBitmapMapCombiner;
      const ACombinerCustomParams: IInterface;
      const AImageProvider: IBitmapTileProvider;
      const AMapCalibrationList: IMapCalibrationList;
      const AFileName: string;
      const ASplitCount: TPoint;
      const ASkipExistingFiles: Boolean;
      const ARoundToTileRect: Boolean
    );
  end;

implementation

uses
  SysUtils,
  u_GeoFunc,
  u_ResStrings;

{ TRegionProcessTaskCombine }

constructor TRegionProcessTaskCombine.Create(
  const AProgressInfo: IRegionProcessProgressInfoInternal;
  const APolygon: IGeometryLonLatPolygon;
  const AMapRect: TRect;
  const ACombiner: IBitmapMapCombiner;
  const ACombinerCustomParams: IInterface;
  const AImageProvider: IBitmapTileProvider;
  const AMapCalibrationList: IMapCalibrationList;
  const AFileName: string;
  const ASplitCount: TPoint;
  const ASkipExistingFiles: Boolean;
  const ARoundToTileRect: Boolean
);
begin
  inherited Create(
    AProgressInfo,
    APolygon,
    nil
  );
  FMapRect := AMapRect;
  FCombiner := ACombiner;
  FCombinerCustomParams := ACombinerCustomParams;
  FImageProvider := AImageProvider;
  FSplitCount := ASplitCount;
  FSkipExistingFiles := ASkipExistingFiles;
  FRoundToTileRect := ARoundToTileRect;
  FFilePath := ExtractFilePath(AFileName);
  FFileExt := ExtractFileExt(AFileName);
  FFileName := ChangeFileExt(ExtractFileName(AFileName), '');
  FMapCalibrationList := AMapCalibrationList;
end;

procedure TRegionProcessTaskCombine.ProgressFormUpdateOnProgress(AProgress: Double);
begin
  ProgressInfo.SetProcessedRatio(AProgress);
  ProgressInfo.SetSecondLine(SAS_STR_Processed + ': ' + IntToStr(Trunc(AProgress * 100)) + '%');
end;


procedure TRegionProcessTaskCombine.ProcessRegion;
var
  VProjection: IProjection;
  I, J, K: Integer;
  VProcessTiles: Int64;
  VTileRect: TRect;
  VMapRect: TRect;
  VMapSize: TPoint;
  VCurrentPieceRect: TRect;
  VMapPieceSize: TPoint;
  VSizeInTile: TPoint;
  VCurrentFileName: string;
  VStr: string;
begin
  inherited;
  VProjection := FImageProvider.Projection;

  VTileRect := VProjection.PixelRect2TileRect(FMapRect);

  if FRoundToTileRect then begin
    VMapRect := VProjection.TileRect2PixelRect(VTileRect);
  end else begin
    VMapRect := FMapRect;
  end;
  VMapSize := RectSize(VMapRect);

  VStr :=
    Format(
      SAS_STR_MapCombineProgressCaption,
      [VMapSize.X, VMapSize.Y, FSplitCount.X * FSplitCount.Y]
    );
  ProgressInfo.SetCaption(VStr);

  VSizeInTile := RectSize(VTileRect);
  VProcessTiles := Int64(VSizeInTile.X) * VSizeInTile.Y;

  VStr :=
    Format(
      SAS_STR_MapCombineProgressLine0,
      [VSizeInTile.X, VSizeInTile.Y, VProcessTiles]
    );
  ProgressInfo.SetFirstLine(VStr);

  ProgressFormUpdateOnProgress(0);

  if FRoundToTileRect then begin
    VMapPieceSize.X := (VSizeInTile.X div FSplitCount.X) * 256;
    VMapPieceSize.Y := (VSizeInTile.Y div FSplitCount.Y) * 256;
  end else begin
    VMapPieceSize.X := VMapSize.X div FSplitCount.X;
    VMapPieceSize.Y := VMapSize.Y div FSplitCount.Y;
  end;

  for I := 1 to FSplitCount.X do begin
    for J := 1 to FSplitCount.Y do begin
      VCurrentPieceRect.Left := VMapRect.Left + VMapPieceSize.X * (I - 1);
      VCurrentPieceRect.Right := VMapRect.Left + VMapPieceSize.X * I;
      VCurrentPieceRect.Top := VMapRect.Top + VMapPieceSize.Y * (J - 1);
      VCurrentPieceRect.Bottom := VMapRect.Top + VMapPieceSize.Y * J;

      if I = FSplitCount.X then begin
        VCurrentPieceRect.Right := VMapRect.Right;
      end;
      if J = FSplitCount.Y then begin
        VCurrentPieceRect.Bottom := VMapRect.Bottom;
      end;

      if (FSplitCount.X > 1) or (FSplitCount.Y > 1) then begin
        VCurrentFileName := FFilePath + FFileName + '_' + IntToStr(I) + '-' + IntToStr(J) + FFileExt;
        if FSkipExistingFiles and FileExists(VCurrentFileName) then begin
          Continue;
        end;
      end else begin
        VCurrentFileName := FFilePath + FFileName + FFileExt;
      end;

      if Assigned(FMapCalibrationList) then begin
        for K := 0 to FMapCalibrationList.Count - 1 do begin
          try
            (FMapCalibrationList.Get(K) as IMapCalibration).SaveCalibrationInfo(
              VCurrentFileName,
              VCurrentPieceRect.TopLeft,
              VCurrentPieceRect.BottomRight,
              VProjection
            );
          except
            //TODO: �������� ���� ���������� ��������� ������.
          end;
        end;
      end;

      try
        FCombiner.SaveRect(
          OperationID,
          CancelNotifier,
          VCurrentFileName,
          FImageProvider,
          VCurrentPieceRect,
          FCombinerCustomParams
        );
      except
        on E: Exception do begin
          if (FSplitCount.X > 1) or (FSplitCount.Y > 1) then begin
            raise Exception.CreateFmt(
              '%0:s'#13#10'Piece %1:dx%2:d',
              [E.message, I, J]
            );
          end else begin
            raise;
          end;
        end;
      end;
    end;
  end;
end;

end.
