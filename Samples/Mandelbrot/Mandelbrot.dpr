program Mandelbrot;

uses
  System.StartUpCopy,
  FMX.Forms,
  FMain in 'FMain.pas' {FormMain},
  Neslib.MultiPrecision in '..\..\Neslib.MultiPrecision.pas',
  MandelbrotGenerator in 'MandelbrotGenerator.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
