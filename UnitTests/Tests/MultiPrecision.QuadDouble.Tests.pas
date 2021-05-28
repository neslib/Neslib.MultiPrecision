unit MultiPrecision.QuadDouble.Tests;

interface

uses
  UnitTest,
  Neslib.MultiPrecision;

type
  TTestQuadDouble = class(TUnitTest)
  private
    procedure CheckEquals(const AExpected: String;
      const AActual: QuadDouble); overload;
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

    procedure TestAddQD_QD;
    procedure TestAddDD_QD;
    procedure TestAddQD_DD;
    procedure TestAddQD_D;
    procedure TestAddD_QD;

    procedure TestSubtractQD_QD;
    procedure TestSubtractDD_QD;
    procedure TestSubtractQD_DD;
    procedure TestSubtractQD_D;
    procedure TestSubtractD_QD;

    procedure TestMultiplyQD_QD;
    procedure TestMultiplyDD_QD;
    procedure TestMultiplyQD_DD;
    procedure TestMultiplyQD_D;
    procedure TestMultiplyD_QD;

    procedure TestDivideQD_QD;
    procedure TestDivideDD_QD;
    procedure TestDivideQD_DD;
    procedure TestDivideQD_D;
    procedure TestDivideD_QD;
    procedure TestRem;
    procedure TestDivRem;
    procedure TestFMod;

    procedure TestNeg;
    procedure TestInv;

    procedure TestSqrt;
    procedure TestSqr;

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

{ TTestQuadDouble }

procedure TTestQuadDouble.CheckEquals(const AExpected: String;
  const AActual: QuadDouble);
var
  Actual: String;
begin
  Actual := AActual.ToString(USFormatSettings, TMPFloatFormat.Fixed);
  CheckEquals(AExpected, Actual);
end;

procedure TTestQuadDouble.TestAbs;
var
  A, B: QuadDouble;
begin
  A := Abs(QuadDouble.Pi);
  CheckEquals('3.14159265358979323846264338327950288419716939937510582097494459', A);

  B := -QuadDouble.Pi;
  CheckEquals('-3.14159265358979323846264338327950288419716939937510582097494459', B);

  A := QuadDouble.Zero;
  A := Abs(B);
  CheckEquals('3.14159265358979323846264338327950288419716939937510582097494459', A);
end;

procedure TTestQuadDouble.TestAddD_QD;
var
  A, B: QuadDouble;
  D: Double;
begin
  D := 1.1;
  A := 1.1 + QuadDouble.Pi;
  B := D + QuadDouble.Pi;
  CheckEquals('4.24159265358979332728048535329202611808770284664073082097494459', A);
  CheckEquals('4.24159265358979332728048535329202611808770284664073082097494459', B);
end;

procedure TTestQuadDouble.TestAddDD_QD;
var
  A: QuadDouble;
begin
  A := DoubleDouble.Pi + QuadDouble.E;
  CheckEquals('5.85987448204883847382293085463216837672422621141462003753618010', A);
end;

procedure TTestQuadDouble.TestAddQD_D;
var
  A, B: QuadDouble;
  D: Double;
begin
  D := 1.1;
  A := QuadDouble.Pi + 1.1;
  B := QuadDouble.Pi + D;
  CheckEquals('4.24159265358979332728048535329202611808770284664073082097494459', A);
  CheckEquals('4.24159265358979332728048535329202611808770284664073082097494459', B);
end;

procedure TTestQuadDouble.TestAddQD_DD;
var
  A: QuadDouble;
begin
  A := QuadDouble.Pi + DoubleDouble.E;
  CheckEquals('5.85987448204883847382293085463216750967152453125167835081770655', A);
end;

procedure TTestQuadDouble.TestAddQD_QD;
var
  A: QuadDouble;
begin
  A := QuadDouble.Pi + QuadDouble.E;
  CheckEquals('5.85987448204883847382293085463216538195441649307506539594191222', A);
end;

procedure TTestQuadDouble.TestArcCos;
var
  A: QuadDouble;
begin
  A := '1.1'; CheckEquals('NAN', ArcCos(A));
  {$IFDEF MP_ACCURATE}
  A := '1.0'; CheckEquals('0.00000000000000000000000000000000435788199605262343947870810047', ArcCos(A));
  A := '-1.0'; CheckEquals('3.14159265358979323846264338327949852631517334675166634226684412', ArcCos(A));
  {$ELSE}
  A := '1.0'; CheckEquals('0.00000000000000000000000000000000000000000000000000000000000000', ArcCos(A));
  A := '-1.0'; CheckEquals('3.14159265358979323846264338327950288419716939937510582097494459', ArcCos(A));
  {$ENDIF}
  A := '0.5'; CheckEquals('1.04719755119659774615421446109316762806572313312503527365831486', ArcCos(A));
end;

procedure TTestQuadDouble.TestArcCosh;
var
  A: QuadDouble;
begin
  A := '0.5'; CheckEquals('NAN', ArcCosh(A));
  A := '1.5'; CheckEquals('0.96242365011920689499551782684873684627036866877132103932203634', ArcCosh(A));
end;

procedure TTestQuadDouble.TestArcSin;
var
  A: QuadDouble;
begin
  A := '1.1'; CheckEquals('NAN', ArcSin(A));
  {$IFDEF MP_ACCURATE}
  A := '1.0'; CheckEquals('1.57079632679489661923132169163974708421658864706411343177937183', ArcSin(A));
  A := '-1.0'; CheckEquals('-1.57079632679489661923132169163974708421658864706411343177937183', ArcSin(A));
  {$ELSE}
  A := '1.0'; CheckEquals('1.57079632679489661923132169163975144209858469968755291048747230', ArcSin(A));
  A := '-1.0'; CheckEquals('-1.57079632679489661923132169163975144209858469968755291048747230', ArcSin(A));
  {$ENDIF}
  A := '0.5'; CheckEquals('0.52359877559829887307710723054658381403286156656251763682915743', ArcSin(A));
