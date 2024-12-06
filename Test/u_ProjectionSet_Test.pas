unit u_ProjectionSet_Test;

interface

uses
  TestFramework,
  i_ProjectionSet,
  i_ProjectionSetFactory;

type
  TestProjectionSet = class(TTestCase)
  private
    FProjectionSet: IProjectionSet;
    FProjectionSetFactory: IProjectionSetFactory;

    procedure DoTests;
    procedure CheckDouble(expected, actual: Double; msg: string = '');
  private
    procedure Check_TilesAtZoom;

    procedure Check_TilePos2PixelPos;
    procedure Check_TilePos2PixelRect;
    procedure Check_TilePos2Relative;
    procedure Check_TilePos2RelativeRect;

    procedure Check_PixelPos2TilePos;
    procedure Check_PixelPos2Relative;
    procedure Check_PixelRect2TileRect;
    procedure Check_PixelRect2RelativeRect;

    procedure Check_Relative2PixelPos;
    procedure Check_Relative2TilePos;
    procedure Check_RelativeRect2PixelRect;
    procedure Check_RelativeRect2TileRect;

    procedure Check_TilePos2LonLat2TilePos;
    procedure Check_Relative2LonLat2Relative;

    procedure Check_MonotonicRelative2LonLat;
  protected
    procedure SetUp; override;
  published
    procedure TestGeographic;
    procedure TestMercatorOnSphere;
    procedure TestMercatorOnEllipsoid;
  end;

implementation

uses
  Types,
  Math,
  SysUtils,
  c_CoordConverter,
  t_GeoTypes,
  i_HashFunction,
  i_DatumFactory,
  i_ProjectionType,
  u_GeoFunc,
  u_DatumFactory,
  u_HashFunctionCityHash,
  u_HashFunctionWithCounter,
  u_InternalPerformanceCounterFake,
  u_ProjectionBasic256x256,
  u_ProjectionSetFactorySimple;

{ TestProjectionSet }

procedure TestProjectionSet.CheckDouble(expected, actual: Double; msg: string);
const
  cEpsilon = 1 / (1 shl 30 + (1 shl 30 - 1));
begin
  if Abs(expected - actual) > cEpsilon then begin
    FailNotEquals(FloatToStr(expected), FloatToStr(actual), msg, ReturnAddress);
  end;
end;

procedure TestProjectionSet.SetUp;
var
  VHashFunction: IHashFunction;
  VDatumFactory: IDatumFactory;
begin
  inherited;

  VHashFunction :=
    THashFunctionWithCounter.Create(
      THashFunctionCityHash.Create,
      TInternalPerformanceCounterFake.Create
    );

  VDatumFactory := TDatumFactory.Create(VHashFunction);

  FProjectionSetFactory :=
    TProjectionSetFactorySimple.Create(
      VHashFunction,
      VDatumFactory
    );
end;

procedure TestProjectionSet.TestGeographic;
begin
  FProjectionSet := FProjectionSetFactory.GetProjectionSetByCode(CGELonLatProjectionEPSG, CTileSplitQuadrate256x256);
  DoTests;
  FProjectionSet := nil;
end;

procedure TestProjectionSet.TestMercatorOnEllipsoid;
begin
  FProjectionSet := FProjectionSetFactory.GetProjectionSetByCode(CYandexProjectionEPSG, CTileSplitQuadrate256x256);
  DoTests;
  FProjectionSet := nil;
end;

procedure TestProjectionSet.TestMercatorOnSphere;
begin
  FProjectionSet := FProjectionSetFactory.GetProjectionSetByCode(CGoogleProjectionEPSG, CTileSplitQuadrate256x256);
  DoTests;
  FProjectionSet := nil;
end;

procedure TestProjectionSet.DoTests;
begin
  Check_TilesAtZoom;

  Check_TilePos2PixelPos;
  Check_TilePos2PixelRect;
  Check_TilePos2Relative;
  Check_TilePos2RelativeRect;

  Check_PixelPos2TilePos;
  Check_PixelPos2Relative;
  Check_PixelRect2TileRect;
  Check_PixelRect2RelativeRect;

  Check_Relative2PixelPos;
  Check_Relative2TilePos;
  Check_RelativeRect2PixelRect;
  Check_RelativeRect2TileRect;

  Check_TilePos2LonLat2TilePos;
  Check_Relative2LonLat2Relative;

  Check_MonotonicRelative2LonLat;
end;

procedure TestProjectionSet.Check_TilesAtZoom;

  function TilesAtZoom(const AZoom: Byte): Integer;
  begin
    with FProjectionSet.Zooms[AZoom].GetTileRect do begin
      Result := Right - Left;
    end;
  end;

