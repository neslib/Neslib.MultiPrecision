unit FMain;

interface

uses
  System.Math,
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Diagnostics,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Objects,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Layouts,
  FMX.ListBox,
  FMX.Edit,
  FMX.EditBox,
  FMX.SpinBox,
  MandelbrotGenerator;

const
  PALETTE_BITS = 7;
  PALETTE_SIZE = 1 shl PALETTE_BITS;
  PALETTE_MASK = PALETTE_SIZE - 1;

type
  TFormMain = class(TForm)
    PaintBox: TPaintBox;
    LayoutOptions: TLayout;
    LabelPrecision: TLabel;
    ComboBoxPrecision: TComboBox;
    ComboBoxMagnification: TComboBox;
    LabelMagnification: TLabel;
    ButtonUpdateOrCancel: TButton;
    LabelGradientOffset: TLabel;
    LabelTime: TLabel;
    TrackBarGradientOffset: TTrackBar;
    TimerUpdate: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBoxPaint(Sender: TObject; Canvas: TCanvas);
    procedure ButtonUpdateOrCancelClick(Sender: TObject);
    procedure TrackBarGradientOffsetChange(Sender: TObject);
    procedure PaintBoxClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerUpdateTimer(Sender: TObject);
  private
    { Private declarations }
    FPalette: array [0..PALETTE_SIZE - 1] of TAlphaColor;
    FBitmap: TBitmap;
    FGenerator: TMandelbrotGenerator;
    FSurface: TSurface;
    FStopwatch: TStopwatch;
    FOrigOptionsWidth: Single;
    procedure CreatePalette;
    procedure Update;
    procedure UpdateStats;
    procedure UpdateDisplay;
    procedure EnableControls(const Enable: Boolean);
    procedure Generate(const APrecision: TPrecision;
      const AMagnification: Double; const AMaxIterations: Integer);
    procedure GeneratorTerminate(Sender: TObject);
    procedure ShutdownGenerator;
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.fmx}
{$R palette.res}

procedure TFormMain.ButtonUpdateOrCancelClick(Sender: TObject);
begin
  if (ButtonUpdateOrCancel.Text = 'Update') then
    Update
  else
    ShutdownGenerator;
end;

procedure TFormMain.CreatePalette;
var
  Stream: TStream;
  Palette: array [0..PALETTE_SIZE * 3 - 1] of Byte;
  I: Integer;
  C: TAlphaColorRec;
begin
  Stream := TResourceStream.Create(HInstance, 'PALETTE', RT_RCDATA);
  try
    Assert(Stream.Size = Length(Palette));
    Stream.ReadBuffer(Palette[0], Length(Palette));
  finally
    Stream.Free;
  end;
  for I := 0 to PALETTE_SIZE - 1 do
  begin
    {$IFDEF MSWINDOWS}
    C.R := Palette[I * 3 + 0];
    C.G := Palette[I * 3 + 1];
    C.B := Palette[I * 3 + 2];
    {$ELSE}
    C.R := Palette[I * 3 + 2];
    C.G := Palette[I * 3 + 1];
    C.B := Palette[I * 3 + 0];
    {$ENDIF}
    C.A := 255;
    FPalette[I] := C.Color;
  end;
end;

procedure TFormMain.EnableControls(const Enable: Boolean);
begin
  LabelPrecision.Enabled := Enable;
  ComboBoxPrecision.Enabled := Enable;

  LabelMagnification.Enabled := Enable;
  ComboBoxMagnification.Enabled := Enable;

  if (Enable) then
    ButtonUpdateOrCancel.Text := 'Update'
  else
    ButtonUpdateOrCancel.Text := 'Cancel';
end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ShutdownGenerator;
end;

procedure TFormMain.FormCreate(Sender: TObject);
var
  I: Integer;
  S: String;
begin
  { To test the use of TFormatSettings, set the default format settings to a
    non-English locale. }
  FormatSettings.DecimalSeparator := ',';
  FormatSettings.ThousandSeparator := '.';

  FBitmap := TBitmap.Create;
  FBitmap.SetSize(TMandelbrotGenerator.WIDTH, TMandelbrotGenerator.HEIGHT);
  FOrigOptionsWidth := LayoutOptions.Width;
  CreatePalette;

  ComboBoxMagnification.Items.BeginUpdate;
  try
    ComboBoxMagnification.Items.Add('1');
    for I := 1 to 38 do
    begin
      S := '1e' + I.ToString;
      if (I = 6) then
        S := S + ' (need Double)'
      else if (I = 14) then
        S := S + ' (need DoubleDouble)'
      else if (I = 31) then
        S := S + ' (need QuadDouble)';
      ComboBoxMagnification.Items.Add(S)
    end;
  finally
    ComboBoxMagnification.Items.EndUpdate;
  end;
  ComboBoxMagnification.ItemIndex := 0;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  FBitmap.Free;
