unit FMain;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Messaging,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.ScrollBox,
  FMX.Memo,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Layouts,
  FMX.Memo.Types,
  UnitTest,
  Neslib.MultiPrecision,
  MultiPrecision.DoubleDouble.Tests,
  MultiPrecision.QuadDouble.Tests;

type
  TFormMain = class(TForm)
    ButtonUnitTests: TButton;
    Memo: TMemo;
    procedure ButtonUnitTestsClick(Sender: TObject);
  private
    { Private declarations }
    procedure TestFailedListener(const Sender: TObject; const M: TMessage);
    procedure ScrollToEnd;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  FormMain: TFormMain;

const
  UNIT_TESTS: array [0..1] of TUnitTestClass = (
    TTestDoubleDouble, TTestQuadDouble);

implementation

uses
  System.Math,
  System.IOUtils;

{$R *.fmx}

{ TFormMain }

procedure TFormMain.ButtonUnitTestsClick(Sender: TObject);
var
  UnitTestClass: TUnitTestClass;
  UnitTest: TUnitTest;
  NumFailed, NumPassed: Integer;
begin
  Memo.Lines.Clear;
  ButtonUnitTests.Enabled := False;
  try
    NumFailed := 0;
    NumPassed := 0;
    for UnitTestClass in UNIT_TESTS do
    begin
      UnitTest := UnitTestClass.Create;
      try
        UnitTest.Run;
        Inc(NumFailed, UnitTest.ChecksFailed);
        Inc(NumPassed, UnitTest.ChecksPassed);
      finally
        UnitTest.Free;
      end;
    end;
    Memo.Lines.Add(Format('%d checks completed. %d passed, %d failed',
      [NumPassed + NumFailed, NumPassed, NumFailed]));
  finally
    ButtonUnitTests.Enabled := True;
  end;
end;

constructor TFormMain.Create(AOwner: TComponent);
begin
  inherited;
  ReportMemoryLeaksOnShutdown := True;
  MultiPrecisionInit;
  TMessageManager.DefaultManager.SubscribeToMessage(TTestFailedMessage, TestFailedListener);
end;

destructor TFormMain.Destroy;
begin
  TMessageManager.DefaultManager.Unsubscribe(TTestFailedMessage, TestFailedListener);
  inherited;
end;

procedure TFormMain.ScrollToEnd;
begin
  Memo.SelStart := Memo.Text.Length;
end;

procedure TFormMain.TestFailedListener(const Sender: TObject;
  const M: TMessage);
var
  FailedMsg: TTestFailedMessage absolute M;
begin
  Assert(M is TTestFailedMessage);
  Memo.Lines.Add(Format('%s.%s: %s',
    [FailedMsg.TestClassName, FailedMsg.TestMethodName, FailedMsg.Message]));
  ScrollToEnd;
  Application.ProcessMessages;
end;

end.