end;

procedure TTestQuadDouble.TestArcSinh;
var
  A: QuadDouble;
begin
  A := '0.5'; CheckEquals('0.48121182505960344749775891342436842313518433438566051966101817', ArcSinh(A));
end;

procedure TTestQuadDouble.TestArcTan;
var
  A: QuadDouble;
begin
  A := '0.5'; CheckEquals('0.46364760900080611621425623146121440202853705428612026381093309', ArcTan(A));
end;

procedure TTestQuadDouble.TestArcTan2;
var
  P, N: QuadDouble;
begin
  P := '0.5';
  N := '-0.5';
  CheckEquals('NAN', ArcTan2(QuadDouble.Zero, QuadDouble.Zero));
  CheckEquals('1.57079632679489661923132169163975144209858469968755291048747230', ArcTan2(P, QuadDouble.Zero));
  CheckEquals('-1.57079632679489661923132169163975144209858469968755291048747230', ArcTan2(N, QuadDouble.Zero));
  CheckEquals('0.00000000000000000000000000000000000000000000000000000000000000', ArcTan2(QuadDouble.Zero, P));
  CheckEquals('3.14159265358979323846264338327950288419716939937510582097494459', ArcTan2(QuadDouble.Zero, N));
  CheckEquals('0.78539816339744830961566084581987572104929234984377645524373615', ArcTan2(P, P));
  CheckEquals('-2.35619449019234492884698253745962716314787704953132936573120844', ArcTan2(N, N));
  CheckEquals('2.35619449019234492884698253745962716314787704953132936573120844', ArcTan2(P, N));
  CheckEquals('-0.78539816339744830961566084581987572104929234984377645524373615', ArcTan2(N, P));

  P := '0.4';
  N := '-0.1';
  CheckEquals('-0.24497866312686415417208248121127581091414409838118406712737591', ArcTan2(N, P));
end;

procedure TTestQuadDouble.TestArcTanh;
var
  A: QuadDouble;
begin
  A := '1.5'; CheckEquals('NAN', ArcTanh(A));
  A := '0.5'; CheckEquals('0.54930614433405484569762261846126285232374527891137472586734717', ArcTanh(A));
end;

procedure TTestQuadDouble.TestCeil;
var
  A: QuadDouble;
begin
  A := '-3.9';
  CheckEquals('-3.00000000000000000000000000000000000000000000000000000000000000', Ceil(A));

  A := '-3.5';
  CheckEquals('-3.00000000000000000000000000000000000000000000000000000000000000', Ceil(A));

  A := '-3.1';
  CheckEquals('-3.00000000000000000000000000000000000000000000000000000000000000', Ceil(A));

  A := '-3.0';
  {$IFDEF MP_ACCURATE}
  { -3.0 cannot be accurately represented. It is actually represented as slightly larger than -3 }
  CheckEquals('-2.00000000000000000000000000000000000000000000000000000000000000', Trunc(A));
  {$ELSE}
  CheckEquals('-3.00000000000000000000000000000000000000000000000000000000000000', Trunc(A));
  {$ENDIF}

  A := '0.0';
  CheckEquals('0.00000000000000000000000000000000000000000000000000000000000000', Ceil(A));

  A := '2.0';
  CheckEquals('2.00000000000000000000000000000000000000000000000000000000000000', Ceil(A));

  A := '2.1';
  CheckEquals('3.00000000000000000000000000000000000000000000000000000000000000', Ceil(A));

  A := '2.5';
  CheckEquals('3.00000000000000000000000000000000000000000000000000000000000000', Ceil(A));

  A := '2.9';
  CheckEquals('3.00000000000000000000000000000000000000000000000000000000000000', Ceil(A));
end;

procedure TTestQuadDouble.TestConstants;
begin
  CheckEquals('3.14159265358979323846264338327950288419716939937510582097494459', QuadDouble.Pi);
  CheckEquals('6.28318530717958647692528676655900576839433879875021164194988918', QuadDouble.PiTimes2);
  CheckEquals('1.57079632679489661923132169163975144209858469968755291048747230', QuadDouble.PiOver2);
  CheckEquals('0.78539816339744830961566084581987572104929234984377645524373615', QuadDouble.PiOver4);
  CheckEquals('2.35619449019234492884698253745962716314787704953132936573120844', QuadDouble.PiTimes3Over4);
  CheckEquals('0.01745329251994329576923690768488612713442871888541725456097191', QuadDouble.PiOver180);
  CheckEquals('57.29577951308232087679815481410517033240547246656432154916024390', QuadDouble._180OverPi);
  CheckEquals('2.71828182845904523536028747135266249775724709369995957496696763', QuadDouble.E);
  CheckEquals('0.69314718055994530941723212145817656807550013436025525412068001', QuadDouble.Log2);
  CheckEquals('2.30258509299404568401799145468436420760110148862877297603332790', QuadDouble.Log10);
  CheckEquals('0.00000000000000000000000000000000000000000000000000000000000000', QuadDouble.Zero);
  CheckEquals('1.00000000000000000000000000000000000000000000000000000000000000', QuadDouble.One);
  CheckEquals('NAN', QuadDouble.NaN);
  CheckEquals('INF', QuadDouble.PositiveInfinity);
  CheckEquals('-INF', QuadDouble.NegativeInfinity);
end;

procedure TTestQuadDouble.TestCos;
var
  A: QuadDouble;
