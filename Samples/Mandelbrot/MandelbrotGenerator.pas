unit MandelbrotGenerator;

{$SCOPEDENUMS ON}

interface

uses
  System.Classes;

type
  TPrecision = (Single, Double, DoubleDouble, QuadDouble);

type
  TSurface = record
  public
    Width: Integer;
    Height: Integer;
    Data: TArray<Integer>;
  end;

type
  TMandelbrotGenerator = class(TThread)
  public const
    WIDTH  = 300;
    HEIGHT = 300;
  private
    FSurface: TSurface;
    FMaxIterations: Integer;
    FMagnification: Double;
    FPrecision: TPrecision;
  private
    procedure GenerateSingle;
    procedure GenerateDouble;
    procedure GenerateDoubleDouble;
    procedure GenerateQuadDouble;
  protected
    procedure Execute; override;
  public
    constructor Create(const AMaxIterations: Integer;
      const AMagnification: Double; const APrecision: TPrecision);

    property Surface: TSurface read FSurface;
  end;

implementation

uses
  System.SysUtils,
  Neslib.MultiPrecision;

const
  CENTER_RE = '-0.00677652295833245729642263781984627256356509565412970431582937';
  CENTER_IM =  '1.00358346588202262420197968965648988617755127635794148856757956';

{ TMandelbrotGenerator }

constructor TMandelbrotGenerator.Create(const AMaxIterations: Integer;
  const AMagnification: Double; const APrecision: TPrecision);
begin
  inherited Create(False);
  FMaxIterations := AMaxIterations;
  FMagnification := AMagnification;
  FPrecision := APrecision;
  FSurface.Width := WIDTH;
  FSurface.Height := HEIGHT;
  SetLength(FSurface.Data, WIDTH * HEIGHT);
end;

procedure TMandelbrotGenerator.Execute;
begin
  case FPrecision of
    TPrecision.Single      : GenerateSingle;
    TPrecision.Double      : GenerateDouble;
    TPrecision.DoubleDouble: GenerateDoubleDouble;
    TPrecision.QuadDouble  : GenerateQuadDouble;
  end;
end;

procedure TMandelbrotGenerator.GenerateDouble;
var
  CenterRe, CenterIm, Radius, XStart, YStart, X, Y, Step: Double;
  ZRe, ZIm, ZReSq, ZImSq, NewIm: Double;
  Row, Col, Iter, MaxIter: Integer;
  Data: PInteger;
begin
  CenterRe := StrToFloat(CENTER_RE);
  CenterIm := StrToFloat(CENTER_IM);
  Radius := 2.5 / FMagnification;
  MaxIter := FMaxIterations;

  XStart := CenterRe - (Radius * 0.5);
  YStart := CenterIm - (Radius * 0.5);

  Step := Radius / FSurface.Width;
  Data := @FSurface.Data[0];

  for Row := 0 to FSurface.Height - 1 do
  begin
    Y := YStart + (Row * Step);
    for Col := 0 to FSurface.Width - 1 do
    begin
      X := XStart + (Col * Step);

      ZRe := X;
      ZIm := Y;
      Iter := 0;
      while (Iter < MaxIter) do
      begin
        ZReSq := ZRe * ZRe;
        ZImSq := ZIm * ZIm;
        if ((ZReSq + ZImSq) > 4) then
          Break;

        NewIm := 2 * ZRe * ZIm;

        ZRe := X + (ZReSq - ZImSq);
        ZIm := Y + NewIm;

        Inc(Iter);
      end;

      if (Iter = MaxIter) then
        Data^ := -1
      else
        Data^ := Iter;
      Inc(Data);

      if (Terminated) then
        Exit;
    end;
  end;
end;

procedure TMandelbrotGenerator.GenerateDoubleDouble;
var
  CenterRe, CenterIm, Radius, XStart, YStart, X, Y, Step: DoubleDouble;
  ZRe, ZIm, ZReSq, ZImSq, NewIm: DoubleDouble;
  Row, Col, Iter, MaxIter: Integer;
  Data: PInteger;
