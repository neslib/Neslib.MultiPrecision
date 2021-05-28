unit MultiPrecision.DoubleDouble.Tests;

interface

uses
  UnitTest,
  Neslib.MultiPrecision;

type
  TTestDoubleDouble = class(TUnitTest)
  private
    procedure CheckEquals(const AExpected: String;
      const AActual: DoubleDouble); overload;
  published
    procedure TestInit;
    procedure TestToString;
    procedure TestConstants;

    procedure TestEqual;
    procedure TestNotEqual;
    procedure TestLessThan;
    procedure TestLessThanOrEqual;
    procedure TestGreaterThan;
    procedure TestGreaterThanOrEqual;

    procedure TestAddDD_DD;
    procedure TestAddD_D;
    procedure TestAddDD_D;
    procedure TestAddD_DD;

    procedure TestSubtractDD_DD;
    procedure TestSubtractD_D;
    procedure TestSubtractDD_D;
    procedure TestSubtractD_DD;

    procedure TestMultiplyDD_DD;
    procedure TestMultiplyD_D;
    procedure TestMultiplyDD_D;
    procedure TestMultiplyD_DD;

    procedure TestDivideDD_DD;
    procedure TestDivideD_D;
    procedure TestDivideDD_D;
    procedure TestDivideD_DD;
    procedure TestRem;
    procedure TestDivRem;
    procedure TestFMod;

    procedure TestNeg;
    procedure TestInv;

    procedure TestSqrt;

    procedure TestSqrDD;
    procedure TestSqrD;

    procedure TestTrunc;
    procedure TestFloor;
    procedure TestCeil;
    procedure TestRound;
    procedure TestAbs;
    procedure TestPowerInt;
    procedure TestPower;
    procedure TestNRoot;
    procedure TestLdexp;
    procedure TestExp;
    procedure TestLn;
    procedure TestLog10;

    procedure TestSin;
    procedure TestCos;
    procedure TestSinCos;
    procedure TestTan;

    procedure TestArcSin;
    procedure TestArcCos;
    procedure TestArcTan;
    procedure TestArcTan2;

    procedure TestSinh;
    procedure TestCosh;
    procedure TestSinCosh;
    procedure TestTanh;

    procedure TestArcSinh;
    procedure TestArcCosh;
    procedure TestArcTanh;

    procedure TestIssue3;
    procedure TestIssue4;
    procedure TestIssue5;
    procedure TestIssue6;
  end;

implementation

uses
  System.Math,
  System.SysUtils;

{ TTestDoubleDouble }

procedure TTestDoubleDouble.CheckEquals(const AExpected: String;
  const AActual: DoubleDouble);
var
  Actual: String;
begin
  Actual := AActual.ToString(USFormatSettings, TMPFloatFormat.Fixed);
  CheckEquals(AExpected, Actual);
end;

procedure TTestDoubleDouble.TestAbs;
var
  A, B: DoubleDouble;
begin
  A := Abs(DoubleDouble.Pi);
  CheckEquals('3.1415926535897932384626433832795', A);

  B := -DoubleDouble.Pi;
  CheckEquals('-3.1415926535897932384626433832795', B);

  A := DoubleDouble.Zero;
  A := Abs(B);
  CheckEquals('3.1415926535897932384626433832795', A);
end;

procedure TTestDoubleDouble.TestAddD_D;
var
  A: DoubleDouble;
  D1, D2: Double;
begin
  D1 := 1.1;
  D2 := Pi;
  A := Add(D1, D2);
  CheckEquals('4.2415926535897932048158054385567', A);
end;

procedure TTestDoubleDouble.TestAddD_DD;
var
  A, B: DoubleDouble;
  D: Double;
begin
  D := 1.1;
  A := 1.1 + DoubleDouble.Pi;
  B := D + DoubleDouble.Pi;

  CheckEquals('4.2415926535897933272804853532921', A);
  CheckEquals('4.2415926535897933272804853532921', B);
end;

procedure TTestDoubleDouble.TestAddDD_D;
var
  A, B: DoubleDouble;
  D: Double;
begin
  D := 1.1;
  A := DoubleDouble.Pi + 1.1;
  B := DoubleDouble.Pi + D;

  CheckEquals('4.2415926535897933272804853532921', A);
  CheckEquals('4.2415926535897933272804853532921', B);
end;

procedure TTestDoubleDouble.TestAddDD_DD;
var
  A: DoubleDouble;
begin
  A := DoubleDouble.Pi + DoubleDouble.E;
  {$IFDEF MP_ACCURATE}
  CheckEquals('5.8598744820488384738229308546322', A);
  {$ELSE}
  CheckEquals('5.8598744820488384738229308546321', A);
  {$ENDIF}
end;

procedure TTestDoubleDouble.TestArcCos;
var
  A: DoubleDouble;