begin
  { These test all possible code paths }

  A := Cos(QuadDouble.Zero);
  CheckEquals('1.00000000000000000000000000000000000000000000000000000000000000', A);

  A := '1.0'; A := Cos(A);
  CheckEquals('0.54030230586813971740093660744297660373231042061792222767009726', A);

  A := '2.0'; A := Cos(A);
  CheckEquals('-0.41614683654714238699756822950076218976600077107554489075514997', A);

  A := '3.0'; A := Cos(A);
  CheckEquals('-0.98999249660044545727157279473126130239367909661558832881408593', A);

  A := '4.0'; A := Cos(A);
  CheckEquals('-0.65364362086361191463916818309775038142413359664621824700701028', A);

  A := '5.0'; A := Cos(A);
  CheckEquals('0.28366218546322626446663917151355730833442259225221594493035907', A);

  A := '6.0'; A := Cos(A);
  CheckEquals('0.96017028665036602054565229792292440545193767921101269812928643', A);

  A := '7.0'; A := Cos(A);
  CheckEquals('0.75390225434330463814119752171918201221831339146012683954361388', A);

  A := '-3.0'; A := Cos(A);
  CheckEquals('-0.98999249660044545727157279473126130239367909661558832881408593', A);

  A := '0.01'; A := Cos(A);
  CheckEquals('0.99995000041666527778025793375220667321247058398027711112227577', A);

  A := '1.571'; A := Cos(A);
  CheckEquals('-0.00020367320369522583254428708770888572746910392387517153792296', A);

  A := '3.142'; A := Cos(A);
  CheckEquals('-0.99999991703445219304609254277572150536302711196499875412991422', A);

  A := '4.713'; A := Cos(A);
  CheckEquals('0.00061101957728995966128942115960498441443579704656678239892089', A);
end;

procedure TTestQuadDouble.TestCosh;
var
  A: QuadDouble;
begin
  A := '0.0'; A := Cosh(A);
  CheckEquals('1.00000000000000000000000000000000000000000000000000000000000000', A);

  A := '0.5'; A := Cosh(A);
  CheckEquals('1.12762596520638078522622516140267201254784711809866748362898574', A);

  A := '0.01'; A := Cosh(A);
  CheckEquals('1.00005000041666805555803571704144829578972064138906499102414139', A);
end;

procedure TTestQuadDouble.TestDivideD_QD;
var
  A, B: QuadDouble;
  D: Double;
begin
  D := 1.3;
  A := 1.3 / QuadDouble.Pi;
  B := D / QuadDouble.Pi;
  CheckEquals('0.41380285203892788713489636905083359596757596326647850387884162', A);
  CheckEquals('0.41380285203892788713489636905083359596757596326647850387884162', B);
end;

procedure TTestQuadDouble.TestDivideDD_QD;
var
  A: QuadDouble;
begin
  A := DoubleDouble.Pi / QuadDouble.E;
  CheckEquals('1.15572734979092171791009318331269740083509505945382745253545851', A);
end;

procedure TTestQuadDouble.TestDivideQD_D;
var
  A, B: QuadDouble;
  D: Double;
begin
  D := 1.1;
  A := QuadDouble.Pi / 1.1;
  B := QuadDouble.Pi / D;
  CheckEquals('2.85599332144526634981770899249332540834081204681357405053692733', A);
  CheckEquals('2.85599332144526634981770899249332540834081204681357405053692733', B);
end;

procedure TTestQuadDouble.TestDivideQD_DD;
var
  A: QuadDouble;
begin
  A := QuadDouble.Pi / DoubleDouble.E;
  CheckEquals('1.15572734979092171791009318331269539448291810810231168258063763', A);
end;

procedure TTestQuadDouble.TestDivideQD_QD;
var
  A: QuadDouble;
begin
  A := QuadDouble.Pi / QuadDouble.E;
  CheckEquals('1.15572734979092171791009318331269629912085102316441582049970654', A);
end;

procedure TTestQuadDouble.TestDivRem;
var
  Res, Remainder: QuadDouble;
begin
  Res := DivRem(QuadDouble.Pi, QuadDouble.Log2, Remainder);
  CheckEquals('5.00000000000000000000000000000000000000000000000000000000000000', Res);
  CheckEquals('-0.32414324920993330862351722401137995618033127242617044962845546', Remainder);

  DivRem(QuadDouble.Pi, QuadDouble.Log2, Remainder, Res);
  CheckEquals('5.00000000000000000000000000000000000000000000000000000000000000', Res);
  CheckEquals('-0.32414324920993330862351722401137995618033127242617044962845546', Remainder);
end;

procedure TTestQuadDouble.TestEqual;
var
  A, B, C: QuadDouble;
  D: DoubleDouble;
begin
  A := '3.14159265358979323846264338327950288419716939937510582097494458';
  B := '3.14159265358979323846264338327950288419716939937510582097494458';
  C := '3.14159265358979323846264338327950288419716939937510582097494459';
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

  D := DoubleDouble.Pi;
  CheckFalse(A = D);
  CheckFalse(D = A);
  CheckFalse(A.Equals(D));

  A.Init(D);
  CheckTrue(A = D);
  CheckTrue(D = A);
  CheckTrue(A.Equals(D));
end;

procedure TTestQuadDouble.TestExp;
var
  A: QuadDouble;
begin
  A := Exp(QuadDouble.Pi);
  CheckEquals('23.14069263277926900572908636794854738026610624260021199344504641', A);
end;

procedure TTestQuadDouble.TestFloor;
var
  A: QuadDouble;