const
  cPrefix = 'TilesAtZoom' + ': ';
var
  VCount: Integer;
begin
  VCount := TilesAtZoom(0);
  CheckEquals(1, VCount, cPrefix + '�� ���� 0 ������ ���� 1 ����');

  VCount := TilesAtZoom(1);
  CheckEquals(2, VCount, cPrefix + '�� ���� 1 ������ ���� 2 �����');

  VCount := TilesAtZoom(23);
  CheckEquals(8388608, VCount, cPrefix + '�� ���� 23 ������ ���� 8388608 ������');
end;

procedure TestProjectionSet.Check_TilePos2PixelPos;
const
  cPrefix = 'TilePos2PixelPos' + ': ';
var
  VPos: TPoint;
begin
  VPos := FProjectionSet.Zooms[0].TilePos2PixelPos(Point(0, 0));
  CheckEquals(0, VPos.X, cPrefix + 'Z = 0. ������ � X ����������');
  CheckEquals(0, VPos.Y, cPrefix + 'Z = 0. ������ � Y ����������');

  VPos := FProjectionSet.Zooms[1].TilePos2PixelPos(Point(0, 1));
  CheckEquals(  0, VPos.X, cPrefix + 'Z = 1. ������ � X ����������');
  CheckEquals(256, VPos.Y, cPrefix + 'Z = 1. ������ � Y ����������');

  VPos := FProjectionSet.Zooms[1].TilePos2PixelPos(Point(1, 1));
  CheckEquals(256, VPos.X, cPrefix + 'Z = 1. ������ � X ����������');
  CheckEquals(256, VPos.Y, cPrefix + 'Z = 1. ������ � Y ����������');

  VPos := FProjectionSet.Zooms[23].TilePos2PixelPos(Point(1, 1));
  CheckEquals(256, VPos.X, cPrefix + 'Z = 23. ������ � X ����������');
  CheckEquals(256, VPos.Y, cPrefix + 'Z = 23. ������ � Y ����������');

  VPos := FProjectionSet.Zooms[23].TilePos2PixelPos(Point(1 shl 23 - 1, 1 shl 23 - 1));
  CheckEquals(2147483392, VPos.X, cPrefix + 'Z = 23. ������ � X ����������');
  CheckEquals(2147483392, VPos.Y, cPrefix + 'Z = 23. ������ � X ����������');
end;

procedure TestProjectionSet.Check_TilePos2PixelRect;

  function TilesAtZoom(const AZoom: Byte): Integer;
  begin
    with FProjectionSet.Zooms[AZoom].GetTileRect do begin
      Result := Right - Left;
    end;
  end;

const
  cPrefix = 'TilePos2PixelRect' + ': ';
var
  VRect: TRect;
begin
  VRect := FProjectionSet.Zooms[0].TilePos2PixelRect(Point(0, 0));
  CheckEquals(  0, VRect.Left,   cPrefix + 'Z = 0. ������ � Left ��������������');
  CheckEquals(  0, VRect.Top,    cPrefix + 'Z = 0. ������ � Top ��������������');
  CheckEquals(256, VRect.Right,  cPrefix + 'Z = 0. ������ � Right ��������������');
  CheckEquals(256, VRect.Bottom, cPrefix + 'Z = 0. ������ � Bottom ��������������');

  VRect := FProjectionSet.Zooms[1].TilePos2PixelRect(Point(1, 0));
  CheckEquals(256, VRect.Left,   cPrefix + 'Z = 1. ������ � Left ��������������');
  CheckEquals(  0, VRect.Top,    cPrefix + 'Z = 1. ������ � Top ��������������');
  CheckEquals(512, VRect.Right,  cPrefix + 'Z = 1. ������ � Right ��������������');
  CheckEquals(256, VRect.Bottom, cPrefix + 'Z = 1. ������ � Bottom ��������������');

  VRect := FProjectionSet.Zooms[23].TilePos2PixelRect(Point(TilesAtZoom(23) - 1, TilesAtZoom(23) - 1));
  CheckEquals(2147483392, VRect.Left,   cPrefix + 'Z = 23. ������ � Left ��������������');
  CheckEquals(2147483392, VRect.Top,    cPrefix + 'Z = 23. ������ � Top ��������������');
  CheckEquals(2147483647, VRect.Right,  cPrefix + 'Z = 23. ������ � Right ��������������');
  CheckEquals(2147483647, VRect.Bottom, cPrefix + 'Z = 23. ������ � Bottom ��������������');
end;