begin
  A := '1.1'; CheckEquals('NAN', ArcCos(A));
  A := '1.0'; CheckEquals('0.0000000000000000000000000000000', ArcCos(A));
  A := '-1.0'; CheckEquals('3.1415926535897932384626433832795', ArcCos(A));
  {$IF Defined(IOS) and (not Defined(MP_ACCURATE))}
  A := '0.5'; CheckEquals('1.0471975511965977461542144610931', ArcCos(A));
  {$ELSE}
  A := '0.5'; CheckEquals('1.0471975511965977461542144610932', ArcCos(A));
  {$ENDIF}
end;

procedure TTestDoubleDouble.TestArcCosh;
var
  A: DoubleDouble;
begin
  A := '0.5'; CheckEquals('NAN', ArcCosh(A));
  A := '1.5'; CheckEquals('0.9624236501192068949955178268487', ArcCosh(A));
end;

procedure TTestDoubleDouble.TestArcSin;
var
  A: DoubleDouble;
begin
  A := '1.1'; CheckEquals('NAN', ArcSin(A));
  A := '1.0'; CheckEquals('1.5707963267948966192313216916398', ArcSin(A));
  A := '-1.0'; CheckEquals('-1.5707963267948966192313216916398', ArcSin(A));
  A := '0.5'; CheckEquals('0.5235987755982988730771072305466', ArcSin(A));
end;

procedure TTestDoubleDouble.TestArcSinh;
var
  A: DoubleDouble;
begin
  A := '0.5'; CheckEquals('0.4812118250596034474977589134244', ArcSinh(A));
end;

procedure TTestDoubleDouble.TestArcTan;
var
  A: DoubleDouble;
begin
  A := '0.5'; CheckEquals('0.4636476090008061162142562314612', ArcTan(A));
end;

procedure TTestDoubleDouble.TestArcTan2;
var
  P, N: DoubleDouble;
begin
  P := '0.5';
  N := '-0.5';
  CheckEquals('NAN', ArcTan2(DoubleDouble.Zero, DoubleDouble.Zero));
  CheckEquals('1.5707963267948966192313216916398', ArcTan2(P, DoubleDouble.Zero));
  CheckEquals('-1.5707963267948966192313216916398', ArcTan2(N, DoubleDouble.Zero));
  CheckEquals('0.0000000000000000000000000000000', ArcTan2(DoubleDouble.Zero, P));
  CheckEquals('3.1415926535897932384626433832795', ArcTan2(DoubleDouble.Zero, N));
  CheckEquals('0.7853981633974483096156608458199', ArcTan2(P, P));
  CheckEquals('-2.3561944901923449288469825374596', ArcTan2(N, N));
  CheckEquals('2.3561944901923449288469825374596', ArcTan2(P, N));
  CheckEquals('-0.7853981633974483096156608458199', ArcTan2(N, P));

  P := '0.4';
  N := '-0.1';
  CheckEquals('-0.2449786631268641541720824812113', ArcTan2(N, P));
end;

procedure TTestDoubleDouble.TestArcTanh;
var
  A: DoubleDouble;
begin
  A := '1.5'; CheckEquals('NAN', ArcTanh(A));
  A := '0.5'; CheckEquals('0.5493061443340548456976226184613', ArcTanh(A));
end;

procedure TTestDoubleDouble.TestCeil;
begin
  CheckEquals('-3.0000000000000000000000000000000', Ceil(DoubleDouble('-3.9')));
  CheckEquals('-3.0000000000000000000000000000000', Ceil(DoubleDouble('-3.5')));
  CheckEquals('-3.0000000000000000000000000000000', Ceil(DoubleDouble('-3.1')));
  CheckEquals('-3.0000000000000000000000000000000', Ceil(DoubleDouble('-3.0')));
  CheckEquals('0.0000000000000000000000000000000', Ceil(DoubleDouble('0.0')));
  CheckEquals('2.0000000000000000000000000000000', Ceil(DoubleDouble('2.0')));
  CheckEquals('3.0000000000000000000000000000000', Ceil(DoubleDouble('2.1')));
  CheckEquals('3.0000000000000000000000000000000', Ceil(DoubleDouble('2.5')));
  CheckEquals('3.0000000000000000000000000000000', Ceil(DoubleDouble('2.9')));
end;

procedure TTestDoubleDouble.TestConstants;
begin
  CheckEquals('3.1415926535897932384626433832795', DoubleDouble.Pi);
  CheckEquals('6.2831853071795864769252867665590', DoubleDouble.PiTimes2);
  CheckEquals('1.5707963267948966192313216916398', DoubleDouble.PiOver2);
  CheckEquals('0.7853981633974483096156608458199', DoubleDouble.PiOver4);
  CheckEquals('2.3561944901923449288469825374596', DoubleDouble.PiTimes3Over4);
  CheckEquals('0.0174532925199432957692369076849', DoubleDouble.PiOver180);
  CheckEquals('57.2957795130823208767981548141053', DoubleDouble._180OverPi);
  CheckEquals('2.7182818284590452353602874713527', DoubleDouble.E);
  CheckEquals('0.6931471805599453094172321214582', DoubleDouble.Log2);
  CheckEquals('2.3025850929940456840179914546844', DoubleDouble.Log10);
  CheckEquals('0.0000000000000000000000000000000', DoubleDouble.Zero);
  CheckEquals('1.0000000000000000000000000000000', DoubleDouble.One);
  CheckEquals('NAN', DoubleDouble.NaN);
  CheckEquals('INF', DoubleDouble.PositiveInfinity);
  CheckEquals('-INF', DoubleDouble.NegativeInfinity);