begin
  A := '-3.9';
  CheckEquals('-4.00000000000000000000000000000000000000000000000000000000000000', Floor(A));

  A := '-3.5';
  CheckEquals('-4.00000000000000000000000000000000000000000000000000000000000000', Floor(A));

  A := '-3.1';
  CheckEquals('-4.00000000000000000000000000000000000000000000000000000000000000', Floor(A));

  A := '-3.0';
  CheckEquals('-3.00000000000000000000000000000000000000000000000000000000000000', Floor(A));

  A := '0.0';
  CheckEquals('0.00000000000000000000000000000000000000000000000000000000000000', Floor(A));

  A := '2.0';
  {$IFDEF MP_ACCURATE}
  { 2.0 cannot be accurately represented. It is actually represented as slightly smaller than 2 }
  CheckEquals('1.00000000000000000000000000000000000000000000000000000000000000', Floor(A));
  {$ELSE}
  CheckEquals('2.00000000000000000000000000000000000000000000000000000000000000', Floor(A));
  {$ENDIF}

  A := '2.1';
  CheckEquals('2.00000000000000000000000000000000000000000000000000000000000000', Floor(A));

  A := '2.5';
  CheckEquals('2.00000000000000000000000000000000000000000000000000000000000000', Floor(A));

  A := '2.9';
  CheckEquals('2.00000000000000000000000000000000000000000000000000000000000000', Floor(A));
end;

procedure TTestQuadDouble.TestFMod;
var
  A: QuadDouble;
begin
  A := FMod(QuadDouble.PiOver2, QuadDouble.E);
  CheckEquals('1.57079632679489661923132169163975144209858469968755291048747230', A);
end;

procedure TTestQuadDouble.TestGreaterThan;
var
  A, B, C: QuadDouble;
  D: DoubleDouble;
begin
  A := '3.14159265358979323846264338327950288419716939937510582097494458';
  B := '3.14159265358979323846264338327950288419716939937510582097494458';
  C := '3.14159265358979323846264338327950288419716939937510582097494459';
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

  D := DoubleDouble.Pi;
  CheckFalse(A > D);
  CheckTrue(D > A);

  A.Init(DoubleDouble.Pi);
  CheckFalse(A > D);
  CheckFalse(D > A);
end;

procedure TTestQuadDouble.TestGreaterThanOrEqual;
var
  A, B, C: QuadDouble;
  D: DoubleDouble;
begin
  A := '3.14159265358979323846264338327950288419716939937510582097494458';
  B := '3.14159265358979323846264338327950288419716939937510582097494458';
  C := '3.14159265358979323846264338327950288419716939937510582097494459';
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

  D := DoubleDouble.Pi;
  CheckFalse(A >= D);
  CheckTrue(D >= A);

  A.Init(DoubleDouble.Pi);
  CheckTrue(A >= D);
  CheckTrue(D >= A);
end;

procedure TTestQuadDouble.TestInit;
var
  A: QuadDouble;
begin
  A.Init;
  CheckEquals(0, A.X[0], 0);
  CheckEquals(0, A.X[1], 0);
  CheckEquals(0, A.X[2], 0);
  CheckEquals(0, A.X[3], 0);
  CheckEquals('0.00000000000000000000000000000000000000000000000000000000000000', A);

  A.Init(1.5);
  CheckEquals(1.5, A.X[0], 0);
  CheckEquals(0, A.X[1], 0);
  CheckEquals(0, A.X[2], 0);
  CheckEquals(0, A.X[3], 0);
  CheckEquals('1.50000000000000000000000000000000000000000000000000000000000000', A);

  A.Init(DoubleDouble.Log2);
  CheckEquals(6.931471805599452862e-01, A.X[0], 0);
  CheckEquals(2.319046813846299558e-17, A.X[1], 0);
  CheckEquals(0, A.X[2], 0);
  CheckEquals(0, A.X[3], 0);
  CheckEquals('0.69314718055994530941723212145817599730465629273908450073995924', A);

  A.Init(Pi, 1.224646799147353207e-16, -2.994769809718339666e-33, 1.112454220863365282e-49);
  CheckEquals(Pi, A.X[0], 0);
  CheckEquals(1.224646799147353207e-16, A.X[1], 0);
  CheckEquals(-2.994769809718339666e-33, A.X[2], 0);
  CheckEquals(1.112454220863365282e-49, A.X[3], 0);
  CheckEquals('3.14159265358979323846264338327950288419716939937510582097494459', A);

  A.Init('2.71828182845904523536028747135266249775724709369995957496696763', USFormatSettings);
  CheckEquals(QuadDouble.E.X[0], A.X[0], 0);
  CheckEquals(QuadDouble.E.X[1], A.X[1], 0);
  CheckEquals(QuadDouble.E.X[2], A.X[2], 0);
  CheckEquals(QuadDouble.E.X[3], A.X[3], 0);
  CheckEquals('2.71828182845904523536028747135266249775724709369995957496696763', A);
end;

procedure TTestQuadDouble.TestInv;
var
  A: QuadDouble;
begin
  A := Inverse(QuadDouble.Pi);
  CheckEquals('0.31830988618379067153776752674502872406891929148091289749533469', A);
end;

procedure TTestQuadDouble.TestIssue3;
var
  X, Y, Z: QuadDouble;
begin
  X := '-3.5';
  Y := '1.0E-1';
  Z := Tanh(Y / X);
  CheckEquals('-0.02856365657082803786501653081000496058278335051341205247223807', Z);
end;

procedure TTestQuadDouble.TestIssue4;
var
  A: QuadDouble;
begin
  A := '1E0'; { Should not enter eternal loop }
  CheckEquals('1.00000000000000000000000000000000000000000000000000000000000000', A);
end;