procedure TestProjectionSet.Check_TilePos2Relative;
const
  cPrefix = 'TilePos2Relative' + ': ';
var
  VRelative: TDoublePoint;
begin
  VRelative := FProjectionSet.Zooms[0].TilePos2Relative(Point(0, 0));
  CheckEquals(0, VRelative.X, cPrefix + '�� ���� 0 ������������� ���������� ������������� ����� ������ ���� (0;0)');
  CheckEquals(0, VRelative.Y, cPrefix + '�� ���� 0 ������������� ���������� ������������� ����� ������ ���� (0;0)');

  VRelative := FProjectionSet.Zooms[1].TilePos2Relative(Point(0, 0));
  CheckEquals(0, VRelative.X, cPrefix + '�� ���� 1 ������������� ���������� ����� (0;0) ������ ���� (0;0)');
  CheckEquals(0, VRelative.Y, cPrefix + '�� ���� 1 ������������� ���������� ����� (0;0) ������ ���� (0;0)');

  VRelative := FProjectionSet.Zooms[1].TilePos2Relative(Point(1, 1));
  CheckEquals(0.5, VRelative.X, cPrefix + '�� ���� 1 ������������� ���������� ����� (1;1) ������ ���� (0.5;0.5)');
  CheckEquals(0.5, VRelative.Y, cPrefix + '�� ���� 1 ������������� ���������� ����� (1;1) ������ ���� (0.5;0.5)');

  VRelative := FProjectionSet.Zooms[1].TilePos2Relative(Point(2, 2));
  CheckEquals(1, VRelative.X, cPrefix + '�� ���� 1 ������������� ���������� ����� (2;2) ������ ���� (1;1)');
  CheckEquals(1, VRelative.Y, cPrefix + '�� ���� 1 ������������� ���������� ����� (2;2) ������ ���� (1;1)');

  VRelative := FProjectionSet.Zooms[23].TilePos2Relative(Point(0, 0));
  CheckEquals(0, VRelative.X, cPrefix + '�� ���� 23 ������������� ���������� ����� (0;0) ������ ���� (0;0)');
  CheckEquals(0, VRelative.Y, cPrefix + '�� ���� 23 ������������� ���������� ����� (0;0) ������ ���� (0;0)');

  VRelative := FProjectionSet.Zooms[23].TilePos2Relative(Point(1, 1));
  CheckDouble(1.1920928955e-07, VRelative.X, cPrefix + '�� ���� 23 ������������� ���������� ����� (1;1) ������ ���� (1.1920928955e-07;1.1920928955e-07)');
  CheckDouble(1.1920928955e-07, VRelative.Y, cPrefix + '�� ���� 23 ������������� ���������� ����� (1;1) ������ ���� (1.1920928955e-07;1.1920928955e-07)');

  VRelative := FProjectionSet.Zooms[23].TilePos2Relative(Point(1 shl 23, 1 shl 23));
  CheckEquals(1, VRelative.X, cPrefix + '�� ���� 23 ������������� ���������� ����� (Max;Max) ������ ���� (1;1)');
  CheckEquals(1, VRelative.Y, cPrefix + '�� ���� 23 ������������� ���������� ����� (Max;Max) ������ ���� (1;1)');
end;

procedure TestProjectionSet.Check_TilePos2RelativeRect;
const
  cPrefix = 'TilePos2RelativeRect' + ': ';
var
  VRect: TDoubleRect;
begin
  VRect := FProjectionSet.Zooms[0].TilePos2RelativeRect(Point(0, 0));
  CheckEquals(0, VRect.Left,   cPrefix + 'Z = 0. ������ � Left');
  CheckEquals(0, VRect.Top,    cPrefix + 'Z = 0. ������ � Top');
  CheckEquals(1, VRect.Right,  cPrefix + 'Z = 0. ������ � Right');
  CheckEquals(1, VRect.Bottom, cPrefix + 'Z = 0. ������ � Bottom');

  VRect := FProjectionSet.Zooms[1].TilePos2RelativeRect(Point(1, 1));
  CheckEquals(0.5, VRect.Left, cPrefix + 'Z = 1. ������ � Left');
  CheckEquals(0.5, VRect.Top,  cPrefix + 'Z = 1. ������ � Top');
  CheckEquals(1, VRect.Right,  cPrefix + 'Z = 1. ������ � Right');
  CheckEquals(1, VRect.Bottom, cPrefix + 'Z = 1. ������ � Bottom');

  VRect := FProjectionSet.Zooms[23].TilePos2RelativeRect(Point(1 shl 23 - 1, 1 shl 23 - 1));
  CheckDouble(1 - 1.1920928955e-07, VRect.Left, cPrefix + 'Z = 23. ������ � Left');
  CheckDouble(1 - 1.1920928955e-07, VRect.Top,  cPrefix + 'Z = 23. ������ � Top');
  CheckDouble(1, VRect.Right,  cPrefix + 'Z = 23. ������ � Right');
  CheckDouble(1, VRect.Bottom, cPrefix + 'Z = 23. ������ � Bottom');
