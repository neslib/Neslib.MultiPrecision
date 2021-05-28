unit UnitTest;

interface

uses
  System.SysUtils,
  System.Messaging,
  System.Math.Vectors;

type
  TTestFailedMessage = class(TMessage)
  {$REGION 'Internal Declarations'}
  private
    FTestClassName: String;
    FTestMethodName: String;
    FMessage: String;
  {$ENDREGION 'Internal Declarations'}
  public
    constructor Create(const ATestClassName, ATestMethodName, AMessage: String);

    property TestClassName: String read FTestClassName;
    property TestMethodName: String read FTestMethodName;
    property Message: String read FMessage;
  end;

type
  {$M+}
  TUnitTest = class
  {$REGION 'Internal Declarations'}
  private
    FCurrentTestMethodName: String;
    FChecksPassed: Integer;
    FChecksFailed: Integer;
    FChecksTotal: Integer;
  {$ENDREGION 'Internal Declarations'}
  protected
    procedure Fail(const AMsg: String); overload;
    procedure Fail(const AMsg: String; const AArgs: array of const); overload;
    procedure CheckEquals(const AExpected, AActual: String;
      const AMsg: String = ''); overload;
    procedure CheckEquals(const AExpected, AActual, AEpsilon: Double;
      const AMsg: String = ''); overload;
    procedure CheckTrue(const ACondition: Boolean);
    procedure CheckFalse(const ACondition: Boolean);
    procedure ShouldRaise(const AExceptionClass: ExceptClass;
      const AProc: TProc);
  public
    constructor Create; virtual;
    procedure Run;

    property ChecksPassed: Integer read FChecksPassed;
    property ChecksFailed: Integer read FChecksFailed;
  end;
  TUnitTestClass = class of TUnitTest;
  {$M-}

var
  USFormatSettings: TFormatSettings;

implementation

uses
  System.Math,
  System.Rtti,
  System.TypInfo;

{ TTestFailedMessage }

constructor TTestFailedMessage.Create(const ATestClassName, ATestMethodName,
  AMessage: String);
begin
  inherited Create;
  FTestClassName := ATestClassName;
  FTestMethodName := ATestMethodName;
  FMessage := AMessage;
end;

{ TUnitTest }

procedure TUnitTest.CheckEquals(const AExpected, AActual, AMsg: String);
begin
  Inc(FChecksTotal);
  if (AExpected <> AActual) then
    Fail('%s: Expected: %s, Actual: %s', [AMsg, AExpected, AActual]);
end;

procedure TUnitTest.CheckEquals(const AExpected, AActual, AEpsilon: Double;
  const AMsg: String);
var
  ExpectedIsExtreme, ActualIsExtreme, OK: Boolean;
begin
  Inc(FChecksTotal);

  { FastMath treats all extreme values (Infinite and Nan) the same. }
  ExpectedIsExtreme := IsInfinite(AExpected) or IsNan(AExpected);
  ActualIsExtreme := IsInfinite(AActual) or IsNan(AActual);
  if (ExpectedIsExtreme) then
    OK := ActualIsExtreme
  else if (ActualIsExtreme) then
    OK := ExpectedIsExtreme
  else if (AEpsilon = 0) then
    OK := SameValue(AExpected, AActual)
  else
    OK := (Abs(AExpected - AActual) <= AEpsilon);

  if (not OK) then
    Fail('%s: Expected: %.6f, Actual: %.6f', [AMsg, AExpected, AActual]);
end;

procedure TUnitTest.CheckFalse(const ACondition: Boolean);
begin
  Inc(FChecksTotal);
  if (ACondition) then
    Fail('Expected False but was True');
end;

procedure TUnitTest.CheckTrue(const ACondition: Boolean);
begin
  Inc(FChecksTotal);
  if (not ACondition) then
    Fail('Expected True but was False');
end;

constructor TUnitTest.Create;
begin
  inherited;
end;

procedure TUnitTest.Fail(const AMsg: String; const AArgs: array of const);
begin
  Fail(Format(AMsg, AArgs));
end;

procedure TUnitTest.Fail(const AMsg: String);
begin
  Inc(FChecksFailed);
  TMessageManager.DefaultManager.SendMessage(Self,
    TTestFailedMessage.Create(ClassName, FCurrentTestMethodName, AMsg));
end;

procedure TUnitTest.Run;
var
  Context: TRttiContext;
  TestType: TRttiType;
  Method: TRttiMethod;
begin
  FChecksPassed := 0;
  FChecksFailed := 0;
  FChecksTotal := 0;
  FCurrentTestMethodName := '';
  Context := TRttiContext.Create;
  TestType := Context.GetType(ClassType);
  if (TestType = nil) then
    Fail('Internal test error: cannot get test class type');

  for Method in TestType.GetMethods do
  begin
    if (Method.Visibility = TMemberVisibility.mvPublished)
      and (Method.ReturnType = nil) and (Method.GetParameters = nil)
      and (not Method.IsConstructor) and (not Method.IsDestructor)
      and (not Method.IsClassMethod) and (not Method.IsStatic) then
    begin
      FCurrentTestMethodName := Method.Name;
      try
        Method.Invoke(Self, []);
      except
        on E: Exception do
          Fail('Unexpected exception of type "%s"', [E.ClassName]);
      end;
    end;
  end;
  FChecksPassed := FChecksTotal - FChecksFailed;
end;

procedure TUnitTest.ShouldRaise(const AExceptionClass: ExceptClass;
  const AProc: TProc);
begin
  try
    AProc();
  except
    on E: Exception do
    begin
      if (E.ClassType = AExceptionClass) then
        Exit
      else
        Fail('Expected exception of type "%s", but got exception of type "%s"',
          [AExceptionClass.ClassName, E.ClassName]);
    end;
  end;
  Fail('Expected exception of type "%s"', [AExceptionClass.ClassName]);
end;

initialization
  USFormatSettings := TFormatSettings.Create('en-US');
  USFormatSettings.ThousandSeparator := ',';
  USFormatSettings.DecimalSeparator := '.';

end.