procedure TTestQuadDouble.TestIssue5;
var
  X, Y, Z: QuadDouble;
begin
  X := '-3.5';
  Y := '-5.08888E+1';
  Z := Y / X;
  CheckEquals('14.53965714285714285714285714285714285714285714285714285714285714', Z);
end;

procedure TTestQuadDouble.TestIssue6;
var
  A: QuadDouble;
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

procedure TTestQuadDouble.TestLdexp;
var
  A: QuadDouble;
begin
  A := Ldexp(QuadDouble.Pi, 4);
  CheckEquals('50.26548245743669181540229413247204614715471039000169313559911348', A);
end;

procedure TTestQuadDouble.TestLessThan;
var
  A, B, C: QuadDouble;
  D: DoubleDouble;
begin
  A := '3.14159265358979323846264338327950288419716939937510582097494458';
  B := '3.14159265358979323846264338327950288419716939937510582097494458';
  C := '3.14159265358979323846264338327950288419716939937510582097494459';
  CheckFalse(A < B);
  CheckTrue(A < C);

  CheckFalse(A < Pi);
  CheckTrue(Pi < A);

  CheckFalse(A < 3.0);
  CheckTrue(3.0 < A);

  A.Init(Pi);
  CheckFalse(A < Pi);
  CheckFalse(Pi < A);

  D := DoubleDouble.Pi;
  CheckTrue(A < D);
  CheckFalse(D < A);

  A.Init(DoubleDouble.Pi);
  CheckFalse(A < D);
  CheckFalse(D < A);
end;

procedure TTestQuadDouble.TestLessThanOrEqual;
var
  A, B, C: QuadDouble;
  D: DoubleDouble;
begin
  A := '3.14159265358979323846264338327950288419716939937510582097494458';
  B := '3.14159265358979323846264338327950288419716939937510582097494458';
  C := '3.14159265358979323846264338327950288419716939937510582097494459';
  CheckTrue(A <= B);
  CheckTrue(A <= C);

  CheckFalse(A <= Pi);
  CheckTrue(Pi <= A);

  CheckFalse(A <= 3.0);
  CheckTrue(3.0 <= A);

  A.Init(Pi);
  CheckTrue(A <= Pi);
  CheckTrue(Pi <= A);

  D := DoubleDouble.Pi;
  CheckTrue(A <= D);
  CheckFalse(D <= A);

  A.Init(DoubleDouble.Pi);
  CheckTrue(A <= D);
  CheckTrue(D <= A);
end;

procedure TTestQuadDouble.TestLn;
var
  A: QuadDouble;
begin
  A := Ln(QuadDouble.Pi);
  CheckEquals('1.14472988584940017414342735135305871164729481291531157151362307', A);
end;

procedure TTestQuadDouble.TestLog10;
var
  A: QuadDouble;
begin
  A := Log10(QuadDouble.Pi);
  CheckEquals('0.49714987269413385435126828829089887365167832438044244613405350', A);
end;

procedure TTestQuadDouble.TestMultiplyD_QD;
var
  A, B: QuadDouble;
  D: Double;
begin
  D := 1.3;
  A := 1.3 * QuadDouble.Pi;
  B := D * QuadDouble.Pi;
  CheckEquals('4.08407044966673134951617631860862972862595640290653796673909756', A);
  CheckEquals('4.08407044966673134951617631860862972862595640290653796673909756', B);
end;

procedure TTestQuadDouble.TestMultiplyDD_QD;
var
  A: QuadDouble;
begin
  A := DoubleDouble.Pi * QuadDouble.E;
  CheckEquals('8.53973422267356706546355086954657595124280718082386301457465514', A);
end;

procedure TTestQuadDouble.TestMultiplyQD_D;
var
  A, B: QuadDouble;
  D: Double;
begin
  D := 1.2;
  A := QuadDouble.Pi * 1.2;
  B := QuadDouble.Pi * D;
  CheckEquals('3.76991118430775174664043213959012748186696709553122658569826392', A);
  CheckEquals('3.76991118430775174664043213959012748186696709553122658569826392', B);
end;

procedure TTestQuadDouble.TestMultiplyQD_DD;
var
  A: QuadDouble;
begin
  A := QuadDouble.Pi * DoubleDouble.E;
  CheckEquals('8.53973422267356706546355086954657303882696989070586336017412522', A);
end;

procedure TTestQuadDouble.TestMultiplyQD_QD;
var
  A: QuadDouble;
begin
  A := QuadDouble.Pi * QuadDouble.E;
  CheckEquals('8.53973422267356706546355086954657449503488853576511496187960113', A);
end;

procedure TTestQuadDouble.TestNeg;
var
  A: QuadDouble;
begin
  A := -QuadDouble.Pi;
  CheckEquals('-3.14159265358979323846264338327950288419716939937510582097494459', A);
end;

procedure TTestQuadDouble.TestNotEqual;
var
  A, B, C: QuadDouble;
  D: DoubleDouble;
begin
  A := '3.14159265358979323846264338327950288419716939937510582097494458';
  B := '3.14159265358979323846264338327950288419716939937510582097494458';
  C := '3.14159265358979323846264338327950288419716939937510582097494459';
  CheckFalse(A <> B);
  CheckTrue(A <> C);

  CheckTrue(A <> Pi);
  CheckTrue(Pi <> A);

  A.Init(Pi);
  CheckFalse(A <> Pi);
  CheckFalse(Pi <> A);

  D := DoubleDouble.Pi;
  CheckTrue(A <> D);
  CheckTrue(D <> A);

  A.Init(D);
  CheckFalse(A <> D);
  CheckFalse(D <> A);
end;