end;

procedure TestProjectionSet.Check_PixelPos2TilePos;

  function PixelPos2TilePos(const APoint: TPoint; const AZoom: Byte): TPoint;
  begin
    Result := PointFromDoublePoint(
      FProjectionSet.Zooms[AZoom].PixelPos2TilePosFloat(APoint),
      prToTopLeft
    );
  end;

const
  cPrefix = 'PixelPos2TilePos' + ': ';
var
  VPos: TPoint;
begin
  VPos := PixelPos2TilePos(Point(0, 0), 0);
  CheckEquals(0, VPos.X, cPrefix + 'Z = 0. ������ � x ����������');
  CheckEquals(0, VPos.Y, cPrefix + 'Z = 0. ������ � y ����������');

  VPos := PixelPos2TilePos(Point(156, 73), 0);
  CheckEquals(0, VPos.X, cPrefix + 'Z = 0. ������ � x ����������');
  CheckEquals(0, VPos.Y, cPrefix + 'Z = 0. ������ � y ����������');

  VPos := PixelPos2TilePos(Point(255, 255), 0);
  CheckEquals(0, VPos.X, cPrefix + 'Z = 0. ������ � x ����������');
  CheckEquals(0, VPos.Y, cPrefix + 'Z = 0. ������ � y ����������');

  VPos := PixelPos2TilePos(Point(255, 255), 23);
  CheckEquals(0, VPos.X, cPrefix + 'Z = 23. ������ � x ����������');
  CheckEquals(0, VPos.Y, cPrefix + 'Z = 23. ������ � y ����������');

  VPos := PixelPos2TilePos(Point(2147483392, 2147483392 + 255), 23);
  CheckEquals(1 shl 23 - 1, VPos.X, cPrefix + 'Z = 23. ������ � x ����������');
  CheckEquals(1 shl 23 - 1, VPos.Y, cPrefix + 'Z = 23. ������ � y ����������');
end;

procedure TestProjectionSet.Check_PixelPos2Relative;
const
  cPrefix = 'PixelPos2Relative' + ': ';
var
  VRelative: TDoublePoint;
begin
  VRelative := FProjectionSet.Zooms[0].PixelPos2Relative(Point(0, 128));
  CheckDouble(  0, VRelative.X, cPrefix + 'z = 0 ������ � ��������� X');
  CheckDouble(0.5, VRelative.Y, cPrefix + 'z = 0 ������ � ��������� Y');

  VRelative := FProjectionSet.Zooms[0].PixelPos2Relative(Point(255, 256));
  CheckDouble(1 - 1/256, VRelative.X, cPrefix + 'z = 0 ������ � ��������� X');
  CheckDouble(1, VRelative.Y, cPrefix + 'z = 0 ������ � ��������� Y');

  VRelative := FProjectionSet.Zooms[23].PixelPos2Relative(Point(0, 1 shl 30));
  CheckDouble(0, VRelative.X, cPrefix + 'z = 23 ������ � ��������� X');
  CheckDouble(0.5, VRelative.Y, cPrefix + 'z = 23 ������ � ��������� Y');

  VRelative := FProjectionSet.Zooms[23].PixelPos2Relative(Point(2147483392 + 255, MaxInt));
  CheckDouble(1 - 1/(1 shl 30 + (1 shl 30 - 1)), VRelative.X, cPrefix + 'z = 23 ������ � ��������� X');
  CheckDouble(1, VRelative.Y, cPrefix + 'z = 23 ������ � ��������� Y');
end;

procedure TestProjectionSet.Check_PixelRect2TileRect;
const
  cPrefix = 'PixelRect2TileRect' + ': ';
var
  VRect: TRect;