end;

procedure TTestDoubleDouble.TestCos;
var
  A: DoubleDouble;
begin
  { These test all possible code paths }

  A := Cos(DoubleDouble.Zero);
  CheckEquals('1.0000000000000000000000000000000', A);

  A := '1.0'; A := Cos(A);
  CheckEquals('0.5403023058681397174009366074430', A);

  A := '2.0'; A := Cos(A);
  CheckEquals('-0.4161468365471423869975682295008', A);

  A := '3.0'; A := Cos(A);
  CheckEquals('-0.9899924966004454572715727947313', A);

  A := '4.0'; A := Cos(A);
  {$IFDEF MP_ACCURATE}
  CheckEquals('-0.6536436208636119146391681830978', A);
  {$ELSE}
  CheckEquals('-0.6536436208636119146391681830977', A);
  {$ENDIF}

  A := '5.0'; A := Cos(A);
  {$IFDEF MP_ACCURATE}
  CheckEquals('0.2836621854632262644666391715136', A);
  {$ELSE}
  CheckEquals('0.2836621854632262644666391715135', A);
  {$ENDIF}

  A := '6.0'; A := Cos(A);
  CheckEquals('0.9601702866503660205456522979229', A);

  A := '7.0'; A := Cos(A);
  CheckEquals('0.7539022543433046381411975217192', A);

  A := '-3.0'; A := Cos(A);
  CheckEquals('-0.9899924966004454572715727947313', A);

  A := '0.01'; A := Cos(A);
  CheckEquals('0.9999500004166652777802579337522', A);

  A := '1.571'; A := Cos(A);
  CheckEquals('-0.0002036732036952258325442870877', A);

  A := '3.142'; A := Cos(A);
  CheckEquals('-0.9999999170344521930460925427757', A);

  A := '4.713'; A := Cos(A);
  CheckEquals('0.0006110195772899596612894211596', A);
end;

procedure TTestDoubleDouble.TestCosh;
var
  A: DoubleDouble;
begin
  A := '0.0'; A := Cosh(A);
  CheckEquals('1.0000000000000000000000000000000', A);

  A := '0.5'; A := Cosh(A);
  CheckEquals('1.1276259652063807852262251614027', A);

  A := '0.01'; A := Cosh(A);
  CheckEquals('1.0000500004166680555580357170414', A);
end;

procedure TTestDoubleDouble.TestDivideD_D;
var
  A: DoubleDouble;
  D1, D2: Double;
begin
  D1 := 1.1;
  D2 := Pi;
  A := Divide(D1, D2);
  CheckEquals('0.3501408748021697806122344036592', A);
end;

procedure TTestDoubleDouble.TestDivideD_DD;
var
  A, B: DoubleDouble;
  D: Double;
begin
  D := 1.3;
  A := 1.3 / DoubleDouble.Pi;
  B := D / DoubleDouble.Pi;

  CheckEquals('0.4138028520389278871348963690508', A);
  CheckEquals('0.4138028520389278871348963690508', B);
end;

procedure TTestDoubleDouble.TestDivideDD_D;
var
  A, B: DoubleDouble;
  D: Double;
begin
  D := 1.2;
  A := DoubleDouble.Pi / 1.2;
  B := DoubleDouble.Pi / D;

  CheckEquals('2.6179938779914944622707722085283', A);
  CheckEquals('2.6179938779914944622707722085283', B);
end;

procedure TTestDoubleDouble.TestDivideDD_DD;
var
  A: DoubleDouble;
begin
  A := DoubleDouble.Pi / DoubleDouble.E;
  CheckEquals('1.1557273497909217179100931833127', A);
end;

procedure TTestDoubleDouble.TestDivRem;
var
  Res, Remainder: DoubleDouble;
begin
  Res := DivRem(DoubleDouble.Pi, DoubleDouble.Log2, Remainder);
  CheckEquals('5.0000000000000000000000000000000', Res);
  CheckEquals('-0.3241432492099333086235172240114', Remainder);

  DivRem(DoubleDouble.Pi, DoubleDouble.Log2, Remainder, Res);
  CheckEquals('5.0000000000000000000000000000000', Res);
  CheckEquals('-0.3241432492099333086235172240114', Remainder);
end;

procedure TTestDoubleDouble.TestEqual;
var
  A, B, C: DoubleDouble;