procedure TTestQuadDouble.TestNRoot;
var
  A: QuadDouble;
begin
  A := NRoot(QuadDouble.Pi, 3);
  CheckEquals('1.46459188756152326302014252726379039173859685562793717435725594', A);
end;

procedure TTestQuadDouble.TestPower;
var
  A: QuadDouble;
begin
  A := Power(QuadDouble.Pi, QuadDouble.Log2);
  CheckEquals('2.21104729601549898794117022977136536896562299100952293516727824', A);
end;

procedure TTestQuadDouble.TestPowerInt;
var
  A: QuadDouble;
begin
  A := IntPower(QuadDouble.Pi, 4);
  CheckEquals('97.40909103400243723644033268870511124972758567268542169146785939', A);
end;

procedure TTestQuadDouble.TestRem;
var
  A: QuadDouble;
begin
  A := Rem(QuadDouble.PiOver2, QuadDouble.E);
  CheckEquals('-1.14748550166414861612896577971291105565866239401240666447949533', A);
end;

procedure TTestQuadDouble.TestRound;
var
  A: QuadDouble;
begin
  A := '-3.9';
  CheckEquals('-4.00000000000000000000000000000000000000000000000000000000000000', Round(A));

  A := '-3.5';
  CheckEquals('-3.00000000000000000000000000000000000000000000000000000000000000', Round(A));

  A := '-3.1';
  CheckEquals('-3.00000000000000000000000000000000000000000000000000000000000000', Round(A));

  A := '-3.0';
  CheckEquals('-3.00000000000000000000000000000000000000000000000000000000000000', Round(A));

  A := '0.0';
  CheckEquals('0.00000000000000000000000000000000000000000000000000000000000000', Round(A));

  A := '2.0';
  CheckEquals('2.00000000000000000000000000000000000000000000000000000000000000', Round(A));

  A := '2.1';
  CheckEquals('2.00000000000000000000000000000000000000000000000000000000000000', Round(A));

  A := '2.5';
  {$IFDEF MP_ACCURATE}
  { 2.5 cannot be accurately represented. It is actually represented as smaller larger than 2.5 }
  CheckEquals('2.00000000000000000000000000000000000000000000000000000000000000', Round(A));
  {$ELSE}
  CheckEquals('3.00000000000000000000000000000000000000000000000000000000000000', Round(A));
  {$ENDIF}

  A := '2.9';
  CheckEquals('3.00000000000000000000000000000000000000000000000000000000000000', Round(A));
end;

procedure TTestQuadDouble.TestSin;
var
  A: QuadDouble;
begin
  { These test all possible code paths }
  A := Sin(QuadDouble.Zero);
  CheckEquals('0.00000000000000000000000000000000000000000000000000000000000000', A);

  A := '1.0'; A := Sin(A);
  CheckEquals('0.84147098480789650665250232163029899962256306079837106567275171', A);

  A := '2.0'; A := Sin(A);
  CheckEquals('0.90929742682568169539601986591174484270225497144789026837897301', A);

  A := '3.0'; A := Sin(A);
  CheckEquals('0.14112000805986722210074480280811027984693326425226558415188264', A);

  A := '4.0'; A := Sin(A);
  CheckEquals('-0.75680249530792825137263909451182909413591288733647257148541677', A);

  A := '5.0'; A := Sin(A);
  CheckEquals('-0.95892427466313846889315440615599397335246154396460177813167245', A);

  A := '6.0'; A := Sin(A);
  CheckEquals('-0.27941549819892587281155544661189475962799486431820431848335137', A);

  A := '7.0'; A := Sin(A);
  CheckEquals('0.65698659871878909039699909159363517793687001049749007465785433', A);

  A := '-3.0'; A := Sin(A);
  CheckEquals('-0.14112000805986722210074480280811027984693326425226558415188264', A);

  A := '0.01'; A := Sin(A);
  CheckEquals('0.00999983333416666468254243826909972903896438536016915103387911', A);

  A := '1.571'; A := Sin(A);
  CheckEquals('0.99999997925861283315895233329467931779109228727381463311309433', A);

  A := '3.142'; A := Sin(A);
  CheckEquals('-0.00040734639894152211838145471272975443012447029550738336626488', A);

  A := '4.713'; A := Sin(A);
  CheckEquals('-0.99999981332752066089223456502852650209847284677993360766809990', A);
end;

procedure TTestQuadDouble.TestSinCos;
var
  A, S, C: QuadDouble;