begin
  VRect := FProjectionSet.Zooms[0].PixelRect2TileRect(Rect(0, 0, 255, 255));
  CheckEquals(0, VRect.Left,   cPrefix + 'Z = 0. ������ � Left ��������������');
  CheckEquals(0, VRect.Top,    cPrefix + 'Z = 0. ������ � Top ��������������');
  CheckEquals(1, VRect.Right,  cPrefix + 'Z = 0. ������ � Right ��������������');
  CheckEquals(1, VRect.Bottom, cPrefix + 'Z = 0. ������ � Bottom ��������������');

  VRect := FProjectionSet.Zooms[1].PixelRect2TileRect(Rect(0, 0, 255, 255));
  CheckEquals(0, VRect.Left,   cPrefix + 'Z = 1. ������ � Left ��������������');
  CheckEquals(0, VRect.Top,    cPrefix + 'Z = 1. ������ � Top ��������������');
  CheckEquals(1, VRect.Right,  cPrefix + 'Z = 1. ������ � Right ��������������');
  CheckEquals(1, VRect.Bottom, cPrefix + 'Z = 1. ������ � Bottom ��������������');

  VRect := FProjectionSet.Zooms[1].PixelRect2TileRect(Rect(0, 0, 511, 255));
  CheckEquals(0, VRect.Left,   cPrefix + 'Z = 1. ������ � Left ��������������');
  CheckEquals(0, VRect.Top,    cPrefix + 'Z = 1. ������ � Top ��������������');
  CheckEquals(2, VRect.Right,  cPrefix + 'Z = 1. ������ � Right ��������������');
  CheckEquals(1, VRect.Bottom, cPrefix + 'Z = 1. ������ � Bottom ��������������');

  VRect := FProjectionSet.Zooms[23].PixelRect2TileRect(Rect(0, 0, 511, 255));
  CheckEquals(0, VRect.Left,   cPrefix + 'Z = 23. ������ � Left ��������������');
  CheckEquals(0, VRect.Top,    cPrefix + 'Z = 23. ������ � Top ��������������');
  CheckEquals(2, VRect.Right,  cPrefix + 'Z = 23. ������ � Right ��������������');
  CheckEquals(1, VRect.Bottom, cPrefix + 'Z = 23. ������ � Bottom ��������������');

  VRect := FProjectionSet.Zooms[23].PixelRect2TileRect(Rect(2147483392, 2147483392 + 255, 2147483392, 2147483392 + 255));
  CheckEquals(8388607, VRect.Left,   cPrefix + 'Z = 23. ������ � Left ��������������');
  CheckEquals(8388607, VRect.Top,    cPrefix + 'Z = 23. ������ � Top ��������������');
  CheckEquals(8388607, VRect.Right,  cPrefix + 'Z = 23. ������ � Right ��������������');
  CheckEquals(8388608, VRect.Bottom, cPrefix + 'Z = 23. ������ � Bottom ��������������');

  VRect := FProjectionSet.Zooms[23].PixelRect2TileRect(Rect(0, 0, 2147483392, 2147483392 + 255));
  CheckEquals(      0, VRect.Left,   cPrefix + 'Z = 23. ������ � Left ��������������');
  CheckEquals(      0, VRect.Top,    cPrefix + 'Z = 23. ������ � Top ��������������');
  CheckEquals(8388607, VRect.Right,  cPrefix + 'Z = 23. ������ � Right ��������������');
  CheckEquals(8388608, VRect.Bottom, cPrefix + 'Z = 23. ������ � Bottom ��������������');
end;

procedure TestProjectionSet.Check_PixelRect2RelativeRect;
const
  cPrefix = 'PixelRect2RelativeRect' + ': ';
var
  VRect: TDoubleRect;
begin
  VRect := FProjectionSet.Zooms[0].PixelRect2RelativeRect(Rect(0,0,0,0));
  CheckDouble(0, VRect.Left,   cPrefix + 'Z = 0. ������ � Left');
  CheckDouble(0, VRect.Top,    cPrefix + 'Z = 0. ������ � Top');
  CheckDouble(0, VRect.Right,  cPrefix + 'Z = 0. ������ � Right');
  CheckDouble(0, VRect.Bottom, cPrefix + 'Z = 0. ������ � Bottom');

  VRect := FProjectionSet.Zooms[0].PixelRect2RelativeRect(Rect(0,0,256,256));
  CheckDouble(0, VRect.Left,   cPrefix + 'Z = 0. ������ � Left');
  CheckDouble(0, VRect.Top,    cPrefix + 'Z = 0. ������ � Top');
  CheckDouble(1, VRect.Right,  cPrefix + 'Z = 0. ������ � Right');
  CheckDouble(1, VRect.Bottom, cPrefix + 'Z = 0. ������ � Bottom');

  VRect := FProjectionSet.Zooms[23].PixelRect2RelativeRect(Rect(0, 1 shl 30, 255, 2147483392 + 255));
  CheckDouble(0, VRect.Left,  cPrefix + 'Z = 23. ������ � Left');
  CheckDouble(0.5, VRect.Top, cPrefix + 'Z = 23. ������ � Top');
  CheckDouble(1/(1 shl 23), VRect.Right, cPrefix + 'Z = 23. ������ � Right');
  CheckDouble(1, VRect.Bottom, cPrefix + 'Z = 23. ������ � Bottom');