begin
  A := '3.1415926535897932384626433832795';
  B := '3.1415926535897932384626433832795';
  C := '3.1415926535897932384626433832796';
  CheckTrue(A = B);
  CheckFalse(A = C);
  CheckTrue(A.Equals(B));
  CheckFalse(A.Equals(C));

  CheckFalse(A = Pi);
  CheckFalse(Pi = A);
  CheckFalse(A.Equals(Pi));

  A.Init(Pi);
  CheckTrue(A = Pi);
  CheckTrue(Pi = A);
  CheckTrue(A.Equals(Pi));
end;

procedure TTestDoubleDouble.TestExp;
var
  A: DoubleDouble;
begin
  A := Exp(DoubleDouble.Pi);
  CheckEquals('23.1406926327792690057290863679493', A);
end;

procedure TTestDoubleDouble.TestFloor;
begin
  CheckEquals('-4.0000000000000000000000000000000', Floor(DoubleDouble('-3.9')));
  CheckEquals('-4.0000000000000000000000000000000', Floor(DoubleDouble('-3.5')));
  CheckEquals('-4.0000000000000000000000000000000', Floor(DoubleDouble('-3.1')));
  CheckEquals('-3.0000000000000000000000000000000', Floor(DoubleDouble('-3.0')));
  CheckEquals('0.0000000000000000000000000000000', Floor(DoubleDouble('0.0')));
  CheckEquals('2.0000000000000000000000000000000', Floor(DoubleDouble('2.0')));
  CheckEquals('2.0000000000000000000000000000000', Floor(DoubleDouble('2.1')));
  CheckEquals('2.0000000000000000000000000000000', Floor(DoubleDouble('2.5')));
  CheckEquals('2.0000000000000000000000000000000', Floor(DoubleDouble('2.9')));
end;

procedure TTestDoubleDouble.TestFMod;
var
  A: DoubleDouble;
begin
  A := FMod(DoubleDouble.PiOver2, DoubleDouble.E);
  CheckEquals('1.5707963267948966192313216916398', A);
end;

procedure TTestDoubleDouble.TestGreaterThan;
var
  A, B, C: DoubleDouble;
begin
  A := '3.1415926535897932384626433832795';
  B := '3.1415926535897932384626433832795';
  C := '3.1415926535897932384626433832796';
  CheckFalse(A > B);
  CheckFalse(A > C);
  CheckTrue(C > A);

  CheckTrue(A > Pi);
  CheckFalse(Pi > A);

  CheckTrue(A > 3.0);
  CheckFalse(3.0 > A);

  A.Init(Pi);
  CheckFalse(A > Pi);
  CheckFalse(Pi > A);
end;

procedure TTestDoubleDouble.TestGreaterThanOrEqual;
var
  A, B, C: DoubleDouble;
begin
  A := '3.1415926535897932384626433832795';
  B := '3.1415926535897932384626433832795';
  C := '3.1415926535897932384626433832796';
  CheckTrue(A >= B);
  CheckFalse(A >= C);
  CheckTrue(C >= A);

  CheckTrue(A >= Pi);
  CheckFalse(Pi >= A);

  CheckTrue(A >= 3.0);
  CheckFalse(3.0 >= A);

  A.Init(Pi);
  CheckTrue(A >= Pi);
  CheckTrue(Pi >= A);
end;

procedure TTestDoubleDouble.TestInit;
var
  A: DoubleDouble;
begin
  A.Init;
  CheckEquals(0, A.X[0], 0);
  CheckEquals(0, A.X[1], 0);
  CheckEquals('0.0000000000000000000000000000000', A);

  A.Init(1.5);
  CheckEquals(1.5, A.X[0], 0);
  CheckEquals(0, A.X[1], 0);
  CheckEquals('1.5000000000000000000000000000000', A);

  A.Init(Pi, 1.224646799147353207e-16);
  CheckEquals(Pi, A.X[0], 0);
  CheckEquals(1.224646799147353207e-16, A.X[1], 0);
  CheckEquals('3.1415926535897932384626433832795', A);

  A.Init('2.7182818284590452353602874713527', USFormatSettings);
  CheckEquals(DoubleDouble.E.X[0], A.X[0], 0);
  CheckEquals(DoubleDouble.E.X[1], A.X[1], 0);
  CheckEquals('2.7182818284590452353602874713527', A);
end;

procedure TTestDoubleDouble.TestInv;
var
  A: DoubleDouble;
begin
  A := Inverse(DoubleDouble.Pi);
  CheckEquals('0.3183098861837906715377675267450', A);
end;

procedure TTestDoubleDouble.TestIssue3;
var
  X, Y, Z: DoubleDouble;
begin
  X := '-3.5';
  Y := '1.0E-1';
  Z := Tanh(Y / X);
  CheckEquals('-0.0285636565708280378650165308100', Z);
end;