begin
  { These test all possible code paths }

  SinCos(QuadDouble.Zero, S, C);
  CheckEquals('0.00000000000000000000000000000000000000000000000000000000000000', S);
  CheckEquals('1.00000000000000000000000000000000000000000000000000000000000000', C);

  A := '1.0'; SinCos(A, S, C);
  CheckEquals('0.84147098480789650665250232163029899962256306079837106567275171', S);
  CheckEquals('0.54030230586813971740093660744297660373231042061792222767009726', C);

  A := '2.0'; SinCos(A, S, C);
  CheckEquals('0.90929742682568169539601986591174484270225497144789026837897301', S);
  CheckEquals('-0.41614683654714238699756822950076218976600077107554489075514997', C);

  A := '3.0'; SinCos(A, S, C);
  CheckEquals('0.14112000805986722210074480280811027984693326425226558415188264', S);
  CheckEquals('-0.98999249660044545727157279473126130239367909661558832881408593', C);

  A := '4.0'; SinCos(A, S, C);
  CheckEquals('-0.75680249530792825137263909451182909413591288733647257148541677', S);
  CheckEquals('-0.65364362086361191463916818309775038142413359664621824700701028', C);

  A := '5.0'; SinCos(A, S, C);
  CheckEquals('-0.95892427466313846889315440615599397335246154396460177813167245', S);
  CheckEquals('0.28366218546322626446663917151355730833442259225221594493035907', C);

  A := '6.0'; SinCos(A, S, C);
  CheckEquals('-0.27941549819892587281155544661189475962799486431820431848335137', S);
  CheckEquals('0.96017028665036602054565229792292440545193767921101269812928643', C);

  A := '7.0'; SinCos(A, S, C);
  CheckEquals('0.65698659871878909039699909159363517793687001049749007465785433', S);
  CheckEquals('0.75390225434330463814119752171918201221831339146012683954361388', C);

  A := '-3.0'; SinCos(A, S, C);
  CheckEquals('-0.14112000805986722210074480280811027984693326425226558415188264', S);
  CheckEquals('-0.98999249660044545727157279473126130239367909661558832881408593', C);

  A := '0.01'; SinCos(A, S, C);
  CheckEquals('0.00999983333416666468254243826909972903896438536016915103387911', S);
  CheckEquals('0.99995000041666527778025793375220667321247058398027711112227577', C);

  A := '1.571'; SinCos(A, S, C);
  CheckEquals('0.99999997925861283315895233329467931779109228727381463311309433', S);
  CheckEquals('-0.00020367320369522583254428708770888572746910392387517153792296', C);

  A := '3.142'; SinCos(A, S, C);
  CheckEquals('-0.00040734639894152211838145471272975443012447029550738336626488', S);
  CheckEquals('-0.99999991703445219304609254277572150536302711196499875412991422', C);

  A := '4.713'; SinCos(A, S, C);
  CheckEquals('-0.99999981332752066089223456502852650209847284677993360766809990', S);
  CheckEquals('0.00061101957728995966128942115960498441443579704656678239892089', C);
end;

procedure TTestQuadDouble.TestSinCosh;
var
  A, S, C: QuadDouble;
begin
  A := '0.01'; SinCosh(A, S, C);
  CheckEquals('0.01000016666750000198412973986141173801764156013522752414026264', S);
  CheckEquals('1.00005000041666805555803571704144829578972064138906499102414139', C);

  A := '0.5'; SinCosh(A, S, C);
  CheckEquals('0.52109530549374736162242562641149155910592898261148052794609358', S);
  CheckEquals('1.12762596520638078522622516140267201254784711809866748362898574', C);
end;

procedure TTestQuadDouble.TestSinh;
var
  A: QuadDouble;
begin
  A := '0.0'; A := Sinh(A);
  CheckEquals('0.00000000000000000000000000000000000000000000000000000000000000', A);

  A := '0.5'; A := Sinh(A);
  CheckEquals('0.52109530549374736162242562641149155910592898261148052794609358', A);

  A := '0.01'; A := Sinh(A);
  CheckEquals('0.01000016666750000198412973986141173801764156013522752414026264', A);
end;

procedure TTestQuadDouble.TestSqr;
var
  A: QuadDouble;
begin
  A := Sqr(QuadDouble.Pi);
  CheckEquals('9.86960440108935861883449099987615113531369940724079062641334938', A);
end;

procedure TTestQuadDouble.TestSqrt;
var
  A: QuadDouble;
begin
  A := Sqrt(QuadDouble.Pi);
  CheckEquals('1.77245385090551602729816748334114518279754945612238712821380779', A);
end;

procedure TTestQuadDouble.TestSubtractD_QD;
var
  A, B: QuadDouble;
  D: Double;
begin
  D := 1.1;
  A := 1.1 - QuadDouble.Pi;
  B := D - QuadDouble.Pi;
  CheckEquals('-2.04159265358979314964480141326697965030663595210948082097494459', A);
  CheckEquals('-2.04159265358979314964480141326697965030663595210948082097494459', B);
end;

procedure TTestQuadDouble.TestSubtractDD_QD;
var
  A: QuadDouble;
begin
  A := DoubleDouble.Pi - QuadDouble.E;
  CheckEquals('0.42331082513074800310235591192684338120973202401470088760224484', A);
end;

procedure TTestQuadDouble.TestSubtractQD_D;
var
  A, B: QuadDouble;
  D: Double;
begin
  D := 1.1;
  A := QuadDouble.Pi - 1.1;
  B := QuadDouble.Pi - D;
  CheckEquals('2.04159265358979314964480141326697965030663595210948082097494459', A);
  CheckEquals('2.04159265358979314964480141326697965030663595210948082097494459', B);
end;

procedure TTestQuadDouble.TestSubtractQD_DD;
var
  A: QuadDouble;
begin
  A := QuadDouble.Pi - DoubleDouble.E;
  CheckEquals('0.42331082513074800310235591192683825872281426749853329113218263', A);
end;

procedure TTestQuadDouble.TestSubtractQD_QD;
var
  A: QuadDouble;
begin
  A := QuadDouble.Pi - QuadDouble.E;
  CheckEquals('0.42331082513074800310235591192684038643992230567514624600797696', A);
end;

procedure TTestQuadDouble.TestTan;
var
  A: QuadDouble;
begin
  A := Tan(QuadDouble.Zero);
  CheckEquals('0.00000000000000000000000000000000000000000000000000000000000000', A);

  A := Tan(QuadDouble.PiOver2);
  CheckEquals('NAN', A);

  A := '1.0'; A := Tan(A);
  CheckEquals('1.55740772465490223050697480745836017308725077238152003838394661', A);
end;

procedure TTestQuadDouble.TestTanh;
var
  A: QuadDouble;