end;

procedure TestProjectionSet.Check_Relative2PixelPos;

  function Relative2PixelPos(const ARelative: TDoublePoint; const AZoom: Byte): TPoint;
  begin
    Result := PointFromDoublePoint(
      FProjectionSet.Zooms[AZoom].Relative2PixelPosFloat(ARelative),
      prToTopLeft
    );
  end;

const
  cPrefix = 'Relative2PixelPos' + ': ';
var
  VPixel: TPoint;
begin
  VPixel := Relative2PixelPos(DoublePoint(1/256, 1/500), 0);
  CheckEquals(1, VPixel.X, cPrefix + 'Z = 0. ������ � x ����������');
  CheckEquals(0, VPixel.Y, cPrefix + 'Z = 0. ������ � y ����������');

  VPixel := Relative2PixelPos(DoublePoint(1, 1), 0);
  CheckEquals(256, VPixel.X, cPrefix + 'Z = 0. ������ � x ����������');
  CheckEquals(256, VPixel.Y, cPrefix + 'Z = 0. ������ � y ����������');

  VPixel := Relative2PixelPos(DoublePoint(1, 1), 23);
  CheckEquals(MaxInt, VPixel.X, cPrefix + 'Z = 23. ������ � x ����������');
  CheckEquals(MaxInt, VPixel.Y, cPrefix + 'Z = 23. ������ � y ����������');
end;

procedure TestProjectionSet.Check_Relative2TilePos;

  function Relative2TilePos(const ARelative: TDoublePoint; const AZoom: Byte): TPoint;
  begin
    Result := PointFromDoublePoint(
      FProjectionSet.Zooms[AZoom].Relative2TilePosFloat(ARelative),
      prToTopLeft
    );
  end;

const
  cPrefix = 'Relative2TilePos' + ': ';
var
  VTile: TPoint;
begin
  VTile := Relative2TilePos(DoublePoint(1/256, 1/500), 0);
  CheckEquals(0, VTile.X, cPrefix + 'Z = 0. ������ � x ����������');
  CheckEquals(0, VTile.Y, cPrefix + 'Z = 0. ������ � y ����������');

  VTile := Relative2TilePos(DoublePoint(1, 1), 0);
  CheckEquals(1, VTile.X, cPrefix + 'Z = 0. ������ � x ����������');
  CheckEquals(1, VTile.Y, cPrefix + 'Z = 0. ������ � y ����������');

  VTile := Relative2TilePos(DoublePoint(1, 1), 23);
  CheckEquals(1 shl 23, VTile.X, cPrefix + 'Z = 23. ������ � x ����������');
  CheckEquals(1 shl 23, VTile.Y, cPrefix + 'Z = 23. ������ � y ����������');
end;

procedure TestProjectionSet.Check_RelativeRect2PixelRect;

  function RelativeRect2PixelRect(const ARelative: TDoubleRect; const AZoom: Byte): TRect;
  begin
    Result := RectFromDoubleRect(
      FProjectionSet.Zooms[AZoom].RelativeRect2PixelRectFloat(ARelative),
      rrToTopLeft
    );
  end;

const
  cPrefix = 'RelativeRect2PixelRect' + ': ';
var
  VRect: TRect;
begin
  VRect := RelativeRect2PixelRect(DoubleRect(0, 1/256, 1, 511/512), 0);
  CheckEquals(  0, VRect.Left,   cPrefix + 'Z = 0. ������ � Left ��������������');
  CheckEquals(  1, VRect.Top,    cPrefix + 'Z = 0. ������ � Top ��������������');
  CheckEquals(256, VRect.Right,  cPrefix + 'Z = 0. ������ � Right ��������������');
  CheckEquals(255, VRect.Bottom, cPrefix + 'Z = 0. ������ � Bottom ��������������');

  VRect := RelativeRect2PixelRect(DoubleRect(0, 1/256, 1, 511/512), 23);
  CheckEquals(0, VRect.Left, cPrefix + 'Z = 23. ������ � Left ��������������');
  CheckEquals(1 shl 23, VRect.Top, cPrefix + 'Z = 23. ������ � Top ��������������');
  CheckEquals(2147483647, VRect.Right, cPrefix + 'Z = 23. ������ � Right ��������������');
  CheckEquals(511 shl 22, VRect.Bottom, cPrefix + 'Z = 23. ������ � Bottom ��������������');