procedure TTestDoubleDouble.TestIssue4;
var
  A: DoubleDouble;
begin
  A := '1E0'; { Should not enter eternal loop }
  CheckEquals('1.0000000000000000000000000000000', A);
end;

procedure TTestDoubleDouble.TestIssue5;
var
  X, Y, Z: DoubleDouble;
begin
  X := '-3.5';
  Y := '-5.08888E+1';
  Z := Y / X;
  CheckEquals('14.5396571428571428571428571428571', Z);
end;

procedure TTestDoubleDouble.TestIssue6;
var
  A: DoubleDouble;
begin
  { These should raise EConvertError exceptions }
  ShouldRaise(EConvertError,
    procedure
    begin
      A := '- 0';
    end);

  ShouldRaise(EConvertError,
    procedure
    begin
      A := '+ 1';
    end);

  ShouldRaise(EConvertError,
    procedure
    begin
      A := '- 2';
    end);

  ShouldRaise(EConvertError,
    procedure
    begin
      A := '1E - 1';
    end);

  ShouldRaise(EConvertError,
    procedure
    begin
      A := '1E- 1';
    end);

  ShouldRaise(EConvertError,
    procedure
    begin
      A := '1E -1';
    end);

  { These should not raise any exceptions }
  A := ' 1';
  A := '1 ';
  A := ' 1 ';
end;

procedure TTestDoubleDouble.TestLdexp;
var
  A: DoubleDouble;
begin
  A := Ldexp(DoubleDouble.Pi, 4);
  CheckEquals('50.2654824574366918154022941324722', A);
end;

procedure TTestDoubleDouble.TestLessThan;
var
  A, B, C: DoubleDouble;
begin
  A := '3.1415926535897932384626433832795';
  B := '3.1415926535897932384626433832795';
  C := '3.1415926535897932384626433832796';
  CheckFalse(A < B);
  CheckTrue(A < C);

  CheckFalse(A < Pi);
  CheckTrue(Pi < A);

  CheckFalse(A < 3.0);
  CheckTrue(3.0 < A);

  A.Init(Pi);
  CheckFalse(A < Pi);
  CheckFalse(Pi < A);
end;

procedure TTestDoubleDouble.TestLessThanOrEqual;
var
  A, B, C: DoubleDouble;
begin
  A := '3.1415926535897932384626433832795';
  B := '3.1415926535897932384626433832795';
  C := '3.1415926535897932384626433832796';
  CheckTrue(A <= B);
  CheckTrue(A <= C);
  CheckFalse(C <= A);

  CheckFalse(A <= Pi);
  CheckTrue(Pi <= A);

  CheckFalse(A <= 3.0);
  CheckTrue(3.0 <= A);

  A.Init(Pi);
  CheckTrue(A <= Pi);
  CheckTrue(Pi <= A);
end;

procedure TTestDoubleDouble.TestLn;
var
  A: DoubleDouble;
begin
  A := Ln(DoubleDouble.Pi);
  CheckEquals('1.1447298858494001741434273513530', A);
end;

procedure TTestDoubleDouble.TestLog10;
var
  A: DoubleDouble;
begin
  A := Log10(DoubleDouble.Pi);
  CheckEquals('0.4971498726941338543512682882909', A);
end;

procedure TTestDoubleDouble.TestMultiplyD_D;
var
  A: DoubleDouble;
  D1, D2: Double;
begin
  D1 := 1.1;
  D2 := Pi;
  A := Multiply(D1, D2);
  CheckEquals('3.4557519189487727066272396560891', A);
end;

procedure TTestDoubleDouble.TestMultiplyD_DD;
var
  A, B: DoubleDouble;
  D: Double;
begin
  D := 1.3;
  A := 1.3 * DoubleDouble.Pi;
  B := D * DoubleDouble.Pi;

  CheckEquals('4.0840704496667313495161763186086', A);
  CheckEquals('4.0840704496667313495161763186086', B);
end;

procedure TTestDoubleDouble.TestMultiplyDD_D;
var
  A, B: DoubleDouble;
  D: Double;
begin
  D := 1.2;
  A := DoubleDouble.Pi * 1.2;
  B := DoubleDouble.Pi * D;

  CheckEquals('3.7699111843077517466404321395901', A);
  CheckEquals('3.7699111843077517466404321395901', B);
end;

procedure TTestDoubleDouble.TestMultiplyDD_DD;
var
  A: DoubleDouble;
begin
  A := DoubleDouble.Pi * DoubleDouble.E;
  CheckEquals('8.5397342226735670654635508695467', A);
end;

procedure TTestDoubleDouble.TestNeg;
var
  A: DoubleDouble;
begin
  A := -DoubleDouble.Pi;
  CheckEquals('-3.1415926535897932384626433832795', A);
end;

procedure TTestDoubleDouble.TestNotEqual;
var
  A, B, C: DoubleDouble;