begin
  MultiPrecisionInit;
  CenterRe := CENTER_RE;
  CenterIm := CENTER_IM;
  Radius := Divide(2.5, FMagnification);
  MaxIter := FMaxIterations;

  XStart := CenterRe - (Radius * 0.5);
  YStart := CenterIm - (Radius * 0.5);

  Step := Radius / FSurface.Width;
  Data := @FSurface.Data[0];

  for Row := 0 to FSurface.Height - 1 do
  begin
    Y := YStart + (Row * Step);
    for Col := 0 to FSurface.Width - 1 do
    begin
      X := XStart + (Col * Step);

      ZRe := X;
      ZIm := Y;
      Iter := 0;
      while (Iter < MaxIter) do
      begin
        ZReSq := ZRe * ZRe;
        ZImSq := ZIm * ZIm;
        if ((ZReSq + ZImSq).ToDouble > 4) then
          Break;

        NewIm := 2 * ZRe * ZIm;

        ZRe := X + (ZReSq - ZImSq);
        ZIm := Y + NewIm;

        Inc(Iter);
      end;

      if (Iter = MaxIter) then
        Data^ := -1
      else
        Data^ := Iter;
      Inc(Data);

      if (Terminated) then
        Exit;
    end;
  end;
end;

procedure TMandelbrotGenerator.GenerateQuadDouble;
var
  CenterRe, CenterIm, Radius, XStart, YStart, X, Y, Step: QuadDouble;
  ZRe, ZIm, ZReSq, ZImSq, NewIm: QuadDouble;
  Row, Col, Iter, MaxIter: Integer;
  Data: PInteger;
begin
  MultiPrecisionInit;
  CenterRe := CENTER_RE;
  CenterIm := CENTER_IM;
  Radius.Init(2.5 / FMagnification);
  MaxIter := FMaxIterations;

  XStart := CenterRe - (Radius * 0.5);
  YStart := CenterIm - (Radius * 0.5);

  Step := Radius / FSurface.Width;
  Data := @FSurface.Data[0];

  for Row := 0 to FSurface.Height - 1 do
  begin
    Y := YStart + (Row * Step);
    for Col := 0 to FSurface.Width - 1 do
    begin
      X := XStart + (Col * Step);

      ZRe := X;
      ZIm := Y;
      Iter := 0;
      while (Iter < MaxIter) do
      begin
        ZReSq := ZRe * ZRe;
        ZImSq := ZIm * ZIm;
        if ((ZReSq + ZImSq).ToDouble > 4) then
          Break;

        NewIm := 2 * ZRe * ZIm;

        ZRe := X + (ZReSq - ZImSq);
        ZIm := Y + NewIm;

        Inc(Iter);
      end;

      if (Iter = MaxIter) then
        Data^ := -1
      else
        Data^ := Iter;
      Inc(Data);

      if (Terminated) then
        Exit;
    end;
  end;
end;

procedure TMandelbrotGenerator.GenerateSingle;
var
  CenterRe, CenterIm, Radius, XStart, YStart, X, Y, Step: Single;
  ZRe, ZIm, ZReSq, ZImSq, NewIm: Single;
  Row, Col, Iter, MaxIter: Integer;
  Data: PInteger;
begin
  CenterRe := StrToFloat(CENTER_RE);
  CenterIm := StrToFloat(CENTER_IM);
  Radius := 2.5 / FMagnification;
  MaxIter := FMaxIterations;

  XStart := CenterRe - (Radius * 0.5);
  YStart := CenterIm - (Radius * 0.5);

  Step := Radius / FSurface.Width;
  Data := @FSurface.Data[0];

  for Row := 0 to FSurface.Height - 1 do
  begin
    Y := YStart + (Row * Step);
    for Col := 0 to FSurface.Width - 1 do
    begin
      X := XStart + (Col * Step);

      ZRe := X;
      ZIm := Y;
      Iter := 0;
      while (Iter < MaxIter) do
      begin
        ZReSq := ZRe * ZRe;
        ZImSq := ZIm * ZIm;
        if ((ZReSq + ZImSq) > 4) then
          Break;

        NewIm := 2 * ZRe * ZIm;

        ZRe := X + (ZReSq - ZImSq);
        ZIm := Y + NewIm;

        Inc(Iter);
      end;

      if (Iter = MaxIter) then
        Data^ := -1
      else
        Data^ := Iter;
      Inc(Data);

      if (Terminated) then
        Exit;
    end;
  end;
end;

end.