end;

procedure TestProjectionSet.Check_RelativeRect2TileRect;

  function RelativeRect2TileRect(const ARelative: TDoubleRect; const AZoom: Byte): TRect;
  begin
    Result := RectFromDoubleRect(
      FProjectionSet.Zooms[AZoom].RelativeRect2TileRectFloat(ARelative),
      rrToTopLeft
    );
  end;

const
  cPrefix = 'RelativeRect2TileRect' + ': ';
var
  VRect: TRect;
begin
  VRect := RelativeRect2TileRect(DoubleRect(0, 1/256, 1, 511/512), 0);
  CheckEquals(0, VRect.Left, cPrefix + 'Z = 0. ������ � Left ��������������');
  CheckEquals(0, VRect.Top, cPrefix + 'Z = 0. ������ � Top ��������������');
  CheckEquals(1, VRect.Right, cPrefix + 'Z = 0. ������ � Right ��������������');
  CheckEquals(0, VRect.Bottom, cPrefix + 'Z = 0. ������ � Bottom ��������������');

  VRect := RelativeRect2TileRect(DoubleRect(0, 1/256, 1, 511/512), 23);
  CheckEquals(0, VRect.Left, cPrefix + 'Z = 23. ������ � Left ��������������');
  CheckEquals(1 shl 15, VRect.Top, cPrefix + 'Z = 23. ������ � Top ��������������');
  CheckEquals(1 shl 23, VRect.Right, cPrefix + 'Z = 23. ������ � Right ��������������');
  CheckEquals(511 shl 14, VRect.Bottom, cPrefix + 'Z = 23. ������ � Bottom ��������������');
end;

procedure TestProjectionSet.Check_TilePos2LonLat2TilePos;

  function LonLat2TilePos(const ALonLat: TDoublePoint; const AZoom: Byte): TPoint;
  begin
    Result := PointFromDoublePoint(
      FProjectionSet.Zooms[AZoom].LonLat2TilePosFloat(ALonLat),
      prToTopLeft
    );
  end;

const
  cPrefix = 'TilePos2LonLat2TilePos' + ': ';
var
  VZoom: Byte;
  VSource, VResult: TPoint;
begin
  VSource := Point(10, 99);
  VZoom := 8;
  VResult := LonLat2TilePos(FProjectionSet.Zooms[VZoom].TilePos2LonLat(VSource), VZoom);
  CheckEquals(VSource.X, VResult.X, cPrefix + 'Z = 0. ������ � x ���������� X');
  CheckEquals(VSource.Y, VResult.Y, cPrefix + 'Z = 0. ������ � x ���������� Y');

  VZoom := 10;
  VResult := LonLat2TilePos(FProjectionSet.Zooms[VZoom].TilePos2LonLat(VSource), VZoom);
  CheckEquals(VSource.X, VResult.X, cPrefix + 'Z = 10. ������ � x ���������� X');
  CheckEquals(VSource.Y, VResult.Y, cPrefix + 'Z = 10. ������ � x ���������� Y');

  VZoom := 14;
  VResult := LonLat2TilePos(FProjectionSet.Zooms[VZoom].TilePos2LonLat(VSource), VZoom);
  CheckEquals(VSource.X, VResult.X, cPrefix + 'Z = 14. ������ � x ���������� X');
  CheckEquals(VSource.Y, VResult.Y, cPrefix + 'Z = 14. ������ � x ���������� Y');

  VZoom := 20;
  VResult := LonLat2TilePos(FProjectionSet.Zooms[VZoom].TilePos2LonLat(VSource), VZoom);
  CheckEquals(VSource.X, VResult.X, cPrefix + 'Z = 20. ������ � x ���������� X');
  CheckEquals(VSource.Y, VResult.Y, cPrefix + 'Z = 20. ������ � x ���������� Y');

  VZoom := 23;
  VResult := LonLat2TilePos(FProjectionSet.Zooms[VZoom].TilePos2LonLat(VSource), VZoom);
  CheckEquals(VSource.X, VResult.X, cPrefix + 'Z = 23. ������ � x ���������� X');
  CheckEquals(VSource.Y, VResult.Y, cPrefix + 'Z = 23. ������ � x ���������� Y');

  VSource := Point(1024, 768);
  VZoom := 10;
  VResult := LonLat2TilePos(FProjectionSet.Zooms[VZoom].TilePos2LonLat(VSource), VZoom);
  CheckEquals(VSource.X, VResult.X, cPrefix + 'Z = 10. ������ � x ���������� X');
  CheckEquals(VSource.Y, VResult.Y, cPrefix + 'Z = 10. ������ � x ���������� Y');

  VZoom := 11;
  VResult := LonLat2TilePos(FProjectionSet.Zooms[VZoom].TilePos2LonLat(VSource), VZoom);
  CheckEquals(VSource.X, VResult.X, cPrefix + 'Z = 10. ������ � x ���������� X');
  CheckEquals(VSource.Y, VResult.Y, cPrefix + 'Z = 10. ������ � x ���������� Y');

  VZoom := 14;
  VResult := LonLat2TilePos(FProjectionSet.Zooms[VZoom].TilePos2LonLat(VSource), VZoom);
  CheckEquals(VSource.X, VResult.X, cPrefix + 'Z = 14. ������ � x ���������� X');
  CheckEquals(VSource.Y, VResult.Y, cPrefix + 'Z = 14. ������ � x ���������� Y');

  VZoom := 20;
  VResult := LonLat2TilePos(FProjectionSet.Zooms[VZoom].TilePos2LonLat(VSource), VZoom);
  CheckEquals(VSource.X, VResult.X, cPrefix + 'Z = 20. ������ � x ���������� X');
  CheckEquals(VSource.Y, VResult.Y, cPrefix + 'Z = 20. ������ � x ���������� Y');

  VZoom := 22;
  VResult := LonLat2TilePos(FProjectionSet.Zooms[VZoom].TilePos2LonLat(VSource), VZoom);
  CheckEquals(VSource.X, VResult.X, cPrefix + 'Z = 23. ������ � x ���������� X');
  CheckEquals(VSource.Y, VResult.Y, cPrefix + 'Z = 23. ������ � x ���������� Y');