end;

procedure TFormMain.FormResize(Sender: TObject);
begin
  if (ClientWidth > ClientHeight) then
  begin
    { Landscape }
    LayoutOptions.Align := TAlignLayout.Left;
    LayoutOptions.Width := FOrigOptionsWidth;
  end
  else
  begin
    { Portrait }
    LayoutOptions.Align := TAlignLayout.Top;
    LayoutOptions.Height := TrackBarGradientOffset.Position.Y +
      TrackBarGradientOffset.Height + LabelTime.Height + 16;
  end;
end;

procedure TFormMain.Generate(const APrecision: TPrecision;
  const AMagnification: Double; const AMaxIterations: Integer);
begin
  ShutdownGenerator;
  EnableControls(False);

  FBitmap.Clear(TAlphaColors.Black);
  FStopwatch := TStopwatch.StartNew;

  FGenerator := TMandelbrotGenerator.Create(AMaxIterations, AMagnification,
    APrecision);
  FGenerator.OnTerminate := GeneratorTerminate;
  FSurface := FGenerator.Surface;

  UpdateStats;
  UpdateDisplay;
  TimerUpdate.Enabled := True;
end;

procedure TFormMain.GeneratorTerminate(Sender: TObject);
begin
  TimerUpdate.Enabled := False;

  UpdateStats;
  UpdateDisplay;
  EnableControls(True);

  FGenerator := nil;
end;

procedure TFormMain.PaintBoxClick(Sender: TObject);
begin
  {$IF Defined(DEBUG) and Defined(MSWINDOWS)}
  { Switch between portrait and landscape layout }
  SetBounds(Left, Top, Height, Width);
  {$ENDIF}
end;

procedure TFormMain.PaintBoxPaint(Sender: TObject; Canvas: TCanvas);
var
  SR, DR: TRectF;
begin
  if (FBitmap <> nil) then
  begin
    SR := RectF(0, 0, FBitmap.Width, FBitmap.Height);
    DR := RectF(0, 0, PaintBox.Width, PaintBox.Height);
    DR := SR.CenterAt(DR);
    Canvas.DrawBitmap(FBitmap, SR, DR, 1);
  end;
end;

procedure TFormMain.ShutdownGenerator;
begin
  if (FGenerator <> nil) then
  begin
    FGenerator.Terminate;
    FGenerator.WaitFor;
    FGenerator.Free;
    FGenerator := nil;
  end;
end;

procedure TFormMain.TimerUpdateTimer(Sender: TObject);
begin
  UpdateStats;
  UpdateDisplay;
end;

procedure TFormMain.TrackBarGradientOffsetChange(Sender: TObject);
begin
  LabelGradientOffset.Text := Format('Gradient offset: %.0f', [TrackBarGradientOffset.Value]);
  UpdateDisplay;
end;

procedure TFormMain.Update;
var
  Magnification: Double;
  Precision: TPrecision;
  Iterations: Integer;
begin
  case ComboBoxPrecision.ItemIndex of
    0: Precision := TPrecision.Single;
    1: Precision := TPrecision.Double;
    2: Precision := TPrecision.DoubleDouble;
    3: Precision := TPrecision.QuadDouble;
  else
    Assert(False);
    Precision := TPrecision.Single;
  end;

  Magnification := Power(10, ComboBoxMagnification.ItemIndex);

  if (Magnification >= 1e11) then
    Iterations := 5000
  else if (Magnification >= 1e10) then
    Iterations := 1000
  else
    Iterations := 200;

  Generate(Precision, Magnification, Iterations);
end;

procedure TFormMain.UpdateDisplay;
var
  Data: TBitmapData;
  X, Y, PaletteOffset: Integer;
  Iter: PInteger;
  Dst: PAlphaColor;
begin
  if (FSurface.Data <> nil) and (FBitmap.Map(TMapAccess.Write, Data)) then
  try
    PaletteOffset := System.Trunc(TrackBarGradientOffset.Value);
    Iter := @FSurface.Data[0];
    for Y := 0 to Data.Height - 1 do
    begin
      Dst := Data.GetScanline(Y);
      for X := 0 to Data.Width - 1 do
      begin
        if (Iter^ < 0) then
          Dst^ := TAlphaColors.Black
        else
          Dst^ := FPalette[(Iter^ + PaletteOffset) and PALETTE_MASK];

        Inc(Iter);
        Inc(Dst);
      end;
    end;
  finally
    FBitmap.Unmap(Data);
  end;

  PaintBox.Repaint;
end;

procedure TFormMain.UpdateStats;
var
  Seconds: Double;
begin
  Seconds := FStopwatch.Elapsed.TotalSeconds;
  LabelTime.Text := Format('Elapsed: %.3f seconds', [Seconds]);
end;

end.