begin
  A := '3.1415926535897932384626433832795';
  B := '3.1415926535897932384626433832795';
  C := '3.1415926535897932384626433832796';
  CheckFalse(A <> B);
  CheckTrue(A <> C);

  CheckTrue(A <> Pi);
  CheckTrue(Pi <> A);

  A.Init(Pi);
  CheckFalse(A <> Pi);
  CheckFalse(Pi <> A);
end;

procedure TTestDoubleDouble.TestNRoot;
var
  A: DoubleDouble;
begin
  A := NRoot(DoubleDouble.Pi, 3);
  CheckEquals('1.4645918875615232630201425272638', A);
end;

procedure TTestDoubleDouble.TestPower;
var
  A: DoubleDouble;
begin
  A := Power(DoubleDouble.Pi, DoubleDouble.Log2);
  CheckEquals('2.2110472960154989879411702297713', A);
end;

procedure TTestDoubleDouble.TestPowerInt;
var
  A: DoubleDouble;
begin
  A := IntPower(DoubleDouble.Pi, 4);
  CheckEquals('97.4090910340024372364403326887042', A);
end;

procedure TTestDoubleDouble.TestRem;
var
  A: DoubleDouble;
begin
  A := Rem(DoubleDouble.PiOver2, DoubleDouble.E);
  CheckEquals('-1.1474855016641486161289657797129', A);
end;

procedure TTestDoubleDouble.TestRound;
begin
  CheckEquals('-4.0000000000000000000000000000000', Round(DoubleDouble('-3.9')));
  CheckEquals('-3.0000000000000000000000000000000', Round(DoubleDouble('-3.5')));
  CheckEquals('-3.0000000000000000000000000000000', Round(DoubleDouble('-3.1')));
  CheckEquals('-3.0000000000000000000000000000000', Round(DoubleDouble('-3.0')));
  CheckEquals('0.0000000000000000000000000000000', Round(DoubleDouble('0.0')));
  CheckEquals('2.0000000000000000000000000000000', Round(DoubleDouble('2.0')));
  CheckEquals('2.0000000000000000000000000000000', Round(DoubleDouble('2.1')));
  CheckEquals('3.0000000000000000000000000000000', Round(DoubleDouble('2.5')));
  CheckEquals('3.0000000000000000000000000000000', Round(DoubleDouble('2.9')));
end;

procedure TTestDoubleDouble.TestSinCos;
var
  A, S, C: DoubleDouble;
begin
  { These test all possible code paths }

  SinCos(DoubleDouble.Zero, S, C);
  CheckEquals('0.0000000000000000000000000000000', S);
  CheckEquals('1.0000000000000000000000000000000', C);

  A := '1.0'; SinCos(A, S, C);
  CheckEquals('0.8414709848078965066525023216303', S);
  CheckEquals('0.5403023058681397174009366074430', C);

  A := '2.0'; SinCos(A, S, C);
  CheckEquals('0.9092974268256816953960198659117', S);
  CheckEquals('-0.4161468365471423869975682295008', C);

  A := '3.0'; SinCos(A, S, C);
  CheckEquals('0.1411200080598672221007448028081', S);
  CheckEquals('-0.9899924966004454572715727947313', C);

  A := '4.0'; SinCos(A, S, C);
  CheckEquals('-0.7568024953079282513726390945118', S);
  {$IFDEF MP_ACCURATE}
  CheckEquals('-0.6536436208636119146391681830978', C);
  {$ELSE}
  CheckEquals('-0.6536436208636119146391681830977', C);
  {$ENDIF}

  A := '5.0'; SinCos(A, S, C);
  CheckEquals('-0.9589242746631384688931544061560', S);
  {$IFDEF MP_ACCURATE}
  CheckEquals('0.2836621854632262644666391715136', C);
  {$ELSE}
  CheckEquals('0.2836621854632262644666391715135', C);
  {$ENDIF}

  A := '6.0'; SinCos(A, S, C);
  CheckEquals('-0.2794154981989258728115554466119', S);
  CheckEquals('0.9601702866503660205456522979229', C);

  A := '7.0'; SinCos(A, S, C);
  CheckEquals('0.6569865987187890903969990915936', S);
  CheckEquals('0.7539022543433046381411975217192', C);

  A := '-3.0'; SinCos(A, S, C);
  CheckEquals('-0.1411200080598672221007448028081', S);
  CheckEquals('-0.9899924966004454572715727947313', C);

  A := '0.01'; SinCos(A, S, C);
  CheckEquals('0.0099998333341666646825424382691', S);
  CheckEquals('0.9999500004166652777802579337522', C);

  A := '1.571'; SinCos(A, S, C);
  {$IFDEF MP_ACCURATE}
  CheckEquals('0.9999999792586128331589523332947', S);
  {$ELSE}
  CheckEquals('0.9999999792586128331589523332946', S);
  {$ENDIF}
  CheckEquals('-0.0002036732036952258325442870877', C);

  A := '3.142'; SinCos(A, S, C);
  CheckEquals('-0.0004073463989415221183814547127', S);
  CheckEquals('-0.9999999170344521930460925427757', C);

  A := '4.713'; SinCos(A, S, C);
  CheckEquals('-0.9999998133275206608922345650285', S);
  CheckEquals('0.0006110195772899596612894211596', C);