begin
  A := '0.0'; A := Tanh(A);
  CheckEquals('0.00000000000000000000000000000000000000000000000000000000000000', A);

  A := '0.5'; A := Tanh(A);
  CheckEquals('0.46211715726000975850231848364367254873028928033011303855273182', A);

  A := '0.01'; A := Tanh(A);
  CheckEquals('0.00999966667999946033932891970883949751001103142423365164263187', A);
end;

procedure TTestQuadDouble.TestToString;
var
  A: QuadDouble;
  FS: TFormatSettings;
begin
  FS := TFormatSettings.Create('nl-NL');

  A := QuadDouble.Zero;
  CheckEquals('0.00000000000000000000000000000000000000000000000000000000000000E+00', A.ToString(USFormatSettings));
  CheckEquals('0.00000000000000000000000000000000000000000000000000000000000000', A.ToString(USFormatSettings, TMPFloatFormat.Fixed));
  CheckEquals('0.0000000000000000000000000000000000000000E+00', A.ToString(USFormatSettings, TMPFloatFormat.Scientific, 40));
  CheckEquals('0.0000000000000000000000000000000000000000', A.ToString(USFormatSettings, TMPFloatFormat.Fixed, 40));
  CheckEquals('0,0000000000000000000000000000000000000000E+00', A.ToString(FS, TMPFloatFormat.Scientific, 40));
  CheckEquals('0,0000000000000000000000000000000000000000', A.ToString(FS, TMPFloatFormat.Fixed, 40));

  A := QuadDouble.Pi / 1e3;
  CheckEquals('3.14159265358979323846264338327950288419716939937510582097494459E-03', A.ToString(USFormatSettings));
  CheckEquals('0.00314159265358979323846264338327950288419716939937510582097494', A.ToString(USFormatSettings, TMPFloatFormat.Fixed));
  CheckEquals('3.1415926535897932384626433832795028841972E-03', A.ToString(USFormatSettings, TMPFloatFormat.Scientific, 40));
  CheckEquals('0.0031415926535897932384626433832795028842', A.ToString(USFormatSettings, TMPFloatFormat.Fixed, 40));

  A := QuadDouble.E * 1e8;
  CheckEquals('2.71828182845904523536028747135266249775724709369995957496696763E+08', A.ToString(USFormatSettings));
  {$IF Defined(MP_ACCURATE)}
  CheckEquals('271828182.84590452353602874713526624977572470936999595749669676276992280', A.ToString(USFormatSettings, TMPFloatFormat.Fixed));
  {$ELSE}
  CheckEquals('271828182.84590452353602874713526624977572470936999595749669676277296138', A.ToString(USFormatSettings, TMPFloatFormat.Fixed));
  {$ENDIF}
  CheckEquals('2.7182818284590452353602874713526624977572E+08', A.ToString(USFormatSettings, TMPFloatFormat.Scientific, 40));
  CheckEquals('271828182.8459045235360287471352662497757247093700', A.ToString(USFormatSettings, TMPFloatFormat.Fixed, 40));

  A := QuadDouble.NaN;
  CheckEquals('NAN', A.ToString);
  CheckEquals('NAN', A.ToString(TMPFloatFormat.Fixed));
  CheckEquals('NAN', A.ToString(TMPFloatFormat.Scientific, 40));
  CheckEquals('NAN', A.ToString(TMPFloatFormat.Fixed, 40));

  A := QuadDouble.PositiveInfinity;
  CheckEquals('INF', A.ToString);
  CheckEquals('INF', A.ToString(TMPFloatFormat.Fixed));
  CheckEquals('INF', A.ToString(TMPFloatFormat.Scientific, 40));
  CheckEquals('INF', A.ToString(TMPFloatFormat.Fixed, 40));

  A := QuadDouble.NegativeInfinity;
  CheckEquals('-INF', A.ToString);
  CheckEquals('-INF', A.ToString(TMPFloatFormat.Fixed));
  CheckEquals('-INF', A.ToString(TMPFloatFormat.Scientific, 40));
  CheckEquals('-INF', A.ToString(TMPFloatFormat.Fixed, 40));
end;

procedure TTestQuadDouble.TestTrunc;
var
  A: QuadDouble;
begin
  A := '-3.9';
  CheckEquals('-3.00000000000000000000000000000000000000000000000000000000000000', Trunc(A));

  A := '-3.5';
  CheckEquals('-3.00000000000000000000000000000000000000000000000000000000000000', Trunc(A));

  A := '-3.1';
  CheckEquals('-3.00000000000000000000000000000000000000000000000000000000000000', Trunc(A));

  A := '-3.0';
  {$IFDEF MP_ACCURATE}
  { -3.0 cannot be accurately represented. It is actually represented as slightly larger than -3 }
  CheckEquals('-2.00000000000000000000000000000000000000000000000000000000000000', Trunc(A));
  {$ELSE}
  CheckEquals('-3.00000000000000000000000000000000000000000000000000000000000000', Trunc(A));
  {$ENDIF}

  A := '0.0';
  CheckEquals('0.00000000000000000000000000000000000000000000000000000000000000', Trunc(A));

  A := '2.0';
  {$IFDEF MP_ACCURATE}
  CheckEquals('1.00000000000000000000000000000000000000000000000000000000000000', Trunc(A));
  {$ELSE}
  CheckEquals('2.00000000000000000000000000000000000000000000000000000000000000', Trunc(A));
  {$ENDIF}

  A := '2.1';
  CheckEquals('2.00000000000000000000000000000000000000000000000000000000000000', Trunc(A));

  A := '2.5';
  CheckEquals('2.00000000000000000000000000000000000000000000000000000000000000', Trunc(A));

  A := '2.9';
  CheckEquals('2.00000000000000000000000000000000000000000000000000000000000000', Trunc(A));
end;

end.
