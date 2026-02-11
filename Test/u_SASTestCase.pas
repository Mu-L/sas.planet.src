unit u_SASTestCase;

interface

uses
  TestFramework,
  Classes,
  t_GeoTypes;

type
  TSASTestCase = class(TTestCase)
  public
    procedure CheckStreamsEqual(S1, S2: TMemoryStream; msg: string = '');

    procedure CheckDoublePointsEquals(expected, actual: TDoublePoint; delta: Extended; msg: string = ''); overload; virtual;
    procedure CheckDoublePointsEquals(expected, actual: TDoublePoint; msg: string = ''); overload; virtual;
  end;

implementation

uses
  SysUtils,
  Math;

{ TSASTestCase }

procedure TSASTestCase.CheckStreamsEqual(S1, S2: TMemoryStream; msg: string);
begin
  if (S1 = nil) or
     (S2 = nil) or
     (S1.Size <> S2.Size) or
     not CompareMem(S1.Memory, S2.Memory, S1.Size)
  then begin
    Fail(msg, ReturnAddress);
  end;
end;

procedure TSASTestCase.CheckDoublePointsEquals(expected, actual: TDoublePoint; delta: Extended; msg: string);
var
  VExpectedEmpty: Boolean;
  VActualEmpty: Boolean;
begin
  VExpectedEmpty := IsNan(expected.x) or IsNan(expected.Y);
  VActualEmpty := IsNan(actual.x) or IsNan(actual.Y);
  FCheckCalled := True;

  if not VExpectedEmpty and not VActualEmpty then begin
    if Abs(expected.X - actual.X) > delta then begin
      FailNotEquals('X' + FloatToStr(expected.X), 'X' + FloatToStr(actual.X), msg, ReturnAddress);
    end;
    if Abs(expected.Y - actual.Y) > delta then begin
      FailNotEquals('Y' + FloatToStr(expected.Y), 'Y' + FloatToStr(actual.Y), msg, ReturnAddress);
    end;
  end else begin
    if VExpectedEmpty and not VActualEmpty then begin
      Fail('Expected empty point', ReturnAddress);
    end else
    if not VExpectedEmpty and VActualEmpty then begin
      Fail('Not expected empty point but get', ReturnAddress);
    end
  end;
end;

procedure TSASTestCase.CheckDoublePointsEquals(expected, actual: TDoublePoint; msg: string);
begin
  CheckDoublePointsEquals(expected, actual, 0, msg);
end;

end.