end;

procedure TTestDoubleDouble.TestSinCosh;
var
  A, S, C: DoubleDouble;
begin
  A := '0.01'; SinCosh(A, S, C);
  CheckEquals('0.0100001666675000019841297398614', S);
  CheckEquals('1.0000500004166680555580357170414', C);

  A := '0.5'; SinCosh(A, S, C);
  CheckEquals('0.5210953054937473616224256264115', S);
  CheckEquals('1.1276259652063807852262251614027', C);
end;

procedure TTestDoubleDouble.TestSinh;
var
  A: DoubleDouble;
begin
  A := '0.0'; A := Sinh(A);
  CheckEquals('0.0000000000000000000000000000000', A);

  A := '0.5'; A := Sinh(A);
  CheckEquals('0.5210953054937473616224256264115', A);

  A := '0.01'; A := Sinh(A);
  CheckEquals('0.0100001666675000019841297398614', A);
end;

procedure TTestDoubleDouble.TestSin;
var
  A: DoubleDouble;
begin
  { These test all possible code paths }

  A := Sin(DoubleDouble.Zero);
  CheckEquals('0.0000000000000000000000000000000', A);

  A := Sin(DoubleDouble('1.0'));
  CheckEquals('0.8414709848078965066525023216303', A);

  A := Sin(DoubleDouble('2.0'));
  CheckEquals('0.9092974268256816953960198659117', A);

  A := Sin(DoubleDouble('3.0'));
  CheckEquals('0.1411200080598672221007448028081', A);

  A := Sin(DoubleDouble('4.0'));
  CheckEquals('-0.7568024953079282513726390945118', A);

  A := Sin(DoubleDouble('5.0'));
  CheckEquals('-0.9589242746631384688931544061560', A);

  A := Sin(DoubleDouble('6.0'));
  CheckEquals('-0.2794154981989258728115554466119', A);

  A := Sin(DoubleDouble('7.0'));
  CheckEquals('0.6569865987187890903969990915936', A);

  A := Sin(DoubleDouble('-3.0'));
  CheckEquals('-0.1411200080598672221007448028081', A);

  A := Sin(DoubleDouble('0.01'));
  CheckEquals('0.0099998333341666646825424382691', A);

  A := Sin(DoubleDouble('1.571'));
  CheckEquals('0.9999999792586128331589523332947', A);

  A := Sin(DoubleDouble('3.142'));
  CheckEquals('-0.0004073463989415221183814547127', A);

  A := Sin(DoubleDouble('4.713'));
  CheckEquals('-0.9999998133275206608922345650285', A);
end;

procedure TTestDoubleDouble.TestSqrD;
var
  A: DoubleDouble;
  D: Double;
begin
  D := Pi;
  Sqr(D, A);
  CheckEquals('9.8696044010893578493662135111602', A);
end;

procedure TTestDoubleDouble.TestSqrDD;
var
  A: DoubleDouble;
begin
  A := Sqr(DoubleDouble.Pi);
  CheckEquals('9.8696044010893586188344909998761', A);
end;

procedure TTestDoubleDouble.TestSqrt;
var
  A: DoubleDouble;
begin
  A := Sqrt(DoubleDouble.Pi);
  CheckEquals('1.7724538509055160272981674833411', A);
end;

procedure TTestDoubleDouble.TestSubtractD_D;
var
  A: DoubleDouble;
  D1, D2: Double;
begin
  D1 := 1.1;
  D2 := Pi;
  A := Subtract(D1, D2);
  CheckEquals('-2.0415926535897930271801214985317', A);
end;

procedure TTestDoubleDouble.TestSubtractD_DD;
var
  A, B: DoubleDouble;
  D: Double;
begin
  D := 1.1;
  A := 1.1 - DoubleDouble.Pi;
  B := D - DoubleDouble.Pi;

  CheckEquals('-2.0415926535897931496448014132670', A);
  CheckEquals('-2.0415926535897931496448014132670', B);
end;

procedure TTestDoubleDouble.TestSubtractDD_D;
var
  A, B: DoubleDouble;
  D: Double;
begin
  D := 1.1;
  A := DoubleDouble.Pi - 1.1;
  B := DoubleDouble.Pi - D;

  CheckEquals('2.0415926535897931496448014132670', A);
  CheckEquals('2.0415926535897931496448014132670', B);
end;

procedure TTestDoubleDouble.TestSubtractDD_DD;
var
  A: DoubleDouble;
begin
  A := DoubleDouble.Pi - DoubleDouble.E;
  CheckEquals('0.4233108251307480031023559119268', A);
end;

