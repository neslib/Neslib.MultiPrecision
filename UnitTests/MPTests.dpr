program MPTests;

uses
  System.StartUpCopy,
  FMX.Forms,
  FMain in 'FMain.pas' {FormMain},
  UnitTest in 'Tests\UnitTest.pas',
  MultiPrecision.DoubleDouble.Tests in 'Tests\MultiPrecision.DoubleDouble.Tests.pas',
  Neslib.MultiPrecision in '..\Neslib.MultiPrecision.pas',
  MultiPrecision.QuadDouble.Tests in 'Tests\MultiPrecision.QuadDouble.Tests.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