end;

procedure TestProjectionSet.Check_Relative2LonLat2Relative;
const
  cPrefix = 'Relative2LonLat2Relative' + ': ';
const
  cStep: Double = 0.00001;
var
  VSource, VTemp, VResult: TDoublePoint;
  VDelta: Double;
  VMaxDelta: Double;
  VProjectionType: IProjectionType;
begin
  VProjectionType := FProjectionSet.Zooms[0].ProjectionType; // zoom level doesn't matter

  VSource := DoublePoint(1/256, 0);
  VMaxDelta := 0;

  while VSource.Y <= 1 do begin
    VTemp := VProjectionType.Relative2LonLat(VSource);
    VResult := VProjectionType.LonLat2Relative(VTemp);

    VDelta := VSource.Y - VResult.Y;
    if Abs(VDelta) > Abs(VMaxDelta) then begin
      VMaxDelta := VDelta;
    end;

    Check(Abs(VDelta) < 1E-8, cPrefix + '������� ������� �����������');

    VSource.Y := VSource.Y + cStep;
  end;

  Check(Abs(VMaxDelta) < 2.3283064365E-10, cPrefix + '������� ������� ����������� ' + FloatToStr(VMaxDelta));
end;

procedure TestProjectionSet.Check_MonotonicRelative2LonLat;

  function PixelsAtZoom(const AZoom: Byte): Integer;
  begin
    with FProjectionSet.Zooms[AZoom].GetPixelRect do begin
      Result := Right - Left;
    end;
  end;

const
  cPrefix = 'MonotonicRelative2LonLat' + ': ';
var
  VDelta: Double;
  VSource: TDoublePoint;
  VTarget: TDoublePoint;
  VSourceLast: TDoublePoint;
  VTargetLast: TDoublePoint;
  VEpsilon: Double;
  VStart: Double;
  VFinish: Double;
  VProjectionType: IProjectionType;
begin
  VProjectionType := FProjectionSet.Zooms[0].ProjectionType; // zoom level doesn't matter

  VDelta := Abs(1 / PixelsAtZoom(22));
  VStart := 0;
  VFinish := VDelta * 100000;
  VSource := DoublePoint(0.5, VStart);
  VSourceLast := VSource;
  VTargetLast := VProjectionType.Relative2LonLat(VSourceLast);
  VSource.Y := VSource.Y + VDelta;

  while VSource.Y < VFinish do begin
    VTarget := VProjectionType.Relative2LonLat(VSource);
    VEpsilon := VTargetLast.Y - VTarget.Y;

    Check(
      VEpsilon > 0,
      cPrefix + '������� ������������� �� ��������� � ����� ' + FloatToStr(VSource.Y) + ' Eps=' + FloatToStr(VEpsilon)
    );

    VSourceLast := VSource;
    VTargetLast := VTarget;
    VSource.Y := VSource.Y + VDelta;
  end;
end;

initialization
  RegisterTest(TestProjectionSet.Suite);

end.