procedure TTestDoubleDouble.TestTan;
var
  A: DoubleDouble;
begin
  A := Tan(DoubleDouble.Zero);
  CheckEquals('0.0000000000000000000000000000000', A);

  A := Tan(DoubleDouble.PiOver2);
  CheckEquals('NAN', A);

  A := '1.0'; A := Tan(A);
  CheckEquals('1.5574077246549022305069748074584', A);
end;

procedure TTestDoubleDouble.TestTanh;
var
  A: DoubleDouble;
begin
  A := '0.0'; A := Tanh(A);
  CheckEquals('0.0000000000000000000000000000000', A);

  A := '0.5'; A := Tanh(A);
  CheckEquals('0.4621171572600097585023184836437', A);

  A := '0.01'; A := Tanh(A);
  CheckEquals('0.0099996666799994603393289197088', A);
end;

procedure TTestDoubleDouble.TestToString;
var
  A: DoubleDouble;
  FS: TFormatSettings;
begin
  FS := TFormatSettings.Create('nl-NL');

  A := DoubleDouble.Zero;
  CheckEquals('0.0000000000000000000000000000000E+00', A.ToString(USFormatSettings));
  CheckEquals('0.0000000000000000000000000000000', A.ToString(USFormatSettings, TMPFloatFormat.Fixed));
  CheckEquals('0.00000E+00', A.ToString(USFormatSettings, TMPFloatFormat.Scientific, 5));
  CheckEquals('0.00000', A.ToString(USFormatSettings, TMPFloatFormat.Fixed, 5));
  CheckEquals('0,00000E+00', A.ToString(FS, TMPFloatFormat.Scientific, 5));
  CheckEquals('0,00000', A.ToString(FS, TMPFloatFormat.Fixed, 5));

  A := DoubleDouble.Pi / 1e3;
  CheckEquals('3.1415926535897932384626433832795E-03', A.ToString(USFormatSettings));
  CheckEquals('0.0031415926535897932384626433833', A.ToString(USFormatSettings, TMPFloatFormat.Fixed));
  CheckEquals('3.14159E-03', A.ToString(USFormatSettings, TMPFloatFormat.Scientific, 5));
  CheckEquals('0.00314', A.ToString(USFormatSettings, TMPFloatFormat.Fixed, 5));

  A := DoubleDouble.E * 1e8;
  CheckEquals('2.7182818284590452353602874713527E+08', A.ToString(USFormatSettings));
  CheckEquals('271828182.8459045235360287471352664625474', A.ToString(USFormatSettings, TMPFloatFormat.Fixed));
  CheckEquals('2.71828E+08', A.ToString(USFormatSettings, TMPFloatFormat.Scientific, 5));
  CheckEquals('271828182.84590', A.ToString(USFormatSettings, TMPFloatFormat.Fixed, 5));

  A := DoubleDouble.NaN;
  CheckEquals('NAN', A.ToString);
  CheckEquals('NAN', A.ToString(TMPFloatFormat.Fixed));
  CheckEquals('NAN', A.ToString(TMPFloatFormat.Scientific, 5));
  CheckEquals('NAN', A.ToString(TMPFloatFormat.Fixed, 5));

  A := DoubleDouble.PositiveInfinity;
  CheckEquals('INF', A.ToString);
  CheckEquals('INF', A.ToString(TMPFloatFormat.Fixed));
  CheckEquals('INF', A.ToString(TMPFloatFormat.Scientific, 5));
  CheckEquals('INF', A.ToString(TMPFloatFormat.Fixed, 5));

  A := DoubleDouble.NegativeInfinity;
  CheckEquals('-INF', A.ToString);
  CheckEquals('-INF', A.ToString(TMPFloatFormat.Fixed));
  CheckEquals('-INF', A.ToString(TMPFloatFormat.Scientific, 5));
  CheckEquals('-INF', A.ToString(TMPFloatFormat.Fixed, 5));
end;

procedure TTestDoubleDouble.TestTrunc;
begin
  CheckEquals('-3.0000000000000000000000000000000', Trunc(DoubleDouble('-3.9')));
  CheckEquals('-3.0000000000000000000000000000000', Trunc(DoubleDouble('-3.5')));
  CheckEquals('-3.0000000000000000000000000000000', Trunc(DoubleDouble('-3.1')));
  CheckEquals('-3.0000000000000000000000000000000', Trunc(DoubleDouble('-3.0')));
  CheckEquals('0.0000000000000000000000000000000', Trunc(DoubleDouble('0.0')));
  CheckEquals('2.0000000000000000000000000000000', Trunc(DoubleDouble('2.0')));
  CheckEquals('2.0000000000000000000000000000000', Trunc(DoubleDouble('2.1')));
  CheckEquals('2.0000000000000000000000000000000', Trunc(DoubleDouble('2.5')));
  CheckEquals('2.0000000000000000000000000000000', Trunc(DoubleDouble('2.9')));
end;

end.
