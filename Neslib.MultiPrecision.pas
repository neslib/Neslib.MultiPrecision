unit Neslib.MultiPrecision;
{ Multi-precision floating-point library.
  Uses QD 2.3.22 (https://www.davidhbailey.com/dhbsoftware/)

  Adds support for 128-bit (DoubleDouble) and 256-bit (QuadDouble) floating-
  point types.

  These types offer the same range as the Double type (+/- 10e308) but a lot
  more precision (2 and 4 times more):

  Type          Exponent Bits   Mantissa Bits   #Decimal digits (precision)
  -------------------------------------------------------------------------
  Single               9             24               7
  Double              12             53              16
  DoubleDouble        12            106              32
  QuadDouble          12            212              64

  The underlying QD library does not use emulation for calculations. Instead, it
  uses the existing floating-point capabilities of the CPU to use either 2 or 4
  Double values to increase the precision. As a result, these types are much
  faster than other arbitrary/high precision math libraries using the same
  precision. Also, as opposed to many other libraries, these types don't require
  dynamic memory allocations, which further helps performance and also reduces
  memory fragmentation.

  Customization
  -------------
  The default configuration of the library is suitable for most applications.
  This configuration sacrifices a bit of accuracy for increase speed. If
  accuracy is more important than speed for your purposes, then you can compile
  the library with the MP_ACCURATE define. This will make many calculations a
  bit slower but more accurate. }

{$SCOPEDENUMS ON}

interface

uses
  System.SysUtils,
  System.Math;

{ Initializes the system to work with the DoubleDouble and QuadDouble types.

  Returns:
    The old FPU/SSE state.

  You *must* call this function before doing any multi-precision math. It sets
  the correct precision mode and disables floating-point exceptions.

  You can call MultiPrecisionReset to restore the FPU/SSE to the previous state
  by passing the value returned from this function. }
function MultiPrecisionInit: UInt32;

{ Resets the FPU/SSE state.

  Parameters:
    AState: the FPU/SSE state as returned by a previous call to
    MultiPrecisionInit }
procedure MultiPrecisionReset(const AState: UInt32);

type
  { Formats used for converting a multi-precision floating-point value to a
    string. }
  TMPFloatFormat = (
    { Fixed format }
    Fixed,

    { Scientific format }
    Scientific);

type
  { 128-bit floating-point type, comprised of two double-precision
    floating-point values. Can be used much like a regular Double value.
    Offers a range of +/- 10e308 and precision of approximately 32 decimal
    digits. }
  DoubleDouble = record
  public
    { The 2 double-precision floating-point values making up this value. }
    X: array [0..1] of Double;
  {$REGION 'Internal Declarations'}
  private
    function GetSign: Boolean; inline;
    procedure SetSign(const Value: Boolean); inline;
    function GetExp: UInt64; inline;
    procedure SetExp(const Value: UInt64); inline;
    function GetSpecialType: TFloatSpecial; inline;
  private
    procedure ToDigits(const S: TArray<Char>; var Exponent: Integer;
      const Precision: Integer);
  {$ENDREGION 'Internal Declarations'}
  public
    { Various ways to explicitly initialize a DoubleDouble value.

      Parameters:
        Value: the Double value to convert to a DoubleDouble.
        Hi, Lo: the two Double values that make up this DoubleDouble.
        S: a string representation of the DoubleDouble floating-point value.
          Uses the system-wide format settings if FormatSettings is not
          specified.
        FormatSettings: the format settings used for the string S }
    procedure Init; overload; inline;
    procedure Init(const Value: Double); overload; inline;
    procedure Init(const Hi, Lo: Double); overload; inline;
    procedure Init(const S: String); overload; inline;
    procedure Init(const S: String; const FormatSettings: TFormatSettings); overload;

    { Clears the value to 0 (alias for Init without parameters) }
    procedure Clear; inline;

    { Implicitly converts a string to a DoubleDouble.
      The string *must* use the period ('.') as a decimal separator. }
    class operator Implicit(const S: String): DoubleDouble; inline; static;

    // *NO* implicit conversions from Double to DoubleDouble, to avoid
    // unintentional conversions that may impact performance.
    //class operator Implicit(const Value: Double): DoubleDouble; inline; static;

    { Explicit conversion from a Double to a DoubleDouble. }
    class operator Explicit(const Value: Double): DoubleDouble; inline; static;

    { Equality operators.
      Used to compare DoubleDouble values with Double or other DoubleDouble
      values. }
    class operator Equal(const A, B: DoubleDouble): Boolean; inline; static;
    class operator Equal(const A: DoubleDouble; const B: Double): Boolean; inline; static;
    class operator Equal(const A: Double; const B: DoubleDouble): Boolean; inline; static;
    class operator NotEqual(const A, B: DoubleDouble): Boolean; inline; static;
    class operator NotEqual(const A: DoubleDouble; const B: Double): Boolean; inline; static;
    class operator NotEqual(const A: Double; const B: DoubleDouble): Boolean; inline; static;
    class operator LessThan(const A, B: DoubleDouble): Boolean; inline; static;
    class operator LessThan(const A: DoubleDouble; const B: Double): Boolean; inline; static;
    class operator LessThan(const A: Double; const B: DoubleDouble): Boolean; inline; static;
    class operator LessThanOrEqual(const A, B: DoubleDouble): Boolean; inline; static;
    class operator LessThanOrEqual(const A: DoubleDouble; const B: Double): Boolean; inline; static;
    class operator LessThanOrEqual(const A: Double; const B: DoubleDouble): Boolean; inline; static;
    class operator GreaterThan(const A, B: DoubleDouble): Boolean; inline; static;
    class operator GreaterThan(const A: DoubleDouble; const B: Double): Boolean; inline; static;
    class operator GreaterThan(const A: Double; const B: DoubleDouble): Boolean; inline; static;
    class operator GreaterThanOrEqual(const A, B: DoubleDouble): Boolean; inline; static;
    class operator GreaterThanOrEqual(const A: DoubleDouble; const B: Double): Boolean; inline; static;
    class operator GreaterThanOrEqual(const A: Double; const B: DoubleDouble): Boolean; inline; static;

    { Aritmethic operators.
      You can mix and match Double and DoubleDouble values. }
    class operator Negative(const A: DoubleDouble): DoubleDouble; inline; static;

    class operator Add(const A, B: DoubleDouble): DoubleDouble; inline; static;
    class operator Add(const A: Double; const B: DoubleDouble): DoubleDouble; inline; static;
    class operator Add(const A: DoubleDouble; const B: Double): DoubleDouble; inline; static;

    class operator Subtract(const A, B: DoubleDouble): DoubleDouble; inline; static;
    class operator Subtract(const A: Double; const B: DoubleDouble): DoubleDouble; inline; static;
    class operator Subtract(const A: DoubleDouble; const B: Double): DoubleDouble; inline; static;

    class operator Multiply(const A, B: DoubleDouble): DoubleDouble; inline; static;
    class operator Multiply(const A: Double; const B: DoubleDouble): DoubleDouble; inline; static;
    class operator Multiply(const A: DoubleDouble; const B: Double): DoubleDouble; inline; static;

    class operator Divide(const A, B: DoubleDouble): DoubleDouble; inline; static;
    class operator Divide(const A: Double; const B: DoubleDouble): DoubleDouble; inline; static;
    class operator Divide(const A: DoubleDouble; const B: Double): DoubleDouble; inline; static;

    { Whether this value equals 0.
      This is a bit faster than comparing against 0. }
    function IsZero: Boolean; inline;

    { Whether this value equals 1.
      This is a bit faster than comparing against 1. }
    function IsOne: Boolean; inline;

    { Whether this value is positive.
      This is a bit faster than comparing against > 0. }
    function IsPositive: Boolean; inline;

    { Whether this value is negative.
      This is a bit faster than comparing against < 0. }
    function IsNegative: Boolean; inline;

    { Whether this value is Not-a-Number }
    function IsNan: Boolean; inline;

    { Whether this value is infinite (positive or negative) }
    function IsInfinity: Boolean; inline;

    { Whether this value is negative infinite }
    function IsNegativeInfinity: Boolean; overload; inline;

    { Whether this value is positive infinite }
    function IsPositiveInfinity: Boolean; overload; inline;

    { Compares against another Double or DoubleDouble value.
      Returns True if equal, or False otherwise. }
    function Equals(const A: DoubleDouble): Boolean; overload; inline;
    function Equals(const A: Double): Boolean; overload; inline;

    { Converts this DoubleDouble value to an Integer }
    function ToInteger: Integer; inline;

    { Converts this DoubleDouble value to a Double }
    function ToDouble: Double; inline;

    { Converts this DoubleDouble value to a String.

      Parameters:
        FormatSettings: (optional) the format settings to use (mostly for the
          decimal separator).
        Format: (optional) output format. Either Fixed or Scientific.
        Precision: (optional) number of digits in the output. Defaults to 31
          (the maximum appropriate precision for a DoubleDouble value). }
    function ToString(const Format: TMPFloatFormat = TMPFloatFormat.Scientific;
      const Precision: Integer = 31): String; overload; inline;
    function ToString(const FormatSettings: TFormatSettings;
      const Format: TMPFloatFormat = TMPFloatFormat.Scientific;
      const Precision: Integer = 31): String; overload;

    { Converts a DoubleDouble value to a String.

      Parameters:
        Value: the DoubleDouble value to convert.
        FormatSettings: (optional) the format settings to use (mostly for the
          decimal separator).
        Format: (optional) output format. Either Fixed or Scientific.
        Precision: (optional) number of digits in the output. Defaults to 31
          (the maximum appropriate precision for a DoubleDouble value). }
    class function ToString(const Value: DoubleDouble;
      const Format: TMPFloatFormat = TMPFloatFormat.Scientific;
      const Precision: Integer = 31): String; overload; inline; static;
    class function ToString(const Value: DoubleDouble;
      const FormatSettings: TFormatSettings;
      const Format: TMPFloatFormat = TMPFloatFormat.Scientific;
      const Precision: Integer = 31): String; overload; inline; static;

    { Parses a string and converts it to a DoubleDouble.

      Parameters
        S: the string to parse. Uses the system-wide format settings if
          FormatSettings is not specified.
        FormatSettings: (optional) format settings to use for parsing.

      Returns:
        The converted DoubleDouble value, or DoubleDouble.NaN if the string S
        could not be converted. }
    class function Parse(const S: String): DoubleDouble; overload; inline; static;
    class function Parse(const S: String;
      const FormatSettings: TFormatSettings): DoubleDouble; overload; inline; static;

    { Tries to parse a string and convert it to a DoubleDouble.

      Parameters
        S: the string to parse. Uses the system-wide format settings if
          FormatSettings is not specified.
        Value: is set to the converted DoubleDouble value.
        FormatSettings: (optional) format settings to use for parsing.

      Returns:
        True if S was successfully converted, or False otherwise. }
    class function TryParse(const S: String; out Value: DoubleDouble): Boolean; overload; inline; static;
    class function TryParse(const S: String; out Value: DoubleDouble;
      const FormatSettings: TFormatSettings): Boolean; overload; inline; static;

    { The size of DoubleDouble values. Will always be 16. }
    class function Size: Integer; inline; static;

    { The high-order Double value used to make up this value. }
    property Hi: Double read X[0];

    { The low-order Double value used to make up this value. }
    property Lo: Double read X[1];

    { The sign of this value. True if negative, False otherwise. }
    property Sign: Boolean read GetSign write SetSign;

    { The raw exponent part }
    property Exp: UInt64 read GetExp write SetExp;

    { The type of this value. }
    property SpecialType: TFloatSpecial read GetSpecialType;
  end;
  PDoubleDouble = ^DoubleDouble;
  PPDoubleDouble = ^PDoubleDouble;

type
  { Record helper that defines some DoubleDouble constants }
  _DoubleDoubleHelper = record helper for DoubleDouble
  const
    { The number of digits of precision for DoubleDouble values }
    NumDigits = 31;

    { The upper bound on the relative error due to rounding }
    Epsilon   = 4.93038065763132e-32;

    { The minimum value of a DoubleDouble }
    MinValue  = 2.0041683600089728e-292;
  const
    { Pi }
    Pi              : DoubleDouble = (X: (3.141592653589793116e+00,
                                          1.224646799147353207e-16));
    { Pi * 2 }
    PiTimes2        : DoubleDouble = (X: (6.283185307179586232e+00,
                                          2.449293598294706414e-16));
    { Pi / 2}
    PiOver2         : DoubleDouble = (X: (1.570796326794896558e+00,
                                          6.123233995736766036e-17));
    { Pi / 4}
    PiOver4         : DoubleDouble = (X: (7.853981633974482790e-01,
                                          3.061616997868383018e-17));
    { (Pi * 3) / 4}
    PiTimes3Over4   : DoubleDouble = (X: (2.356194490192344837e+00,
                                          9.1848509936051484375e-17));
    { Pi / 180 }
    PiOver180       : DoubleDouble = (X: (0.017453292519943295e+00,
                                          2.9486522708701687e-19));
    { 180 / Pi }
    _180OverPi      : DoubleDouble = (X: (5.729577951308232e+01,
                                         -1.9878495670576283e-15));
    { e }
    E               : DoubleDouble = (X: (2.718281828459045091e+00,
                                          1.445646891729250158e-16));
    { The natural log of 2 }
    Log2            : DoubleDouble = (X: (6.931471805599452862e-01,
                                          2.319046813846299558e-17));
    { The natural log of 10 }
    Log10           : DoubleDouble = (X: (2.302585092994045901e+00,
                                         -2.170756223382249351e-16));
    { 0 }
    Zero            : DoubleDouble = (X: (0, 0));

    { 1 }
    One             : DoubleDouble = (X: (1, 0));

    { Not-a-Number }
    NaN             : DoubleDouble = (X: (NaN, NaN));

    { Positive infinity }
    PositiveInfinity: DoubleDouble = (X: (Infinity, Infinity));

    { Negative infinity }
    NegativeInfinity: DoubleDouble = (X: (NegInfinity, NegInfinity));

    { The maximum absolute value }
    MaxValue        : DoubleDouble = (X: (1.79769313486231570815e+308,
                                          9.97920154767359795037e+291));
    { A safe maximum absolute value that can be used in calculations. }
    SafeMaxValue    : DoubleDouble = (X: (1.7976931080746007281e+308,
                                          9.97920154767359795037e+291));
  end;

type
  { 256-bit floating-point type, comprised of four double-precision
    floating-point values. Can be used much like a regular Double value.
    Offers a range of +/- 10e308 and precision of approximately 64 decimal
    digits. }
  QuadDouble = record
  public
    { The 4 double-precision floating-point values making up this value. }
    X: array [0..3] of Double;
  {$REGION 'Internal Declarations'}
  private
    function GetSign: Boolean; inline;
    procedure SetSign(const Value: Boolean); inline;
    function GetExp: UInt64; inline;
    procedure SetExp(const Value: UInt64); inline;
    function GetSpecialType: TFloatSpecial; inline;
  private
    procedure ToDigits(const S: TArray<Char>; var Exponent: Integer;
      const Precision: Integer);
  {$ENDREGION 'Internal Declarations'}
  public
    { Various ways to explicitly initialize a QuadDouble value.

      Parameters:
        Value: the Double or DoubleDouble value to convert to a QuadDouble.
        X0, X1, X2, X3: the four Double values that make up this QuadDouble.
        S: a string representation of the QuadDouble floating-point value.
          Uses the system-wide format settings if FormatSettings is not
          specified.
        FormatSettings: the format settings used for the string S }
    procedure Init; overload; inline;
    procedure Init(const Value: Double); overload; inline;
    procedure Init(const Value: DoubleDouble); overload; inline;
    procedure Init(const X0, X1, X2, X3: Double); overload; inline;
    procedure Init(const S: String); overload; inline;
    procedure Init(const S: String; const FormatSettings: TFormatSettings); overload;

    { Clears the value to 0 (alias for Init without parameters) }
    procedure Clear; inline;

    { Implicitly converts a string to a DoubleDouble.
      The string *must* use the period ('.') as a decimal separator. }
    class operator Implicit(const S: String): QuadDouble; inline; static;

    // *NO* implicit conversions from Double/DoubleDouble to QuadDouble, to
    // avoid unintentional conversions that may impact performance.
    //class operator Implicit(const Value: Double): QuadDouble; inline; static;
    //class operator Implicit(const Value: DoubleDouble): QuadDouble; inline; static;

    { Explicit conversion from a Double or DoubleDouble to a QuadDouble. }
    class operator Explicit(const Value: Double): QuadDouble; inline; static;
    class operator Explicit(const Value: DoubleDouble): QuadDouble; inline; static;

    { Equality operators.
      Used to compare QuadDouble values with Double, DoubleDouble or other
      QuadDouble values. }
    class operator Equal(const A, B: QuadDouble): Boolean; inline; static;
    class operator Equal(const A: QuadDouble; const B: Double): Boolean; inline; static;
    class operator Equal(const A: Double; const B: QuadDouble): Boolean; inline; static;
    class operator Equal(const A: QuadDouble; const B: DoubleDouble): Boolean; inline; static;
    class operator Equal(const A: DoubleDouble; const B: QuadDouble): Boolean; inline; static;
    class operator NotEqual(const A, B: QuadDouble): Boolean; inline; static;
    class operator NotEqual(const A: QuadDouble; const B: Double): Boolean; inline; static;
    class operator NotEqual(const A: Double; const B: QuadDouble): Boolean; inline; static;
    class operator NotEqual(const A: QuadDouble; const B: DoubleDouble): Boolean; inline; static;
    class operator NotEqual(const A: DoubleDouble; const B: QuadDouble): Boolean; inline; static;
    class operator LessThan(const A, B: QuadDouble): Boolean; inline; static;
    class operator LessThan(const A: QuadDouble; const B: Double): Boolean; inline; static;
    class operator LessThan(const A: Double; const B: QuadDouble): Boolean; inline; static;
    class operator LessThan(const A: QuadDouble; const B: DoubleDouble): Boolean; inline; static;
    class operator LessThan(const A: DoubleDouble; const B: QuadDouble): Boolean; inline; static;
    class operator LessThanOrEqual(const A, B: QuadDouble): Boolean; inline; static;
    class operator LessThanOrEqual(const A: QuadDouble; const B: Double): Boolean; inline; static;
    class operator LessThanOrEqual(const A: Double; const B: QuadDouble): Boolean; inline; static;
    class operator LessThanOrEqual(const A: QuadDouble; const B: DoubleDouble): Boolean; inline; static;
    class operator LessThanOrEqual(const A: DoubleDouble; const B: QuadDouble): Boolean; inline; static;
    class operator GreaterThan(const A, B: QuadDouble): Boolean; inline; static;
    class operator GreaterThan(const A: QuadDouble; const B: Double): Boolean; inline; static;
    class operator GreaterThan(const A: Double; const B: QuadDouble): Boolean; inline; static;
    class operator GreaterThan(const A: QuadDouble; const B: DoubleDouble): Boolean; inline; static;
    class operator GreaterThan(const A: DoubleDouble; const B: QuadDouble): Boolean; inline; static;
    class operator GreaterThanOrEqual(const A, B: QuadDouble): Boolean; inline; static;
    class operator GreaterThanOrEqual(const A: QuadDouble; const B: Double): Boolean; inline; static;
    class operator GreaterThanOrEqual(const A: Double; const B: QuadDouble): Boolean; inline; static;
    class operator GreaterThanOrEqual(const A: QuadDouble; const B: DoubleDouble): Boolean; inline; static;
    class operator GreaterThanOrEqual(const A: DoubleDouble; const B: QuadDouble): Boolean; inline; static;

    { Aritmethic operators.
      You can mix and match Double, DoubleDouble and QuadDouble values. }
    class operator Negative(const A: QuadDouble): QuadDouble; inline; static;

    class operator Add(const A, B: QuadDouble): QuadDouble; inline; static;
    class operator Add(const A: Double; const B: QuadDouble): QuadDouble; inline; static;
    class operator Add(const A: QuadDouble; const B: Double): QuadDouble; inline; static;
    class operator Add(const A: DoubleDouble; const B: QuadDouble): QuadDouble; inline; static;
    class operator Add(const A: QuadDouble; const B: DoubleDouble): QuadDouble; inline; static;

    class operator Subtract(const A, B: QuadDouble): QuadDouble; inline; static;
    class operator Subtract(const A: Double; const B: QuadDouble): QuadDouble; inline; static;
    class operator Subtract(const A: QuadDouble; const B: Double): QuadDouble; inline; static;
    class operator Subtract(const A: DoubleDouble; const B: QuadDouble): QuadDouble; inline; static;
    class operator Subtract(const A: QuadDouble; const B: DoubleDouble): QuadDouble; inline; static;

    class operator Multiply(const A, B: QuadDouble): QuadDouble; inline; static;
    class operator Multiply(const A: Double; const B: QuadDouble): QuadDouble; inline; static;
    class operator Multiply(const A: QuadDouble; const B: Double): QuadDouble; inline; static;
    class operator Multiply(const A: DoubleDouble; const B: QuadDouble): QuadDouble; inline; static;
    class operator Multiply(const A: QuadDouble; const B: DoubleDouble): QuadDouble; inline; static;

    class operator Divide(const A, B: QuadDouble): QuadDouble; inline; static;
    class operator Divide(const A: Double; const B: QuadDouble): QuadDouble; inline; static;
    class operator Divide(const A: QuadDouble; const B: Double): QuadDouble; inline; static;
    class operator Divide(const A: DoubleDouble; const B: QuadDouble): QuadDouble; inline; static;
    class operator Divide(const A: QuadDouble; const B: DoubleDouble): QuadDouble; inline; static;

    { Whether this value equals 0.
      This is a bit faster than comparing against 0. }
    function IsZero: Boolean; inline;

    { Whether this value equals 1.
      This is a bit faster than comparing against 1. }
    function IsOne: Boolean; inline;

    { Whether this value is positive.
      This is a bit faster than comparing against > 0. }
    function IsPositive: Boolean; inline;

    { Whether this value is negative.
      This is a bit faster than comparing against < 0. }
    function IsNegative: Boolean; inline;

    { Whether this value is Not-a-Number }
    function IsNan: Boolean; inline;

    { Whether this value is infinite (positive or negative) }
    function IsInfinity: Boolean; inline;

    { Whether this value is negative infinite }
    function IsNegativeInfinity: Boolean; overload; inline;

    { Whether this value is positive infinite }
    function IsPositiveInfinity: Boolean; overload; inline;

    { Compares against another Double, DoubleDouble or QuadDouble value.
      Returns True if equal, or False otherwise. }
    function Equals(const A: QuadDouble): Boolean; overload; inline;
    function Equals(const A: DoubleDouble): Boolean; overload; inline;
    function Equals(const A: Double): Boolean; overload; inline;

    { Converts this QuadDouble value to an Integer }
    function ToInteger: Integer; inline;

    { Converts this QuadDouble value to a Double }
    function ToDouble: Double; inline;

    { Converts this QuadDouble value to a DoubleDouble }
    function ToDoubleDouble: DoubleDouble; inline;

    { Converts this QuadDouble value to a String.

      Parameters:
        FormatSettings: (optional) the format settings to use (mostly for the
          decimal separator).
        Format: (optional) output format. Either Fixed or Scientific.
        Precision: (optional) number of digits in the output. Defaults to 62
          (the maximum appropriate precision for a QuadDouble value). }
    function ToString(const Format: TMPFloatFormat = TMPFloatFormat.Scientific;
      const Precision: Integer = 62): String; overload; inline;
    function ToString(const FormatSettings: TFormatSettings;
      const Format: TMPFloatFormat = TMPFloatFormat.Scientific;
      const Precision: Integer = 62): String; overload;

    { Converts a QuadDouble value to a String.

      Parameters:
        Value: the QuadDouble value to convert.
        FormatSettings: (optional) the format settings to use (mostly for the
          decimal separator).
        Format: (optional) output format. Either Fixed or Scientific.
        Precision: (optional) number of digits in the output. Defaults to 62
          (the maximum appropriate precision for a QuadDouble value). }
    class function ToString(const Value: QuadDouble;
      const Format: TMPFloatFormat = TMPFloatFormat.Scientific;
      const Precision: Integer = 62): String; overload; inline; static;
    class function ToString(const Value: QuadDouble;
      const FormatSettings: TFormatSettings;
      const Format: TMPFloatFormat = TMPFloatFormat.Scientific;
      const Precision: Integer = 62): String; overload; inline; static;

    { Parses a string and converts it to a QuadDouble.

      Parameters
        S: the string to parse. Uses the system-wide format settings if
          FormatSettings is not specified.
        FormatSettings: (optional) format settings to use for parsing.

      Returns:
        The converted QuadDouble value, or QuadDouble.NaN if the string S
        could not be converted. }
    class function Parse(const S: String): QuadDouble; overload; inline; static;
    class function Parse(const S: String;
      const FormatSettings: TFormatSettings): QuadDouble; overload; inline; static;

    { Tries to parse a string and convert it to a QuadDouble.

      Parameters
        S: the string to parse. Uses the system-wide format settings if
          FormatSettings is not specified.
        Value: is set to the converted QuadDouble value.
        FormatSettings: (optional) format settings to use for parsing.

      Returns:
        True if S was successfully converted, or False otherwise. }
    class function TryParse(const S: String; out Value: QuadDouble): Boolean; overload; inline; static;
    class function TryParse(const S: String; out Value: QuadDouble;
      const FormatSettings: TFormatSettings): Boolean; overload; inline; static;

    { The size of DoubleDouble values. Will always be 32. }
    class function Size: Integer; inline; static;

    { The sign of this value. True if negative, False otherwise. }
    property Sign: Boolean read GetSign write SetSign;

    { The raw exponent part }
    property Exp: UInt64 read GetExp write SetExp;

    { The type of this value. }
    property SpecialType: TFloatSpecial read GetSpecialType;
  end;
  PQuadDouble = ^QuadDouble;
  PPQuadDouble = ^PQuadDouble;

type
  { Record helper that defines some QuadDouble constants }
  _QuadDoubleHelper = record helper for QuadDouble
  const
    { The number of digits of precision for QuadDouble values }
    NumDigits = 62;

    { The upper bound on the relative error due to rounding }
    Epsilon   = 1.21543267145725e-63;

    { The minimum value of a QuadDouble }
    MinValue  = 1.6259745436952323e-260;
  const
    { Pi }
    Pi              : QuadDouble = (X: (3.141592653589793116e+00,
                                        1.224646799147353207e-16,
                                       -2.994769809718339666e-33,
                                        1.112454220863365282e-49));
    { Pi * 2 }
    PiTimes2        : QuadDouble = (X: (6.283185307179586232e+00,
                                        2.449293598294706414e-16,
                                       -5.989539619436679332e-33,
                                        2.224908441726730563e-49));
    { Pi / 2}
    PiOver2         : QuadDouble = (X: (1.570796326794896558e+00,
                                        6.123233995736766036e-17,
                                       -1.497384904859169833e-33,
                                        5.562271104316826408e-50));
    { Pi / 4}
    PiOver4         : QuadDouble = (X: (7.853981633974482790e-01,
                                        3.061616997868383018e-17,
                                       -7.486924524295849165e-34,
                                        2.781135552158413204e-50));
    { (Pi * 3) / 4}
    PiTimes3Over4   : QuadDouble = (X: (2.356194490192344837e+00,
                                        9.1848509936051484375e-17,
                                        3.9168984647504003225e-33,
                                       -2.5867981632704860386e-49));
    { Pi / 180 }
    PiOver180       : QuadDouble = (X: (0.017453292519943295e+00,
                                        2.9486522708701687e-19,
                                       -1.3427726813345382e-35,
                                        1.4287195201441093e-52));
    { 180 / Pi }
    _180OverPi      : QuadDouble = (X: (5.729577951308232e+01,
                                       -1.9878495670576283e-15,
                                       -1.6833394980391744e-31,
                                       -5.5659577936980826e-49));
    { e }
    E               : QuadDouble = (X: (2.718281828459045091e+00,
                                        1.445646891729250158e-16,
                                       -2.127717108038176765e-33,
                                        1.515630159841218954e-49));
    { The natural log of 2 }
    Log2            : QuadDouble = (X: (6.931471805599452862e-01,
                                        2.319046813846299558e-17,
                                        5.707708438416212066e-34,
                                       -3.582432210601811423e-50));
    { The natural log of 10 }
    Log10           : QuadDouble = (X: (2.302585092994045901e+00,
                                       -2.170756223382249351e-16,
                                       -9.984262454465776570e-33,
                                       -4.023357454450206379e-49));
    { 0 }
    Zero            : QuadDouble = (X: (0, 0, 0, 0));

    { 1 }
    One             : QuadDouble = (X: (1, 0, 0, 0));

    { Not-a-Number }
    NaN             : QuadDouble = (X: (NaN, NaN, NaN, NaN));

    { Positive infinity }
    PositiveInfinity: QuadDouble = (X: (Infinity, Infinity, Infinity, Infinity));

    { Negative infinity }
    NegativeInfinity: QuadDouble = (X: (NegInfinity, NegInfinity, NegInfinity, NegInfinity));

    { The maximum absolute value }
    MaxValue        : QuadDouble = (X: (1.79769313486231570815e+308,
                                        9.97920154767359795037e+291,
                                        5.53956966280111259858e+275,
                                        3.07507889307840487279e+259));

    { A safe maximum absolute value that can be used in calculations. }
    SafeMaxValue    : QuadDouble = (X: (1.7976931080746007281e+308,
                                        9.97920154767359795037e+291,
                                        5.53956966280111259858e+275,
                                        3.07507889307840487279e+259));
  end;

{ The 4 basic aritmetic operators (+, -, *, /) that work on two Double values
  and return a DoubleDouble result.

  Parameters:
    A: first Double value
    B: second Double value

  Returns:
    The result as a DoubleDouble. }
function Add(const A, B: Double): DoubleDouble; inline;
function Subtract(const A, B: Double): DoubleDouble; inline;
function Multiply(const A, B: Double): DoubleDouble; inline;
function Divide(const A, B: Double): DoubleDouble; inline;

{ Calculates the inverse (1 / A) of a value.

  Parameters:
    A: the value to invert

  Returns:
    The inverse }
function Inverse(const A: DoubleDouble): DoubleDouble; overload; inline;
function Inverse(const A: QuadDouble): QuadDouble; overload; inline;

{ Multiplies A with B, where B is a power of 2.

  Parameters:
    A: the first value
    B: the second value. Must be a power of 2.

  Returns:
    A * B. The return value is undefined if B is not a power of 2.

  This function is faster than the multiplication operator if B is guaranteed to
  be a power of 2. }
function MulPoT(const A: DoubleDouble; const B: Double): DoubleDouble; overload; inline;
function MulPoT(const A: QuadDouble; const B: Double): QuadDouble; overload; inline;

{ Calculates remainder of Dividend / Divisor, rounded to nearest.

  Parameters:
    Dividend: the value into which you are dividing
    Divisor: the value by which to divide Dividend

  Returns:
    The remainder of Dividend / Divisor, rounded to nearest (where
    Dividend / Divisor is rounded to nearest)

  Use FMod instead for rounding towards zero. }
function Rem(const Dividend, Divisor: DoubleDouble): DoubleDouble; overload; inline;
function Rem(const Dividend, Divisor: QuadDouble): QuadDouble; overload; inline;

{ Calculates the result of a division, including the remainder.

  Parameters:
    Dividend: the value into which you are dividing
    Divisor: the value by which to divide Dividend
    Remainder: is set to the remainder
    Result: is set to the result }
procedure DivRem(const Dividend, Divisor: DoubleDouble; out Remainder, Result: DoubleDouble); overload; inline;
function DivRem(const Dividend, Divisor: DoubleDouble; out Remainder: DoubleDouble): DoubleDouble; overload; inline;
procedure DivRem(const Dividend, Divisor: QuadDouble; out Remainder, Result: QuadDouble); overload; inline;
function DivRem(const Dividend, Divisor: QuadDouble; out Remainder: QuadDouble): QuadDouble; overload; inline;

{ Calculates remainder of Dividend / Divisor, rounded towards zero.

  Parameters:
    Dividend: the value into which you are dividing
    Divisor: the value by which to divide Dividend

  Returns:
    The remainder of Dividend / Divisor, rounded towards zero (where
    Dividend / Divisor is rounded towards zero)

  Use Rem instead for rounding to nearest. }
function FMod(const Dividend, Divisor: DoubleDouble): DoubleDouble; overload; inline;
function FMod(const Dividend, Divisor: QuadDouble): QuadDouble; overload; inline;

{ Calculates a square root.

  Parameters:
    A: the value to calculate the square root of

  Returns:
    The square root of A. }
function Sqrt(const A: DoubleDouble): DoubleDouble; overload; inline;
function Sqrt(const A: QuadDouble): QuadDouble; overload; inline;

{ Calculates a square value.

  Parameters:
    A: the value to square

  Returns:
    The square of A. }
function Sqr(const A: DoubleDouble): DoubleDouble; overload; inline;
function Sqr(const A: QuadDouble): QuadDouble; overload; inline;
procedure Sqr(const A: Double; out Result: DoubleDouble); overload; inline;

{ Truncates a value.

  Parameters:
    A: the value to truncate.

  Returns:
    The truncated value (that is, with its fraction removed) }
function Trunc(const A: DoubleDouble): DoubleDouble; overload; inline;
function Trunc(const A: QuadDouble): QuadDouble; overload; inline;

{ Rounds a value towards negative infinity.

  Parameters:
    A: the value to round down.

  Returns:
    The rounded value }
function Floor(const A: DoubleDouble): DoubleDouble; overload; inline;
function Floor(const A: QuadDouble): QuadDouble; overload; inline;

{ Rounds a value towards positive infinity.

  Parameters:
    A: the value to round up.

  Returns:
    The rounded value }
function Ceil(const A: DoubleDouble): DoubleDouble; overload; inline;
function Ceil(const A: QuadDouble): QuadDouble; overload; inline;

{ Rounds a value to its nearest integer.

  Parameters:
    A: the value to round.

  Returns:
    The rounded value

  NOTE: Unlike Delphi's built-in Round function, this version does *not* use
  Banker's rounding: when the fraction is exactly 0.5, it always rounds up
  instead of towards an even number. }
function Round(const A: DoubleDouble): DoubleDouble; overload; inline;
function Round(const A: QuadDouble): QuadDouble; overload; inline;

{ Returns the absolute value.

  Parameters:
    A: the value to take the absolute value of.

  Returns:
    The absolute value of A }
function Abs(const A: DoubleDouble): DoubleDouble; overload; inline;
function Abs(const A: QuadDouble): QuadDouble; overload; inline;

{ Calculates power of a value.

  Parameters:
    Base: the base value
    Exponent: the exponent.

  Returns:
    The Base raised to Exponent power.

  If Exponent is an integer value, then it is faster to use IntPower instead. }
function Power(const Base, Exponent: DoubleDouble): DoubleDouble; overload; inline;
function Power(const Base, Exponent: QuadDouble): QuadDouble; overload; inline;

{ Calculates power of a value, where the exponent is an integer.

  Parameters:
    Base: the base value
    Exponent: the (integer) exponent.

  Returns:
    The Base raised to Exponent power. }
function IntPower(const Base: DoubleDouble; const Exponent: Integer): DoubleDouble; overload; inline;
function IntPower(const Base: QuadDouble; const Exponent: Integer): QuadDouble; overload; inline;

{ Calculates the Nth root of a value.

  Parameters:
    A: the value to calculate the Nth root of.
    N: the root.

  Returns:
    The Nth root of A. }
function NRoot(const A: DoubleDouble; const N: Integer): DoubleDouble; overload; inline;
function NRoot(const A: QuadDouble; const N: Integer): QuadDouble; overload; inline;

{ Generate value from significand and exponent.
  Calculates A * 2^Exp.

  Parameters:
    A: the significand.
    Exp: the exponent.

  Returns:
    A * 2^Exp. }
function Ldexp(const A: DoubleDouble; const Exp: Integer): DoubleDouble; overload; inline;
function Ldexp(const A: QuadDouble; Exp: Integer): QuadDouble; overload; inline;

{ Calculates the exponential of A (e^A).

  Parameters:
    A: the value to calculate the exponential of.

  Returns:
    The exponential of A. }
function Exp(const A: DoubleDouble): DoubleDouble; overload; inline;
function Exp(const A: QuadDouble): QuadDouble; overload; inline;

{ Calculates the natural logarithm of A.

  Parameters:
    A: the value to calculate the natural logarithm of.

  Returns:
    The natural logarithm of A. }
function Ln(const A: DoubleDouble): DoubleDouble; overload; inline;
function Ln(const A: QuadDouble): QuadDouble; overload; inline;

{ Calculates the base 10 logarithm of A.

  Parameters:
    A: the value to calculate the base 10 logarithm of.

  Returns:
    The base 10 logarithm of A. }
function Log10(const A: DoubleDouble): DoubleDouble; overload; inline;
function Log10(const A: QuadDouble): QuadDouble; overload; inline;

{ Calculates the sine of the angle A, in radians.

  Parameters:
    A: the angle, in radians.

  Returns:
    The sine of A. }
function Sin(const A: DoubleDouble): DoubleDouble; overload; inline;
function Sin(const A: QuadDouble): QuadDouble; overload; inline;

{ Calculates the cosine of the angle A, in radians.

  Parameters:
    A: the angle, in radians.

  Returns:
    The cosine of A. }
function Cos(const A: DoubleDouble): DoubleDouble; overload; inline;
function Cos(const A: QuadDouble): QuadDouble; overload; inline;

{ Calculates the sine and cosine of the angle A, in radians.

  Parameters:
    A: the angle, in radians.
    SinA: is set to the sine of A.
    CosA: is set to the cosine of A.

  The procedure is faster than calculating the sine and cosine individually. }
procedure SinCos(const A: DoubleDouble; out SinA, CosA: DoubleDouble); overload; inline;
procedure SinCos(const A: QuadDouble; out SinA, CosA: QuadDouble); overload; inline;

{ Calculates the tangent of A, in radians.

  Parameters:
    A: the angle, in radians.

  Returns:
    The tangent of A. }
function Tan(const A: DoubleDouble): DoubleDouble; overload; inline;
function Tan(const A: QuadDouble): QuadDouble; overload; inline;

{ Calculates the inverse sine.

  Parameters:
    A: the value, must be between -1 and 1.

  Returns:
    The inverse sine of A, in the range [-Pi/2..Pi/2] }
function ArcSin(const A: DoubleDouble): DoubleDouble; overload; inline;
function ArcSin(const A: QuadDouble): QuadDouble; overload; inline;

{ Calculates the inverse cosine.

  Parameters:
    A: the value, must be between -1 and 1.

  Returns:
    The inverse cosine of A, in the range [0..Pi] }
function ArcCos(const A: DoubleDouble): DoubleDouble; overload; inline;
function ArcCos(const A: QuadDouble): QuadDouble; overload; inline;

{ Calculates the inverse tangent.

  Parameters:
    A: the value.

  Returns:
    The inverse tangent of A }
function ArcTan(const A: DoubleDouble): DoubleDouble; overload; inline;
function ArcTan(const A: QuadDouble): QuadDouble; overload; inline;

{ Calculates the arctangent angle and quadrant.

  Parameters:
    Y: the vertical value.
    X: the horizontal value.

  Returns:
    The value of ArcTan(Y/X) as an angle in the correct quadrant.
    return value will be in the range -Pi to Pi. }
function ArcTan2(const Y, X: DoubleDouble): DoubleDouble; overload; inline;
function ArcTan2(const Y, X: QuadDouble): QuadDouble; overload; inline;

{ Calculates the hyperbolic sine of the angle A, in radians.

  Parameters:
    A: the angle, in radians.

  Returns:
    The hyperbolic sine of A. }
function Sinh(const A: DoubleDouble): DoubleDouble; overload; inline;
function Sinh(const A: QuadDouble): QuadDouble; overload; inline;

{ Calculates the hyperbolic cosine of the angle A, in radians.

  Parameters:
    A: the angle, in radians.

  Returns:
    The hyperbolic cosine of A. }
function Cosh(const A: DoubleDouble): DoubleDouble; overload; inline;
function Cosh(const A: QuadDouble): QuadDouble; overload; inline;

{ Calculates the hyperbolic sine and cosine of the angle A, in radians.

  Parameters:
    A: the angle, in radians.
    S: is set to the hyperbolic sine of A.
    C: is set to the hyperbolic cosine of A.

  This procedure is faster than calculating the hyperbolic sine and cosine
  individually. }
procedure SinCosh(const A: DoubleDouble; out S, C: DoubleDouble); overload; inline;
procedure SinCosh(const A: QuadDouble; out S, C: QuadDouble); overload; inline;

{ Calculates the hyperbolic tangent of A, in radians.

  Parameters:
    A: the angle, in radians.

  Returns:
    The hyperbolic tangent of A. }
function Tanh(const A: DoubleDouble): DoubleDouble; overload; inline;
function Tanh(const A: QuadDouble): QuadDouble; overload; inline;

{ Calculates the inverse hyperbolic sine.

  Parameters:
    A: the value

  Returns:
    The inverse hyperbolic sine of A }
function ArcSinh(const A: DoubleDouble): DoubleDouble; overload; inline;
function ArcSinh(const A: QuadDouble): QuadDouble; overload; inline;

{ Calculates the inverse hyperbolic cosine.

  Parameters:
    A: the value

  Returns:
    The inverse hyperbolic cosine of A }
function ArcCosh(const A: DoubleDouble): DoubleDouble; overload; inline;
function ArcCosh(const A: QuadDouble): QuadDouble; overload; inline;

{ Calculates the inverse hyperbolic tangent.

  Parameters:
    A: the value

  Returns:
    The inverse hyperbolic tangent of A }
function ArcTanh(const A: DoubleDouble): DoubleDouble; overload; inline;
function ArcTanh(const A: QuadDouble): QuadDouble; overload; inline;

(****************************************************************************)
(** DoubleDouble and QuadDouble versions of common Delphi RTL functions.   **)
(****************************************************************************)

{ Converts a string to a DoubleDouble or QuadDouble.

  Parameters
    S: the string to convert. Uses the system-wide format settings if
      FormatSettings is not specified.
    FormatSettings: (optional) format settings to use for parsing.

  Returns:
    The converted DoubleDouble or QuadDouble value.

  Raises:
    EConvertError if S cannot be converted. }
function StrToDoubleDouble(const S: String): DoubleDouble; overload; inline;
function StrToDoubleDouble(const S: String;
  const FormatSettings: TFormatSettings): DoubleDouble; overload; inline;

function StrToQuadDouble(const S: String): QuadDouble; overload; inline;
function StrToQuadDouble(const S: String;
  const FormatSettings: TFormatSettings): QuadDouble; overload; inline;

{ Converts a string to a DoubleDouble or QuadDouble, and returns a default value
  in case the string cannot be converted.

  Parameters
    S: the string to convert. Uses the system-wide format settings if
      FormatSettings is not specified.
    Default: the default value to return in case S cannot be converted.
    FormatSettings: (optional) format settings to use for parsing.

  Returns:
    The converted DoubleDouble or QuadDouble value, or Default. }
function StrToDoubleDoubleDef(const S: String;
  const Default: DoubleDouble): DoubleDouble; overload; inline;
function StrToDoubleDoubleDef(const S: String; const Default: DoubleDouble;
  const FormatSettings: TFormatSettings): DoubleDouble; overload; inline;

function StrToQuadDoubleDef(const S: String;
  const Default: QuadDouble): QuadDouble; overload; inline;
function StrToQuadDoubleDef(const S: String; const Default: QuadDouble;
  const FormatSettings: TFormatSettings): QuadDouble; overload; inline;

{ Tries to convert a string to a DoubleDouble or QuadDouble.

  Parameters
    S: the string to convert. Uses the system-wide format settings if
      FormatSettings is not specified.
    Value: is set to the converted value (if possible)
    FormatSettings: (optional) format settings to use for parsing.

  Returns:
    True if S could be converted, or False otherwise. }
function TryStrToFloat(const S: string; out Value: DoubleDouble): Boolean; overload; inline;
function TryStrToFloat(const S: string; out Value: DoubleDouble;
  const FormatSettings: TFormatSettings): Boolean; overload; inline;

function TryStrToFloat(const S: string; out Value: QuadDouble): Boolean; overload; inline;
function TryStrToFloat(const S: string; out Value: QuadDouble;
  const FormatSettings: TFormatSettings): Boolean; overload; inline;

{ Converts a DoubleDouble or QuadDouble to a string.

  Parameters:
    Value: the DoubleDouble or QuadDouble value to convert.
    FormatSettings: (optional) format settings.

  Returns:
    The string representation of Value.

  The conversion uses the Fixed number format with either 31 (DoubleDouble)
  or 62 (QuadDouble) significant digits. }
function FloatToStr(const Value: DoubleDouble): String; overload; inline;
function FloatToStr(const Value: DoubleDouble;
  const FormatSettings: TFormatSettings): String; overload; inline;

function FloatToStr(const Value: QuadDouble): String; overload; inline;
function FloatToStr(const Value: QuadDouble;
  const FormatSettings: TFormatSettings): String; overload; inline;

{ Converts a DoubleDouble or QuadDouble to a string.

  Parameters:
    Value: the DoubleDouble or QuadDouble value to convert.
    Format: the output format (Fixed or Scientific)
    Precision: the number of significant digits of precision. Should be 31 or
      less for DoubleDouble, and 62 or less for QuadDouble.
    FormatSettings: (optional) format settings.

  Returns:
    The string representation of Value. }
function FloatToStrF(const Value: DoubleDouble; Format: TMPFloatFormat;
  const Precision: Integer): String; overload; inline;
function FloatToStrF(const Value: DoubleDouble; Format: TMPFloatFormat;
  const Precision: Integer; const FormatSettings: TFormatSettings): String; overload; inline;

function FloatToStrF(const Value: QuadDouble; Format: TMPFloatFormat;
  const Precision: Integer): String; overload; inline;
function FloatToStrF(const Value: QuadDouble; Format: TMPFloatFormat;
  const Precision: Integer; const FormatSettings: TFormatSettings): String; overload; inline;

{ Calculates the cotangent of the angle X, in radians.

  Parameters:
    X: the angle, in radians. Should not be 0.

  Returns:
    The cotangent of X.

  The cotangent is calculated as 1 / Tan(X).

  NOTE: Cot as an alias for Cotan }
function Cotan(const X: DoubleDouble): DoubleDouble; overload; inline;
function Cotan(const X: QuadDouble): QuadDouble; overload; inline;
function Cot(const X: DoubleDouble): DoubleDouble; overload; inline;
function Cot(const X: QuadDouble): QuadDouble; overload; inline;

{ Calculates the secant of the angle X, in radians.

  Parameters:
    X: the angle, in radians.

  Returns:
    The secant of X.

  The secant is calculated as 1 / Cos(X).

  NOTE: Sec as an alias for Secant }
function Secant(const X: DoubleDouble): DoubleDouble; overload; inline;
function Secant(const X: QuadDouble): QuadDouble; overload; inline;
function Sec(const X: DoubleDouble): DoubleDouble; overload; inline;
function Sec(const X: QuadDouble): QuadDouble; overload; inline;

{ Calculates the cosecant of the angle X, in radians.

  Parameters:
    X: the angle, in radians.

  Returns:
    The cosecant of X.

  The cosecant is calculated as 1 / Sin(X).

  NOTE: Csc as an alias for Cosecant }
function Cosecant(const X: DoubleDouble): DoubleDouble; overload; inline;
function Cosecant(const X: QuadDouble): QuadDouble; overload; inline;
function Csc(const X: DoubleDouble): DoubleDouble; overload; inline;
function Csc(const X: QuadDouble): QuadDouble; overload; inline;

{ Calculates the hyperbolic cotangent of the angle X, in radians.

  Parameters:
    X: the angle, in radians.

  Returns:
    The hyperbolic cotangent of X. }
function CotH(const X: DoubleDouble): DoubleDouble; overload; inline;
function CotH(const X: QuadDouble): QuadDouble; overload; inline;

{ Calculates the hyperbolic secant of the angle X, in radians.

  Parameters:
    X: the angle, in radians.

  Returns:
    The hyperbolic secant of X. }
function SecH(const X: DoubleDouble): DoubleDouble; overload; inline;
function SecH(const X: QuadDouble): QuadDouble; overload; inline;

{ Calculates the hyperbolic cosecant of the angle X, in radians.

  Parameters:
    X: the angle, in radians.

  Returns:
    The hyperbolic cosecant of X. }
function CscH(const X: DoubleDouble): DoubleDouble; overload; inline;
function CscH(const X: QuadDouble): QuadDouble; overload; inline;

{ Calculates the inverse cotangent of a given value.

  Parameters:
    X: the value.

  Returns:
    The inverse cotangent of X. }
function ArcCot(const X: DoubleDouble): DoubleDouble; overload;
function ArcCot(const X: QuadDouble): QuadDouble; overload;

{ Calculates the inverse secant of a given value.

  Parameters:
    X: the value.

  Returns:
    The inverse secant of X. }
function ArcSec(const X: DoubleDouble): DoubleDouble; overload;
function ArcSec(const X: QuadDouble): QuadDouble; overload;

{ Calculates the inverse cosecant of a given value.

  Parameters:
    X: the value.

  Returns:
    The inverse cosecant of X. }
function ArcCsc(const X: DoubleDouble): DoubleDouble; overload;
function ArcCsc(const X: QuadDouble): QuadDouble; overload;

{ Calculates the inverse hyperbolic cotangent of a given value.

  Parameters:
    X: the value

  Returns:
    The inverse hyperbolic cotangent of X }
function ArcCotH(const X: DoubleDouble): DoubleDouble; overload;
function ArcCotH(const X: QuadDouble): QuadDouble; overload;

{ Calculates the inverse hyperbolic secant of a given value.

  Parameters:
    X: the value

  Returns:
    The inverse hyperbolic secant of X }
function ArcSecH(const X: DoubleDouble): DoubleDouble; overload;
function ArcSecH(const X: QuadDouble): QuadDouble; overload;

{ Calculates the inverse hyperbolic cosecant of a given value.

  Parameters:
    X: the value

  Returns:
    The inverse hyperbolic cosecant of X }
function ArcCscH(const X: DoubleDouble): DoubleDouble; overload;
function ArcCscH(const X: QuadDouble): QuadDouble; overload;

{ Calculates the length of the hypotenuse of a right triangle.

  Parameters:
    X: one side adjacent to the right triangle.
    Y: other side adjacent to the right triangle.

  Returns:
    The length of the hypotenuse, calculated as Sqrt(X*X + Y*Y) }
function Hypot(const X, Y: DoubleDouble): DoubleDouble; overload;
function Hypot(const X, Y: QuadDouble): QuadDouble; overload;

{ Converts radians to degrees.

  Parameters:
    Radians: value in radians.

  Returns:
    The value in degrees.

  Degrees = Radians * 180 / Pi }
function RadToDeg(const Radians: DoubleDouble): DoubleDouble; overload; inline;
function RadToDeg(const Radians: QuadDouble): QuadDouble; overload; inline;

{ Converts radians to grads.

  Parameters:
    Radians: value in radians.

  Returns:
    The value in grads.

  Grads = Radians * (200 / Pi) }
function RadToGrad(const Radians: DoubleDouble): DoubleDouble; overload; inline;
function RadToGrad(const Radians: QuadDouble): QuadDouble; overload; inline;

{ Converts radians to cycles.

  Parameters:
    Radians: value in radians.

  Returns:
    The value in cycles.

  Cycles = Radians / (2 * Pi) }
function RadToCycle(const Radians: DoubleDouble): DoubleDouble; overload; inline;
function RadToCycle(const Radians: QuadDouble): QuadDouble; overload; inline;

{ Converts degrees to radians.

  Parameters:
    Degrees: value in degrees.

  Returns:
    The value in radians.

  Radians = Degrees * Pi / 180 }
function DegToRad(const Degrees: DoubleDouble): DoubleDouble; overload; inline;
function DegToRad(const Degrees: QuadDouble): QuadDouble; overload; inline;

{ Converts degrees to grads.

  Parameters:
    Degrees: value in degrees.

  Returns:
    The value in grads }
function DegToGrad(const Degrees: DoubleDouble): DoubleDouble; overload; inline;
function DegToGrad(const Degrees: QuadDouble): QuadDouble; overload; inline;

{ Converts degrees to cycles.

  Parameters:
    Degrees: value in degrees.

  Returns:
    The value in cycles }
function DegToCycle(const Degrees: DoubleDouble): DoubleDouble; overload; inline;
function DegToCycle(const Degrees: QuadDouble): QuadDouble; overload; inline;

{ Converts grads to radians.

  Parameters:
    Grads: value in grads.

  Returns:
    The value in radians.

  Radians = Grads * (Pi / 200) }
function GradToRad(const Grads: DoubleDouble): DoubleDouble; overload; inline;
function GradToRad(const Grads: QuadDouble): QuadDouble; overload; inline;

{ Converts grads to degrees.

  Parameters:
    Grads: value in grads.

  Returns:
    The value in degrees. }
function GradToDeg(const Grads: DoubleDouble): DoubleDouble; overload; inline;
function GradToDeg(const Grads: QuadDouble): QuadDouble; overload; inline;

{ Converts grads to cycles.

  Parameters:
    Grads: value in grads.

  Returns:
    The value in cycles. }
function GradToCycle(const Grads: DoubleDouble): DoubleDouble; overload; inline;
function GradToCycle(const Grads: QuadDouble): QuadDouble; overload; inline;

{ Converts cycles to radians.

  Parameters:
    Cycles: value in cycles.

  Returns:
    The value in radians.

  Radians = 2 * Pi * Cycles }
function CycleToRad(const Cycles: DoubleDouble): DoubleDouble; overload; inline;
function CycleToRad(const Cycles: QuadDouble): QuadDouble; overload; inline;

{ Converts cycles to degrees.

  Parameters:
    Cycles: value in cycles.

  Returns:
    The value in decrees. }
function CycleToDeg(const Cycles: DoubleDouble): DoubleDouble; overload; inline;
function CycleToDeg(const Cycles: QuadDouble): QuadDouble; overload; inline;

{ Converts cycles to grads.

  Parameters:
    Cycles: value in cycles.

  Returns:
    The value in grads. }
function CycleToGrad(const Cycles: DoubleDouble): DoubleDouble; overload; inline;
function CycleToGrad(const Cycles: QuadDouble): QuadDouble; overload; inline;

{ Returns the natural log of (X + 1).

  Parameters:
    X: the value

  Returns:
    The the natural log of (X + 1).

  Use when X is near 0. }
function LnXP1(const X: DoubleDouble): DoubleDouble; overload; inline;
function LnXP1(const X: QuadDouble): QuadDouble; overload; inline;

{ Calculates the base 2 logarithm of X.

  Parameters:
    X: the value

  Returns:
    The base 2 logarithm of X. }
function Log2(const X: DoubleDouble): DoubleDouble; overload; inline;
function Log2(const X: QuadDouble): QuadDouble; overload; inline;

{ Calculates the logarithm of X of a specified base.

  Parameters:
    Base: the base
    X: the value

  Returns:
    The base Base logarithm of X. }
function LogN(const Base, X: DoubleDouble): DoubleDouble; overload; inline;
function LogN(const Base, X: QuadDouble): QuadDouble; overload; inline;

{ Returns the lesser of two values.

  Parameters:
    A: first value
    B: second value

  Returns:
    The lesser of A and B. }
function Min(const A, B: DoubleDouble): DoubleDouble; overload; inline;
function Min(const A, B: QuadDouble): QuadDouble; overload; inline;

{ Returns the greater of two values.

  Parameters:
    A: first value
    B: second value

  Returns:
    The greater of A and B. }
function Max(const A, B: DoubleDouble): DoubleDouble; overload; inline;
function Max(const A, B: QuadDouble): QuadDouble; overload; inline;

{ Returns whether two values are (approximately) equal.

  Parameters:
    A: first value
    B: second value
    Epsilon: (optional) maximum amount by which A and B can differ and still
      be considered the same value. If 0 (default), then some reasonable default
      value is used implicitly.

  Returns:
    True if A is (approximately) equal to B, or False otherwise. }
function SameValue(const A, B: DoubleDouble): Boolean; overload; inline;
function SameValue(const A, B: DoubleDouble; Epsilon: DoubleDouble): Boolean; overload;
function SameValue(const A, B: QuadDouble): Boolean; overload; inline;
function SameValue(const A, B: QuadDouble; Epsilon: QuadDouble): Boolean; overload;

{ Returns whether a value falls within a specified range.

  Parameters:
    Value: the value to check
    Min: minimum value
    Max: maximum value

  Returns:
    True if Min <= Value <= Max, or False otherwise. }
function InRange(const Value, Min, Max: DoubleDouble): Boolean; overload; inline;
function InRange(const Value, Min, Max: QuadDouble): Boolean; overload; inline;

{ Returns the closest value to a specified value within a specified range.

  Parameters:
    Value: the value you want as long as it is in range
    Min: minimum acceptable value. If Value is less than Min, Min is returned.
    Max: maximum acceptable value. If Value is greater than Max, Max is returned.

  Returns:
    Value if range, or Min or Max otherwise. }
function EnsureRange(const Value, Min, Max: DoubleDouble): DoubleDouble; overload;
function EnsureRange(const Value, Min, Max: QuadDouble): QuadDouble; overload;

{$REGION 'Internal Declarations'}
{$IF Defined(WIN32)}
  const _PU = '_';
  {$IF Defined(MP_ACCURATE)}
    {$LINK 'Obj\dd32-accurate.obj'}
    {$LINK 'Obj\qd32-accurate.obj'}
  {$ELSE}
    {$LINK 'Obj\dd32.obj'}
    {$LINK 'Obj\qd32.obj'}
  {$ENDIF}
{$ELSEIF Defined(WIN64)}
  const _PU = '';
  {$IF Defined(MP_ACCURATE)}
    {$LINK 'Obj\dd64-accurate.obj'}
    {$LINK 'Obj\qd64-accurate.obj'}
  {$ELSE}
    {$LINK 'Obj\dd64.obj'}
    {$LINK 'Obj\qd64.obj'}
  {$ENDIF}
{$ELSEIF Defined(IOS)}
  {$DEFINE USE_LIB}
  const _PU = '';
  {$IF Defined(MP_ACCURATE)}
    const _LIB_MP = 'mp-accurate_ios64.a';
  {$ELSE}
    const _LIB_MP = 'mp_ios64.a';
  {$ENDIF}
{$ELSEIF Defined(MACOS64)}
  {$DEFINE USE_LIB}
  const _PU = '';
  {$IF Defined(MP_ACCURATE)}
    const _LIB_MP = 'mp-accurate_mac64.a';
  {$ELSE}
    const _LIB_MP = 'mp_mac64.a';
  {$ENDIF}
{$ELSEIF Defined(ANDROID32)}
  {$DEFINE USE_LIB}
  const _PU = '';
  {$IF Defined(MP_ACCURATE)}
    const _LIB_MP = 'libmp-accurate_android32.a';
  {$ELSE}
    const _LIB_MP = 'libmp_android32.a';
  {$ENDIF}
{$ELSEIF Defined(ANDROID64)}
  {$DEFINE USE_LIB}
  const _PU = '';
  {$IF Defined(MP_ACCURATE)}
    const _LIB_MP = 'libmp-accurate_android64.a';
  {$ELSE}
    const _LIB_MP = 'libmp_android64.a';
  {$ENDIF}
{$ELSE}
  {$MESSAGE Error 'Unsupported CPU'}
{$ENDIF}

procedure _dd_init; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_init';
procedure _qd_init; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_init';

procedure _dd_add_d_d(const A, B: PDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_add_d_d';
procedure _dd_add_dd_d(const A: DoubleDouble; const B: PDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_add_dd_d';
procedure _dd_add_d_dd(const A: PDouble; const B: DoubleDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_add_d_dd';
procedure _dd_add(const A, B: DoubleDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_add';

procedure _qd_add_qd_d(const A: QuadDouble; const B: PDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_add_qd_d';
//procedure _qd_add_d_qd(const A: PDouble; const B: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_add_d_qd';
procedure _qd_add_qd_dd(const A: QuadDouble; const B: DoubleDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_add_qd_dd';
//procedure _qd_add_dd_qd(const A: DoubleDouble; const B: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_add_dd_qd';
procedure _qd_add(const A, B: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_add';

procedure _dd_sub_d_d(const A, B: PDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_sub_d_d';
procedure _dd_sub_dd_d(const A: DoubleDouble; const B: PDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_sub_dd_d';
procedure _dd_sub_d_dd(const A: PDouble; const B: DoubleDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_sub_d_dd';
procedure _dd_sub(const A, B: DoubleDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_sub';

procedure _qd_sub_qd_d(const A: QuadDouble; const B: PDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_sub_qd_d';
procedure _qd_sub_d_qd(const A: PDouble; const B: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_sub_d_qd';
procedure _qd_sub_qd_dd(const A: QuadDouble; const B: DoubleDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_sub_qd_dd';
procedure _qd_sub_dd_qd(const A: DoubleDouble; const B: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_sub_dd_qd';
procedure _qd_sub(const A, B: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_sub';

procedure _dd_mul_d_d(const A, B: PDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_mul_d_d';
procedure _dd_mul_dd_d(const A: DoubleDouble; const B: PDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_mul_dd_d';
procedure _dd_mul_d_dd(const A: PDouble; const B: DoubleDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_mul_d_dd';
procedure _dd_mul(const A, B: DoubleDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_mul';

procedure _qd_mul_qd_d(const A: QuadDouble; const B: PDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_mul_qd_d';
procedure _qd_mul_d_qd(const A: PDouble; const B: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_mul_d_qd';
procedure _qd_mul_qd_dd(const A: QuadDouble; const B: DoubleDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_mul_qd_dd';
//procedure _qd_mul_dd_qd(const A: DoubleDouble; const B: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_mul_dd_qd';
procedure _qd_mul(const A, B: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_mul';

procedure _dd_div_d_d(const A, B: PDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_div_d_d';
procedure _dd_div_dd_d(const A: DoubleDouble; const B: PDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_div_dd_d';
procedure _dd_div_d_dd(const A: PDouble; const B: DoubleDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_div_d_dd';
procedure _dd_div(const A, B: DoubleDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_div';

procedure _qd_div_qd_d(const A: QuadDouble; const B: PDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_div_qd_d';
procedure _qd_div_d_qd(const A: PDouble; const B: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_div_d_qd';
procedure _qd_div_qd_dd(const A: QuadDouble; const B: DoubleDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_div_qd_dd';
procedure _qd_div_dd_qd(const A: DoubleDouble; const B: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_div_dd_qd';
procedure _qd_div(const A, B: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_div';

//function _dd_comp(const A, B: DoubleDouble): Integer; overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_comp';
//function _dd_comp_dd_d(const A: DoubleDouble; const B: PDouble): Integer; overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_comp_dd_d';
//function _dd_comp_d_dd(const A: PDouble; const B: DoubleDouble): Integer; overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_comp_d_dd';

//procedure _qd_neg(const A: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_neg';

procedure _dd_divrem(const A, B: DoubleDouble; const Result: Pointer); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_divrem';
procedure _qd_divrem(const A, B: QuadDouble; const Result: Pointer); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_divrem';

procedure _dd_inv(const A: DoubleDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_inv';
procedure _qd_inv(const A: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_inv';

procedure _dd_mul_pot(const A: DoubleDouble; const B: PDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_mul_pot';
procedure _qd_mul_pot(const A: QuadDouble; const B: PDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_mul_pot';

procedure _dd_rem(const A, B: DoubleDouble; out Res: DoubleDouble); overload; overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_rem';
procedure _qd_rem(const A, B: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_rem';

procedure _dd_fmod(const A, B: DoubleDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_fmod';
procedure _qd_fmod(const A, B: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_fmod';

procedure _dd_sqrt(const A: DoubleDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_sqrt';
procedure _dd_sqrt_d(const A: PDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_sqrt_d';
procedure _qd_sqrt(const A: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_sqrt';

procedure _dd_sqr(const A: DoubleDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_sqr';
procedure _dd_sqr_d(const A: PDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_sqr_d';
procedure _qd_sqr(const A: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_sqr';

procedure _dd_aint(const A: DoubleDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_aint';
procedure _qd_aint(const A: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_aint';

procedure _dd_floor(const A: DoubleDouble; const Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_floor';
procedure __qd_floor(const A: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_floor';

procedure _dd_ceil(const A: DoubleDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_ceil';
procedure __qd_ceil(const A: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_ceil';

procedure _dd_nint(const A: DoubleDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_nint';
procedure _qd_nint(const A: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_nint';

procedure _dd_abs(const A: DoubleDouble; const Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_abs';
procedure _qd_abs(const A: QuadDouble; out Res: QuadDouble); overload; inline; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_abs';

procedure _dd_npwr(const Base: DoubleDouble; const Exponent: Integer; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_npwr';
procedure _qd_npwr(const Base: QuadDouble; const Exponent: Integer; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_npwr';

procedure _dd_pow(const Base, Exponent: DoubleDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_pow';
procedure _qd_pow(const Base, Exponent: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_pow';

procedure _dd_nroot(const A: DoubleDouble; const N: Integer; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_nroot';
procedure _qd_nroot(const A: QuadDouble; const N: Integer; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_nroot';

procedure _dd_ldexp(const A: DoubleDouble; const P: Integer; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_ldexp';
procedure __qd_ldexp(const A: QuadDouble; P: Integer; out Res: QuadDouble); overload; inline; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_ldexp';

procedure _dd_exp(const A: DoubleDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_exp';
procedure __qd_exp(const A: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_exp';

procedure _dd_log(const A: DoubleDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_log';
procedure __qd_log(const A: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_log';

procedure _dd_log10(const A: DoubleDouble; const Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_log10';
procedure _qd_log10(const A: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_log10';

procedure _dd_sin(const A: DoubleDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_sin';
procedure _qd_sin(const A: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_sin';

procedure _dd_cos(const A: DoubleDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_cos';
procedure _qd_cos(const A: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_cos';

procedure _dd_sincos(const A: DoubleDouble; out SinA, CosA: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_sincos';
procedure _qd_sincos(const A: QuadDouble; out SinA, CosA: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_sincos';

procedure _dd_tan(const A: DoubleDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_tan';
procedure _qd_tan(const A: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_tan';

procedure _dd_asin(const A: DoubleDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_asin';
procedure _qd_asin(const A: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_asin';

procedure _dd_acos(const A: DoubleDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_acos';
procedure _qd_acos(const A: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_acos';

procedure _dd_atan(const A: DoubleDouble; out Res: DoubleDouble); overload; inline; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_atan';
procedure _qd_atan(const A: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_atan';

procedure _dd_atan2(const Y, X: DoubleDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_atan2';
procedure __qd_atan2(const Y, X: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_atan2';

procedure _dd_sinh(const A: DoubleDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_sinh';
procedure _qd_sinh(const A: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_sinh';

procedure _dd_cosh(const A: DoubleDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_cosh';
procedure _qd_cosh(const A: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_cosh';

procedure _dd_sincosh(const A: DoubleDouble; out S, C: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_sincosh';
procedure _qd_sincosh(const A: QuadDouble; out S, C: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_sincosh';

procedure _dd_tanh(const A: DoubleDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_tanh';
procedure _qd_tanh(const A: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_tanh';

procedure _dd_asinh(const A: DoubleDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_asinh';
procedure _qd_asinh(const A: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_asinh';

procedure _dd_acosh(const A: DoubleDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_acosh';
procedure _qd_acosh(const A: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_acosh';

procedure _dd_atanh(const A: DoubleDouble; out Res: DoubleDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_dd_atanh';
procedure _qd_atanh(const A: QuadDouble; out Res: QuadDouble); overload; external {$IFDEF USE_LIB}_LIB_MP{$ENDIF} name _PU + 'c_qd_atanh';

var
  _USFormatSettings: TFormatSettings;
{$ENDREGION 'Internal Declarations'}

implementation

uses
  System.SysConst;

const
  FuzzFactor = 1000;

var
  DoubleDoubleResolution: DoubleDouble;
  QuadDoubleResolution: QuadDouble;

procedure Initialize;
var
  State: UInt32;
begin
  _USFormatSettings := TFormatSettings.Create('en-US');
  _USFormatSettings.DecimalSeparator := '.';
  _USFormatSettings.ThousandSeparator := ',';

  State := MultiPrecisionInit;
  try
    _dd_init;
    _qd_init;
    DoubleDoubleResolution.Init('1e-28');
    QuadDoubleResolution.Init('1e-59');
  finally
    MultiPrecisionReset(State);
  end;
end;

{$IF Defined(WIN32)}
{ These are called from the C object files: }
function _qd_nan: Double; cdecl;
begin
  Result := NaN;
end;

function _qd_inf: Double; cdecl;
begin
  Result := Infinity;
end;

function _qd_log(Value: Double): Double; cdecl;
begin
  Result := System.Ln(Value);
end;

function _qd_exp(Value: Double): Double; cdecl;
begin
  Result := System.Exp(Value);
end;

function _qd_ldexp(Value: Double; P: Integer): Double; cdecl;
asm
  fild   [P]
  fld    [Value]
  fscale
  fstp   st(1)
end;

function _qd_atan2(Y, X: Double): Double; cdecl;
asm
  FLD     [Y]
  FLD     [X]
  FPATAN
  FWAIT
end;

function _qd_floor(Value: Double): Double; cdecl;
begin
  Result := System.Math.Floor(Value);
end;

function _qd_ceil(Value: Double): Double; cdecl;
begin
  Result := System.Math.Ceil(Value);
end;
{$ELSE}
{ These are called from the C object files: }
function qd_nan: Double; cdecl;
begin
  Result := NaN;
end;

function qd_inf: Double; cdecl;
begin
  Result := Infinity;
end;

function qd_log(Value: Double): Double; cdecl;
begin
  Result := System.Ln(Value);
end;

function qd_exp(Value: Double): Double; cdecl;
begin
  Result := System.Exp(Value);
end;

function qd_ldexp(Value: Double; P: Integer): Double; cdecl;
begin
  Result := System.Math.Ldexp(Value, P);
end;

function qd_atan2(Y, X: Double): Double; cdecl;
begin
  Result := System.Math.ArcTan2(Y, X);
end;

function qd_floor(Value: Double): Double; cdecl;
begin
  Result := System.Math.Floor(Value);
end;

function qd_ceil(Value: Double): Double; cdecl;
begin
  Result := System.Math.Ceil(Value);
end;
{$IF Defined(MACOS) or Defined(ANDROID)}
exports
  qd_nan,
  qd_inf,
  qd_log,
  qd_exp,
  qd_ldexp,
  qd_atan2,
  qd_floor,
  qd_ceil;
{$ENDIF}
{$ENDIF}

{ Global functions }

{$IFDEF MSWINDOWS}
{$WARN SYMBOL_PLATFORM OFF}
function MultiPrecisionInit: UInt32;
var
  ExceptionMask: TArithmeticExceptionMask;
  RoundMode: TRoundingMode;
  PrecisionMode: TFPUPrecisionMode;
begin
  ExceptionMask := GetExceptionMask;
  RoundMode := GetRoundMode;
  PrecisionMode := GetPrecisionMode;
  SetExceptionMask(exAllArithmeticExceptions);
  SetRoundMode(rmNearest);
  SetPrecisionMode(pmDouble);

  Result := Byte(ExceptionMask) or (Ord(RoundMode) shl 8) or (Ord(PrecisionMode) shl 16);
end;

procedure MultiPrecisionReset(const AState: UInt32);
var
  ExceptionMask: TArithmeticExceptionMask;
  RoundMode: TRoundingMode;
  PrecisionMode: TFPUPrecisionMode;
begin
  ExceptionMask := TArithmeticExceptionMask(Byte(AState));
  RoundMode := TRoundingMode((AState shr 8) and $FF);
  PrecisionMode := TFPUPrecisionMode((AState shr 16) and $FF);
  SetExceptionMask(ExceptionMask);
  SetRoundMode(RoundMode);
  SetPrecisionMode(PrecisionMode);
end;
{$WARN SYMBOL_PLATFORM ON}
{$ELSE}
function MultiPrecisionInit: UInt32;
begin
  { Only need for Windows }
  Result := 0;
end;

procedure MultiPrecisionReset(const AState: UInt32);
begin
  { Only need for Windows }
end;
{$ENDIF}

{ Common helpers }

procedure RoundString(const S: TArray<Char>; Precision: Integer;
  var Offset: Integer);
var
  NumDigits, I: Integer;
begin
  NumDigits := Precision;

  { Round, handle carry }
  if (NumDigits > 0) and (S[NumDigits] >= '5') then
  begin
    S[NumDigits - 1] := Char(Ord(S[NumDigits - 1]) + 1);
    I := NumDigits - 1;
    while (I > 0) and (S[I] > '9') do
    begin
      S[I] := Char(Ord(S[I]) - 10);
      Dec(I);
      S[I] := Char(Ord(S[I]) + 1);
    end;
  end;

  { If first digit is 10, shift everything. }
  if (S[0] > '9') then
  begin
    for I := Precision downto 1 do
      S[I + 1] := S[I];
    S[0] := '1';
    S[1] := '0';

    Inc(Offset); { Now offset needs to be increased by one }
    Inc(Precision);
  end;

  S[Precision] := #0;
end;

procedure AppendExponent(const SB: TStringBuilder; Exponent: Integer);
var
  K: Integer;
begin
  if (Exponent < 0) then
  begin
    SB.Append('-');
    Exponent := -Exponent;
  end
  else
    SB.Append('+');

  if (Exponent >= 100) then
  begin
    K := Exponent div 100;
    SB.Append(Char(Ord('0') + K));
    Exponent := Exponent - (100 * K);
  end;

  K := Exponent div 10;
  SB.Append(Char(Ord('0') + K));
  Exponent := Exponent - (10 * K);

  SB.Append(Char(Ord('0') + Exponent));
end;

function Add(const A, B: Double): DoubleDouble;
begin
  _dd_add_d_d(@A, @B, Result);
end;

function Subtract(const A, B: Double): DoubleDouble;
begin
  _dd_sub_d_d(@A, @B, Result);
end;

function Multiply(const A, B: Double): DoubleDouble;
begin
  _dd_mul_d_d(@A, @B, Result);
end;

function Divide(const A, B: Double): DoubleDouble;
begin
  _dd_div_d_d(@A, @B, Result);
end;

function Inverse(const A: DoubleDouble): DoubleDouble;
begin
  _dd_inv(A, Result);
end;

function Inverse(const A: QuadDouble): QuadDouble;
begin
  _qd_inv(A, Result);
end;

function MulPoT(const A: DoubleDouble; const B: Double): DoubleDouble;
begin
  _dd_mul_pot(A, @B, Result);
end;

function MulPoT(const A: QuadDouble; const B: Double): QuadDouble;
begin
  _qd_mul_pot(A, @B, Result);
end;

function Rem(const Dividend, Divisor: DoubleDouble): DoubleDouble;
begin
  _dd_rem(Dividend, Divisor, Result);
end;

function Rem(const Dividend, Divisor: QuadDouble): QuadDouble;
begin
  _qd_rem(Dividend, Divisor, Result);
end;

procedure DivRem(const Dividend, Divisor: DoubleDouble; out Remainder, Result: DoubleDouble);
var
  R: array [0..1] of DoubleDouble;
begin
  _dd_divrem(Dividend, Divisor, @R);
  Remainder := R[0];
  Result := R[1];
end;

function DivRem(const Dividend, Divisor: DoubleDouble; out Remainder: DoubleDouble): DoubleDouble;
var
  R: array [0..1] of DoubleDouble;
begin
  _dd_divrem(Dividend, Divisor, @R);
  Remainder := R[0];
  Result := R[1];
end;

procedure DivRem(const Dividend, Divisor: QuadDouble; out Remainder, Result: QuadDouble);
var
  R: array [0..1] of QuadDouble;
begin
  _qd_divrem(Dividend, Divisor, @R);
  Remainder := R[0];
  Result := R[1];
end;

function DivRem(const Dividend, Divisor: QuadDouble; out Remainder: QuadDouble): QuadDouble;
var
  R: array [0..1] of QuadDouble;
begin
  _qd_divrem(Dividend, Divisor, @R);
  Remainder := R[0];
  Result := R[1];
end;

function FMod(const Dividend, Divisor: DoubleDouble): DoubleDouble;
begin
  _dd_fmod(Dividend, Divisor, Result);
end;

function FMod(const Dividend, Divisor: QuadDouble): QuadDouble;
begin
  _qd_fmod(Dividend, Divisor, Result);
end;

function Sqrt(const A: DoubleDouble): DoubleDouble;
begin
  _dd_sqrt(A, Result);
end;

function Sqrt(const A: QuadDouble): QuadDouble;
begin
  _qd_sqrt(A, Result);
end;

function Sqr(const A: DoubleDouble): DoubleDouble;
begin
  _dd_sqr(A, Result);
end;

procedure Sqr(const A: Double; out Result: DoubleDouble);
begin
  _dd_sqr_d(@A, Result);
end;

function Sqr(const A: QuadDouble): QuadDouble;
begin
  _qd_sqr(A, Result);
end;

function Trunc(const A: DoubleDouble): DoubleDouble;
begin
  _dd_aint(A, Result)
end;

function Trunc(const A: QuadDouble): QuadDouble;
begin
  _qd_aint(A, Result);
end;

function Floor(const A: DoubleDouble): DoubleDouble;
begin
  _dd_floor(A, Result);
end;

function Floor(const A: QuadDouble): QuadDouble;
begin
  __qd_floor(A, Result);
end;

function Ceil(const A: DoubleDouble): DoubleDouble;
begin
  _dd_ceil(A, Result);
end;

function Ceil(const A: QuadDouble): QuadDouble;
begin
  __qd_ceil(A, Result);
end;

function Round(const A: DoubleDouble): DoubleDouble;
begin
  _dd_nint(A, Result);
end;

function Round(const A: QuadDouble): QuadDouble;
begin
  _qd_nint(A, Result);
end;

function Abs(const A: DoubleDouble): DoubleDouble;
begin
  _dd_abs(A, Result);
end;

function Abs(const A: QuadDouble): QuadDouble;
begin
  _qd_abs(A, Result);
end;

function IntPower(const Base: DoubleDouble; const Exponent: Integer): DoubleDouble;
begin
  _dd_npwr(Base, Exponent, Result);
end;

function IntPower(const Base: QuadDouble; const Exponent: Integer): QuadDouble;
begin
  _qd_npwr(Base, Exponent, Result);
end;

function Power(const Base, Exponent: DoubleDouble): DoubleDouble;
begin
  _dd_pow(Base, Exponent, Result);
end;

function Power(const Base, Exponent: QuadDouble): QuadDouble;
begin
  _qd_pow(Base, Exponent, Result);
end;

function NRoot(const A: DoubleDouble; const N: Integer): DoubleDouble;
begin
  _dd_nroot(A, N, Result);
end;

function NRoot(const A: QuadDouble; const N: Integer): QuadDouble;
begin
  _qd_nroot(A, N, Result);
end;

function Ldexp(const A: DoubleDouble; const Exp: Integer): DoubleDouble;
begin
  _dd_ldexp(A, Exp, Result);
end;

function Ldexp(const A: QuadDouble; Exp: Integer): QuadDouble;
begin
  __qd_ldexp(A, Exp, Result);
end;

function Exp(const A: DoubleDouble): DoubleDouble;
begin
  _dd_exp(A, Result);
end;

function Exp(const A: QuadDouble): QuadDouble;
begin
  __qd_exp(A, Result);
end;

function Ln(const A: DoubleDouble): DoubleDouble;
begin
  _dd_log(A, Result);
end;

function Ln(const A: QuadDouble): QuadDouble;
begin
  __qd_log(A, Result);
end;

function Log10(const A: DoubleDouble): DoubleDouble;
begin
  _dd_log10(A, Result);
end;

function Log10(const A: QuadDouble): QuadDouble;
begin
  _qd_log10(A, Result);
end;

function Sin(const A: DoubleDouble): DoubleDouble;
begin
  _dd_sin(A, Result);
end;

function Sin(const A: QuadDouble): QuadDouble;
begin
  _qd_sin(A, Result);
end;

function Cos(const A: DoubleDouble): DoubleDouble;
begin
  _dd_cos(A, Result);
end;

function Cos(const A: QuadDouble): QuadDouble;
begin
  _qd_cos(A, Result);
end;

procedure SinCos(const A: DoubleDouble; out SinA, CosA: DoubleDouble);
begin
  _dd_sincos(A, SinA, CosA);
end;

procedure SinCos(const A: QuadDouble; out SinA, CosA: QuadDouble);
begin
  _qd_sincos(A, SinA, CosA);
end;

function Tan(const A: DoubleDouble): DoubleDouble;
begin
  _dd_tan(A, Result);
end;

function Tan(const A: QuadDouble): QuadDouble;
begin
  _qd_tan(A, Result);
end;

function ArcSin(const A: DoubleDouble): DoubleDouble;
begin
  _dd_asin(A, Result);
end;

function ArcSin(const A: QuadDouble): QuadDouble;
begin
  _qd_asin(A, Result);
end;

function ArcCos(const A: DoubleDouble): DoubleDouble;
begin
  _dd_acos(A, Result);
end;

function ArcCos(const A: QuadDouble): QuadDouble;
begin
  _qd_acos(A, Result);
end;

function ArcTan(const A: DoubleDouble): DoubleDouble;
begin
  _dd_atan(A, Result);
end;

function ArcTan(const A: QuadDouble): QuadDouble;
begin
  _qd_atan(A, Result);
end;

function ArcTan2(const Y, X: DoubleDouble): DoubleDouble;
begin
  _dd_atan2(Y, X, Result);
end;

function ArcTan2(const Y, X: QuadDouble): QuadDouble;
begin
  __qd_atan2(Y, X, Result);
end;

function Sinh(const A: DoubleDouble): DoubleDouble;
begin
  _dd_sinh(A, Result);
end;

function Sinh(const A: QuadDouble): QuadDouble;
begin
  _qd_sinh(A, Result);
end;

function Cosh(const A: DoubleDouble): DoubleDouble;
begin
  _dd_cosh(A, Result);
end;

function Cosh(const A: QuadDouble): QuadDouble;
begin
  _qd_cosh(A, Result);
end;

procedure SinCosh(const A: DoubleDouble; out S, C: DoubleDouble);
begin
  _dd_sincosh(A, S, C);
end;

procedure SinCosh(const A: QuadDouble; out S, C: QuadDouble);
begin
  _qd_sincosh(A, S, C);
end;

function Tanh(const A: DoubleDouble): DoubleDouble;
begin
  _dd_tanh(A, Result);
end;

function Tanh(const A: QuadDouble): QuadDouble;
begin
  _qd_tanh(A, Result);
end;

function ArcSinh(const A: DoubleDouble): DoubleDouble;
begin
  _dd_asinh(A, Result);
end;

function ArcSinh(const A: QuadDouble): QuadDouble;
begin
  _qd_asinh(A, Result);
end;

function ArcCosh(const A: DoubleDouble): DoubleDouble;
begin
  _dd_acosh(A, Result);
end;

function ArcCosh(const A: QuadDouble): QuadDouble;
begin
  _qd_acosh(A, Result);
end;

function ArcTanh(const A: DoubleDouble): DoubleDouble;
begin
  _dd_atanh(A, Result);
end;

function ArcTanh(const A: QuadDouble): QuadDouble;
begin
  _qd_atanh(A, Result);
end;

function StrToDoubleDouble(const S: String): DoubleDouble;
begin
  Result.Init(S, FormatSettings);
  if (Result.IsNan) then
    raise EConvertError.CreateResFmt(@SInvalidFloat, [S]);
end;

function StrToDoubleDouble(const S: String;
  const FormatSettings: TFormatSettings): DoubleDouble;
begin
  Result.Init(S, FormatSettings);
  if (Result.IsNan) then
    raise EConvertError.CreateResFmt(@SInvalidFloat, [S]);
end;

function StrToQuadDouble(const S: String): QuadDouble;
begin
  Result.Init(S, FormatSettings);
  if (Result.IsNan) then
    raise EConvertError.CreateResFmt(@SInvalidFloat, [S]);
end;

function StrToQuadDouble(const S: String;
  const FormatSettings: TFormatSettings): QuadDouble;
begin
  Result.Init(S, FormatSettings);
  if (Result.IsNan) then
    raise EConvertError.CreateResFmt(@SInvalidFloat, [S]);
end;

function StrToDoubleDoubleDef(const S: String;
  const Default: DoubleDouble): DoubleDouble;
begin
  Result.Init(S, FormatSettings);
  if (Result.IsNan) then
    Result := Default;
end;

function StrToDoubleDoubleDef(const S: String; const Default: DoubleDouble;
  const FormatSettings: TFormatSettings): DoubleDouble;
begin
  Result.Init(S, FormatSettings);
  if (Result.IsNan) then
    Result := Default;
end;

function StrToQuadDoubleDef(const S: String;
  const Default: QuadDouble): QuadDouble;
begin
  Result.Init(S, FormatSettings);
  if (Result.IsNan) then
    Result := Default;
end;

function StrToQuadDoubleDef(const S: String; const Default: QuadDouble;
  const FormatSettings: TFormatSettings): QuadDouble;
begin
  Result.Init(S, FormatSettings);
  if (Result.IsNan) then
    Result := Default;
end;

function TryStrToFloat(const S: string; out Value: DoubleDouble): Boolean;
begin
  Value.Init(S);
  Result := (not Value.IsNan);
end;

function TryStrToFloat(const S: string; out Value: DoubleDouble;
  const FormatSettings: TFormatSettings): Boolean;
begin
  Value.Init(S);
  Result := (not Value.IsNan);
end;

function TryStrToFloat(const S: string; out Value: QuadDouble): Boolean;
begin
  Value.Init(S);
  Result := (not Value.IsNan);
end;

function TryStrToFloat(const S: string; out Value: QuadDouble;
  const FormatSettings: TFormatSettings): Boolean;
begin
  Value.Init(S);
  Result := (not Value.IsNan);
end;

function FloatToStr(const Value: DoubleDouble): String;
begin
  Result := Value.ToString(FormatSettings, TMPFloatFormat.Fixed);
end;

function FloatToStr(const Value: DoubleDouble;
  const FormatSettings: TFormatSettings): String;
begin
  Result := Value.ToString(FormatSettings, TMPFloatFormat.Fixed);
end;

function FloatToStr(const Value: QuadDouble): String;
begin
  Result := Value.ToString(FormatSettings, TMPFloatFormat.Fixed);
end;

function FloatToStr(const Value: QuadDouble;
  const FormatSettings: TFormatSettings): String;
begin
  Result := Value.ToString(FormatSettings, TMPFloatFormat.Fixed);
end;

function FloatToStrF(const Value: DoubleDouble; Format: TMPFloatFormat;
  const Precision: Integer): String;
begin
  Result := Value.ToString(FormatSettings, Format, Precision);
end;

function FloatToStrF(const Value: DoubleDouble; Format: TMPFloatFormat;
  const Precision: Integer; const FormatSettings: TFormatSettings): String;
begin
  Result := Value.ToString(FormatSettings, Format, Precision);
end;

function FloatToStrF(const Value: QuadDouble; Format: TMPFloatFormat;
  const Precision: Integer): String;
begin
  Result := Value.ToString(FormatSettings, Format, Precision);
end;

function FloatToStrF(const Value: QuadDouble; Format: TMPFloatFormat;
  const Precision: Integer; const FormatSettings: TFormatSettings): String;
begin
  Result := Value.ToString(FormatSettings, Format, Precision);
end;

function Cotan(const X: DoubleDouble): DoubleDouble;
begin
  Result := DoubleDouble.One / Tan(X);
end;

function Cotan(const X: QuadDouble): QuadDouble;
begin
  Result := QuadDouble.One / Tan(X);
end;

function Cot(const X: DoubleDouble): DoubleDouble;
begin
  Result := DoubleDouble.One / Tan(X);
end;

function Cot(const X: QuadDouble): QuadDouble;
begin
  Result := QuadDouble.One / Tan(X);
end;

function Secant(const X: DoubleDouble): DoubleDouble;
begin
  Result := DoubleDouble.One / Cos(X);
end;

function Secant(const X: QuadDouble): QuadDouble;
begin
  Result := QuadDouble.One / Cos(X);
end;

function Sec(const X: DoubleDouble): DoubleDouble;
begin
  Result := DoubleDouble.One / Cos(X);
end;

function Sec(const X: QuadDouble): QuadDouble;
begin
  Result := QuadDouble.One / Cos(X);
end;

function Cosecant(const X: DoubleDouble): DoubleDouble;
begin
  Result := DoubleDouble.One / Sin(X);
end;

function Cosecant(const X: QuadDouble): QuadDouble;
begin
  Result := QuadDouble.One / Sin(X);
end;

function Csc(const X: DoubleDouble): DoubleDouble;
begin
  Result := DoubleDouble.One / Sin(X);
end;

function Csc(const X: QuadDouble): QuadDouble;
begin
  Result := QuadDouble.One / Sin(X);
end;

function CotH(const X: DoubleDouble): DoubleDouble;
begin
  Result := DoubleDouble.One / TanH(X);
end;

function CotH(const X: QuadDouble): QuadDouble;
begin
  Result := QuadDouble.One / TanH(X);
end;

function SecH(const X: DoubleDouble): DoubleDouble;
begin
  Result := DoubleDouble.One / CosH(X);
end;

function SecH(const X: QuadDouble): QuadDouble;
begin
  Result := QuadDouble.One / CosH(X);
end;

function CscH(const X: DoubleDouble): DoubleDouble;
begin
  Result := DoubleDouble.One / SinH(X);
end;

function CscH(const X: QuadDouble): QuadDouble;
begin
  Result := QuadDouble.One / SinH(X);
end;

function ArcCot(const X: DoubleDouble): DoubleDouble;
begin
  if (X.IsZero) then
    Result := DoubleDouble.PiOver2
  else
    Result := ArcTan(Inverse(X));
end;

function ArcCot(const X: QuadDouble): QuadDouble;
begin
  if (X.IsZero) then
    Result := QuadDouble.PiOver2
  else
    Result := ArcTan(Inverse(X));
end;

function ArcSec(const X: DoubleDouble): DoubleDouble;
begin
  if (X.IsZero) then
    Result := DoubleDouble.PositiveInfinity
  else
    Result := ArcCos(Inverse(X));
end;

function ArcSec(const X: QuadDouble): QuadDouble;
begin
  if (X.IsZero) then
    Result := QuadDouble.PositiveInfinity
  else
    Result := ArcCos(Inverse(X));
end;

function ArcCsc(const X: DoubleDouble): DoubleDouble;
begin
  if (X.IsZero) then
    Result := DoubleDouble.PositiveInfinity
  else
    Result := ArcSin(Inverse(X));
end;

function ArcCsc(const X: QuadDouble): QuadDouble;
begin
  if (X.IsZero) then
    Result := QuadDouble.PositiveInfinity
  else
    Result := ArcSin(Inverse(X));
end;

function ArcCotH(const X: DoubleDouble): DoubleDouble;
begin
  if (X.IsOne) then
    Result := DoubleDouble.PositiveInfinity
  else if (X = -1) then
    Result := DoubleDouble.NegativeInfinity
  else
    Result := 0.5 * Ln((X + DoubleDouble.One) / (X - DoubleDouble.One));
end;

function ArcCotH(const X: QuadDouble): QuadDouble;
begin
  if (X.IsOne) then
    Result := QuadDouble.PositiveInfinity
  else if (X = -1) then
    Result := QuadDouble.NegativeInfinity
  else
    Result := 0.5 * Ln((X + QuadDouble.One) / (X - QuadDouble.One));
end;

function ArcSecH(const X: DoubleDouble): DoubleDouble;
begin
  if (X.IsZero) then
    Result := DoubleDouble.PositiveInfinity
  else if (X.IsOne) then
    Result := DoubleDouble.Zero
  else
    Result := Ln((Sqrt(DoubleDouble.One - X * X) + DoubleDouble.One) / X);
end;

function ArcSecH(const X: QuadDouble): QuadDouble;
begin
  if (X.IsZero) then
    Result := QuadDouble.PositiveInfinity
  else if (X.IsOne) then
    Result := QuadDouble.Zero
  else
    Result := Ln((Sqrt(QuadDouble.One - X * X) + QuadDouble.One) / X);
end;

function ArcCscH(const X: DoubleDouble): DoubleDouble;
begin
  if (X.IsZero) then
    Result := DoubleDouble.PositiveInfinity
  else if (X.IsNegative) then
    Result := Ln((DoubleDouble.One - Sqrt(DoubleDouble.One + X * X)) / X)
  else
    Result := Ln((DoubleDouble.One + Sqrt(DoubleDouble.One + X * X)) / X);
end;

function ArcCscH(const X: QuadDouble): QuadDouble;
begin
  if (X.IsZero) then
    Result := QuadDouble.PositiveInfinity
  else if (X.IsNegative) then
    Result := Ln((QuadDouble.One - Sqrt(QuadDouble.One + X * X)) / X)
  else
    Result := Ln((QuadDouble.One + Sqrt(QuadDouble.One + X * X)) / X);
end;

function Hypot(const X, Y: DoubleDouble): DoubleDouble;
{ Formula: Sqrt(X*X + Y*Y)
  Implemented as: |Y|*Sqrt(1+Sqr(X/Y)), |X| < |Y| for greater precision }
var
  Temp, TempX, TempY: DoubleDouble;
begin
  TempX := Abs(X);
  TempY := Abs(Y);

  if (TempX > TempY) then
  begin
    Temp := TempX;
    TempX := TempY;
    TempY := Temp;
  end;

  if (TempX.IsZero) then
    Result := TempY
  else
    // TempY > TempX, TempX <> 0, so TempY > 0
    Result := TempY * Sqrt(DoubleDouble.One + Sqr(TempX/TempY));
end;

function Hypot(const X, Y: QuadDouble): QuadDouble;
{ Formula: Sqrt(X*X + Y*Y)
  Implemented as: |Y|*Sqrt(1+Sqr(X/Y)), |X| < |Y| for greater precision }
var
  Temp, TempX, TempY: QuadDouble;
begin
  TempX := Abs(X);
  TempY := Abs(Y);

  if (TempX > TempY) then
  begin
    Temp := TempX;
    TempX := TempY;
    TempY := Temp;
  end;

  if (TempX.IsZero) then
    Result := TempY
  else
    // TempY > TempX, TempX <> 0, so TempY > 0
    Result := TempY * Sqrt(QuadDouble.One + Sqr(TempX/TempY));
end;

function RadToDeg(const Radians: DoubleDouble): DoubleDouble;
begin
  Result := Radians * DoubleDouble._180OverPi;
end;

function RadToDeg(const Radians: QuadDouble): QuadDouble;
begin
  Result := Radians * QuadDouble._180OverPi;
end;

function RadToGrad(const Radians: DoubleDouble): DoubleDouble;
begin
  Result := Radians * (200 / DoubleDouble.Pi);
end;

function RadToGrad(const Radians: QuadDouble): QuadDouble;
begin
  Result := Radians * (200 / QuadDouble.Pi);
end;

function RadToCycle(const Radians: DoubleDouble): DoubleDouble;
begin
  Result := Radians / DoubleDouble.PiTimes2;
end;

function RadToCycle(const Radians: QuadDouble): QuadDouble;
begin
  Result := Radians / QuadDouble.PiTimes2;
end;

function DegToRad(const Degrees: DoubleDouble): DoubleDouble;
begin
  Result := Degrees * DoubleDouble.PiOver180;
end;

function DegToRad(const Degrees: QuadDouble): QuadDouble;
begin
  Result := Degrees * QuadDouble.PiOver180;
end;

function DegToGrad(const Degrees: DoubleDouble): DoubleDouble;
begin
  Result := RadToGrad(DegToRad(Degrees));
end;

function DegToGrad(const Degrees: QuadDouble): QuadDouble;
begin
  Result := RadToGrad(DegToRad(Degrees));
end;

function DegToCycle(const Degrees: DoubleDouble): DoubleDouble;
begin
  Result := RadToCycle(DegToRad(Degrees));
end;

function DegToCycle(const Degrees: QuadDouble): QuadDouble;
begin
  Result := RadToCycle(DegToRad(Degrees));
end;

function GradToRad(const Grads: DoubleDouble): DoubleDouble;
begin
  Result := Grads * (DoubleDouble.Pi / 200);
end;

function GradToRad(const Grads: QuadDouble): QuadDouble;
begin
  Result := Grads * (QuadDouble.Pi / 200);
end;

function GradToDeg(const Grads: DoubleDouble): DoubleDouble;
begin
  Result := RadToDeg(GradToRad(Grads));
end;

function GradToDeg(const Grads: QuadDouble): QuadDouble;
begin
  Result := RadToDeg(GradToRad(Grads));
end;

function GradToCycle(const Grads: DoubleDouble): DoubleDouble;
begin
  Result := RadToCycle(GradToRad(Grads));
end;

function GradToCycle(const Grads: QuadDouble): QuadDouble;
begin
  Result := RadToCycle(GradToRad(Grads));
end;

function CycleToRad(const Cycles: DoubleDouble): DoubleDouble;
begin
  Result := Cycles * DoubleDouble.PiTimes2;
end;

function CycleToRad(const Cycles: QuadDouble): QuadDouble;
begin
  Result := Cycles * DoubleDouble.PiTimes2;
end;

function CycleToDeg(const Cycles: DoubleDouble): DoubleDouble;
begin
  Result := RadToDeg(CycleToRad(Cycles));
end;

function CycleToDeg(const Cycles: QuadDouble): QuadDouble;
begin
  Result := RadToDeg(CycleToRad(Cycles));
end;

function CycleToGrad(const Cycles: DoubleDouble): DoubleDouble;
begin
  Result := RadToGrad(CycleToRad(Cycles));
end;

function CycleToGrad(const Cycles: QuadDouble): QuadDouble;
begin
  Result := RadToGrad(CycleToRad(Cycles));
end;

function LnXP1(const X: DoubleDouble): DoubleDouble;
begin
  Result := Ln(DoubleDouble.One + X);
end;

function LnXP1(const X: QuadDouble): QuadDouble;
begin
  Result := Ln(QuadDouble.One + X);
end;

function Log2(const X: DoubleDouble): DoubleDouble;
begin
  Result := Ln(X) / DoubleDouble.Log2;
end;

function Log2(const X: QuadDouble): QuadDouble;
begin
  Result := Ln(X) / QuadDouble.Log2;
end;

function LogN(const Base, X: DoubleDouble): DoubleDouble;
begin
  Result := Ln(X) / Ln(Base);
end;

function LogN(const Base, X: QuadDouble): QuadDouble;
begin
  Result := Ln(X) / Ln(Base);
end;

function Min(const A, B: DoubleDouble): DoubleDouble;
begin
  if (A < B) then
    Result := A
  else
    Result := B;
end;

function Min(const A, B: QuadDouble): QuadDouble;
begin
  if (A < B) then
    Result := A
  else
    Result := B;
end;

function Max(const A, B: DoubleDouble): DoubleDouble;
begin
  if (A > B) then
    Result := A
  else
    Result := B;
end;

function Max(const A, B: QuadDouble): QuadDouble;
begin
  if (A > B) then
    Result := A
  else
    Result := B;
end;

function SameValue(const A, B: DoubleDouble): Boolean;
begin
  Result := SameValue(A, B, DoubleDouble.Zero);
end;

function SameValue(const A, B: DoubleDouble; Epsilon: DoubleDouble): Boolean;
begin
  if (Epsilon.IsZero) then
    Epsilon := Max(Min(Abs(A), Abs(B)) * DoubleDoubleResolution, DoubleDoubleResolution);

  if (A > B) then
    Result := ((A - B) <= Epsilon)
  else
    Result := ((B - A) <= Epsilon);
end;

function SameValue(const A, B: QuadDouble): Boolean;
begin
  Result := SameValue(A, B, QuadDouble.Zero);
end;

function SameValue(const A, B: QuadDouble; Epsilon: QuadDouble): Boolean;
begin
  if (Epsilon.IsZero) then
    Epsilon := Max(Min(Abs(A), Abs(B)) * QuadDoubleResolution, QuadDoubleResolution);

  if (A > B) then
    Result := ((A - B) <= Epsilon)
  else
    Result := ((B - A) <= Epsilon);
end;

function InRange(const Value, Min, Max: DoubleDouble): Boolean;
begin
  Result := (Value >= Min) and (Value <= Max);
end;

function InRange(const Value, Min, Max: QuadDouble): Boolean;
begin
  Result := (Value >= Min) and (Value <= Max);
end;

function EnsureRange(const Value, Min, Max: DoubleDouble): DoubleDouble;
begin
  if (Value < Min) then
    Result := Min
  else if (Value > Max) then
    Result := Max
  else
    Result := Value;
end;

function EnsureRange(const Value, Min, Max: QuadDouble): QuadDouble;
begin
  if (Value < Min) then
    Result := Min
  else if (Value > Max) then
    Result := Max
  else
    Result := Value;
end;

{ DoubleDouble }

class operator DoubleDouble.Add(const A, B: DoubleDouble): DoubleDouble;
begin
  _dd_add(A, B, Result);
end;

class operator DoubleDouble.Add(const A: Double; const B: DoubleDouble): DoubleDouble;
begin
  _dd_add_d_dd(@A, B, Result);
end;

class operator DoubleDouble.Add(const A: DoubleDouble; const B: Double): DoubleDouble;
begin
  _dd_add_dd_d(A, @B, Result);
end;

procedure DoubleDouble.Clear;
begin
  X[0] := 0;
  X[1] := 0;
end;

class operator DoubleDouble.Divide(const A, B: DoubleDouble): DoubleDouble;
begin
  _dd_div(A, B, Result);
end;

class operator DoubleDouble.Divide(const A: Double; const B: DoubleDouble): DoubleDouble;
begin
  _dd_div_d_dd(@A, B, Result);
end;

class operator DoubleDouble.Divide(const A: DoubleDouble; const B: Double): DoubleDouble;
begin
  _dd_div_dd_d(A, @B, Result);
end;

class operator DoubleDouble.Equal(const A: DoubleDouble; const B: Double): Boolean;
begin
  Result := (A.X[0] = B) and (A.X[1] = 0);
end;

class operator DoubleDouble.Equal(const A: Double; const B: DoubleDouble): Boolean;
begin
  Result := (A = B.X[0]) and (B.X[1] = 0);
end;

function DoubleDouble.Equals(const A: DoubleDouble): Boolean;
begin
  Result := (X[0] = A.X[0]) and (X[1] = A.X[1]);
end;

function DoubleDouble.Equals(const A: Double): Boolean;
begin
  Result := (X[0] = A) and (X[1] = 0);
end;

class operator DoubleDouble.Equal(const A, B: DoubleDouble): Boolean;
begin
  Result := (A.X[0] = B.X[0]) and (A.X[1] = B.X[1]);
end;

class operator DoubleDouble.GreaterThan(const A: DoubleDouble;
  const B: Double): Boolean;
begin
  Result := (A.X[0] > B) or ((A.X[0] = B) and (A.X[1] > 0));
end;

class operator DoubleDouble.GreaterThan(const A, B: DoubleDouble): Boolean;
begin
  Result := (A.X[0] > B.X[0]) or ((A.X[0] = B.X[0]) and (A.X[1] > B.X[1]));
end;

function DoubleDouble.GetExp: UInt64;
begin
  Result := X[0].Exp;
end;

function DoubleDouble.GetSign: Boolean;
begin
  Result := X[0].Sign;
end;

function DoubleDouble.GetSpecialType: TFloatSpecial;
begin
  if (IsZero) then
  begin
    if (PUInt64(@Self)^ = $8000000000000000) then
      Result := fsNZero
    else
      Result := fsZero;
  end
  else if (IsPositiveInfinity) then
    Result := fsInf
  else if (IsNegative) then
    Result := fsNInf
  else if (IsNaN) then
    Result := fsNaN
  else if (IsPositive) then
    Result := fsPositive
  else
    Result := fsNegative;
end;

class operator DoubleDouble.GreaterThan(const A: Double;
  const B: DoubleDouble): Boolean;
begin
  Result := (A > B.X[0]) or ((A = B.X[0]) and (B.X[1] < 0));
end;

class operator DoubleDouble.GreaterThanOrEqual(const A, B: DoubleDouble): Boolean;
begin
  Result := (A.X[0] > B.X[0]) or ((A.X[0] = B.X[0]) and (A.X[1] >= B.X[1]));
end;

class operator DoubleDouble.GreaterThanOrEqual(const A: Double;
  const B: DoubleDouble): Boolean;
begin
  Result := (A > B.X[0]) or ((A = B.X[0]) and (B.X[1] <= 0));
end;

class operator DoubleDouble.GreaterThanOrEqual(const A: DoubleDouble;
  const B: Double): Boolean;
begin
  Result := (A.X[0] > B) or ((A.X[0] = B) and (A.X[1] >= 0));
end;

class operator DoubleDouble.Implicit(const S: String): DoubleDouble;
begin
  Result.Init(S, _USFormatSettings);
  if (Result.IsNan) then
    raise EConvertError.CreateResFmt(@SInvalidFloat, [S]);
end;

class operator DoubleDouble.Explicit(const Value: Double): DoubleDouble;
begin
  Result.Init(Value);
end;

procedure DoubleDouble.Init;
begin
  X[0] := 0;
  X[1] := 0;
end;

procedure DoubleDouble.Init(const Value: Double);
begin
  X[0] := Value;
  X[1] := 0;
end;

procedure DoubleDouble.Init(const Hi, Lo: Double);
begin
  X[0] := Hi;
  X[1] := Lo;
end;

procedure DoubleDouble.Init(const S: String;
  const FormatSettings: TFormatSettings);
var
  P: PChar;
  C: Char;
  Sign, Point, ND, D, E, ESign: Integer;
  R, Ten: DoubleDouble;
  HasDigits: Boolean;
begin
  P := PChar(S);
  Sign := 0;
  Point := -1;
  ND := 0;
  E := 0;
  Self := NaN;
  HasDigits := False;
  R.Init;

  while (P^ <= ' ') do
    Inc(P);

  while True do
  begin
    C := P^;
    if (C <= ' ') then
      Break;

    if (C >= '0') and (C <= '9') then
    begin
      D := Ord(C) - Ord('0');
      R := (R * 10) + D;
      Inc(ND);
      HasDigits := True;
    end
    else
    begin
      case C of
        '.',
        ',': begin
               if (Point >= 0) then
                 Exit;
               if (C = FormatSettings.DecimalSeparator) then
                 Point := ND;
             end;

        '-',
        '+': begin
               if (Sign <> 0) or (ND > 0) then
                 Exit;
               if (C = '-') then
                 Sign := -1
               else
                 Sign := 1;
             end;

        'E',
        'e': begin
               if (not HasDigits) then
                 Exit;

               HasDigits := False;
               Inc(P);
               ESign := 0;
               if (P^ = '-') then
               begin
                 ESign := -1;
                 Inc(P);
               end
               else if (P^ = '+') then
                 Inc(P);

               while (P^ >= '0') and (P^ <= '9') do
               begin
                 D := Ord(P^) - Ord('0');
                 E := (E * 10) + D;
                 Inc(P);
                 HasDigits := True;
               end;
               if (not HasDigits) then
                 Exit;

               if (ESign = -1) then
                 E := -E;

               Break;
             end;
      else
        Exit;
      end;
    end;

    Inc(P);
  end;

  if (not HasDigits) then
    Exit;

  if (Point >= 0) then
    Dec(E, ND - Point);

  if (E <> 0) then
  begin
    Ten.Init(10);
    R := R * IntPower(Ten, E);
  end;

  if (Sign = -1) then
    Self := -R
  else
    Self := R;
end;

procedure DoubleDouble.Init(const S: String);
begin
  Init(S, FormatSettings);
end;

function DoubleDouble.IsInfinity: Boolean;
begin
  Result := X[0].IsInfinity;
end;

function DoubleDouble.IsNan: Boolean;
begin
  Result := X[0].IsNan or X[1].IsNan;
end;

function DoubleDouble.IsNegative: Boolean;
begin
  Result := (X[0] < 0);
end;

function DoubleDouble.IsNegativeInfinity: Boolean;
begin
  Result := X[0].IsNegativeInfinity;
end;

function DoubleDouble.IsOne: Boolean;
begin
  Result := (X[0] = 1) and (X[1] = 0);
end;

function DoubleDouble.IsPositive: Boolean;
begin
  Result := (X[0] > 0);
end;

function DoubleDouble.IsPositiveInfinity: Boolean;
begin
  Result := X[0].IsPositiveInfinity;
end;

function DoubleDouble.IsZero: Boolean;
begin
  Result := (X[0] = 0);
end;

class operator DoubleDouble.LessThan(const A: DoubleDouble; const B: Double): Boolean;
begin
  Result := (A.X[0] < B) or ((A.X[0] = B) and (A.X[1] < 0));
end;

class operator DoubleDouble.LessThan(const A, B: DoubleDouble): Boolean;
begin
  Result := (A.X[0] < B.X[0]) or ((A.X[0] = B.X[0]) and (A.X[1] < B.X[1]));
end;

class operator DoubleDouble.LessThan(const A: Double; const B: DoubleDouble): Boolean;
begin
  Result := (A < B.X[0]) or ((A = B.X[0]) and (B.X[1] > 0));
end;

class operator DoubleDouble.LessThanOrEqual(const A, B: DoubleDouble): Boolean;
begin
  Result := (A.X[0] < B.X[0]) or ((A.X[0] = B.X[0]) and (A.X[1] <= B.X[1]));
end;

class operator DoubleDouble.LessThanOrEqual(const A: Double;
  const B: DoubleDouble): Boolean;
begin
  Result := (A < B.X[0]) or ((A = B.X[0]) and (B.X[1] >= 0));
end;

class operator DoubleDouble.LessThanOrEqual(const A: DoubleDouble;
  const B: Double): Boolean;
begin
  Result := (A.X[0] < B) or ((A.X[0] = B) and (A.X[1] <= 0));
end;

class operator DoubleDouble.Multiply(const A, B: DoubleDouble): DoubleDouble;
begin
  _dd_mul(A, B, Result);
end;

class operator DoubleDouble.Multiply(const A: Double; const B: DoubleDouble): DoubleDouble;
begin
  _dd_mul_d_dd(@A, B, Result);
end;

class operator DoubleDouble.Multiply(const A: DoubleDouble; const B: Double): DoubleDouble;
begin
  _dd_mul_dd_d(A, @B, Result);
end;

class operator DoubleDouble.Negative(const A: DoubleDouble): DoubleDouble;
begin
  Result.X[0] := -A.X[0];
  Result.X[1] := -A.X[1];
end;

class operator DoubleDouble.NotEqual(const A, B: DoubleDouble): Boolean;
begin
  Result := (A.X[0] <> B.X[0]) or (A.X[1] <> B.X[1]);
end;

class operator DoubleDouble.NotEqual(const A: DoubleDouble; const B: Double): Boolean;
begin
  Result := (A.X[0] <> B) or (A.X[1] <> 0);
end;

class operator DoubleDouble.NotEqual(const A: Double; const B: DoubleDouble): Boolean;
begin
  Result := (A <> B.X[0]) or (B.X[1] <> 0);
end;

class function DoubleDouble.Parse(const S: String): DoubleDouble;
begin
  Result.Init(S, FormatSettings);
end;

class function DoubleDouble.Parse(const S: String;
  const FormatSettings: TFormatSettings): DoubleDouble;
begin
  Result.Init(S, FormatSettings);
end;

class operator DoubleDouble.Subtract(const A, B: DoubleDouble): DoubleDouble;
begin
  _dd_sub(A, B, Result);
end;

class operator DoubleDouble.Subtract(const A: Double; const B: DoubleDouble): DoubleDouble;
begin
  _dd_sub_d_dd(@A, B, Result);
end;

procedure DoubleDouble.SetExp(const Value: UInt64);
begin
  X[0].Exp := Value;
end;

procedure DoubleDouble.SetSign(const Value: Boolean);
begin
  X[0].Sign := Value;
  X[1].Sign := Value;
end;

class function DoubleDouble.Size: Integer;
begin
  Result := SizeOf(DoubleDouble);
end;

class operator DoubleDouble.Subtract(const A: DoubleDouble; const B: Double): DoubleDouble;
begin
  _dd_sub_dd_d(A, @B, Result);
end;

procedure DoubleDouble.ToDigits(const S: TArray<Char>; var Exponent: Integer;
  const Precision: Integer);
var
  NumDigits, D, E, I: Integer;
  Ten, R: DoubleDouble;
begin
  NumDigits := Precision + 1;
  R := Abs(Self);

  if (X[0] = 0) then
  begin
    Exponent := 0;
    for I := 0 to Precision - 1 do
      S[I] := '0';
    Exit;
  end;

  { First determine the (approximate) exponent. }
  E := System.Trunc(System.Math.Floor(System.Math.Log10(System.Abs(X[0]))));

  Ten.Init(10);
  if (E < -300) then
  begin
    R := R * IntPower(Ten, 300);
    R := R / IntPower(Ten, E + 300);
  end
  else if (E > 300) then
  begin
    R := Ldexp(R, -53);
    R := R / IntPower(Ten, E);
    R := Ldexp(R, 53);
  end
  else
    R := R / IntPower(Ten, E);

  { Fix exponent if we are off by one }
  if (R >= 10) then
  begin
    R := R / 10;
    Inc(E);
  end
  else if (R < 1) then
  begin
    R := R * 10;
    Dec(E);
  end;

  if (R >= 10) or (R < 1) then
    Exit;

  { Extract the digits }
  for I := 0 to NumDigits - 1 do
  begin
    D := System.Trunc(R.X[0]);
    R := R - D;
    R := R * 10;
    S[I] := Char(D + Ord('0'));
  end;

  { Fix out of range digits. }
  for I := NumDigits - 1 downto 1 do
  begin
    if (S[I] < '0') then
    begin
      S[I - 1] := Char(Ord(S[I - 1]) - 1);
      S[I] := Char(Ord(S[I]) + 10);
    end
    else if (S[I] > '9') then
    begin
      S[I - 1] := Char(Ord(S[I - 1]) + 1);
      S[I] := Char(Ord(S[I]) - 10);
    end;
  end;

  if (S[0] <= '0') then
    Exit;

  { Round, handle carry }
  if (S[NumDigits - 1] >= '5') then
  begin
    S[NumDigits - 2] := Char(Ord(S[NumDigits - 2]) + 1);
    I := NumDigits - 2;
    while (I > 0) and (S[I] > '9') do
    begin
      S[I] := Char(Ord(S[I]) - 10);
      Dec(I);
      S[I] := Char(Ord(S[I]) + 1);
    end;
  end;

  { If first digit is 10, shift everything. }
  if (S[0] > '9') then
  begin
    Inc(E);
    for I := Precision downto 2 do
      S[I] := S[I - 1];
    S[0] := '1';
    S[1] := '0';
  end;

  S[Precision] := #0;
  Exponent := E;
end;

function DoubleDouble.ToDouble: Double;
begin
  Result := X[0];
end;

function DoubleDouble.ToInteger: Integer;
begin
  Result := System.Trunc(X[0]);
end;

class function DoubleDouble.ToString(const Value: DoubleDouble;
  const FormatSettings: TFormatSettings; const Format: TMPFloatFormat;
  const Precision: Integer): String;
begin
  Result := Value.ToString(FormatSettings, Format, Precision);
end;

class function DoubleDouble.TryParse(const S: String;
  out Value: DoubleDouble): Boolean;
begin
  Value.Init(S, FormatSettings);
  Result := (not Value.IsNan);
end;

class function DoubleDouble.TryParse(const S: String; out Value: DoubleDouble;
  const FormatSettings: TFormatSettings): Boolean;
begin
  Value.Init(S, FormatSettings);
  Result := (not Value.IsNan);
end;

class function DoubleDouble.ToString(const Value: DoubleDouble;
  const Format: TMPFloatFormat; const Precision: Integer): String;
begin
  Result := Value.ToString(FormatSettings, Format, Precision);
end;

function DoubleDouble.ToString(const Format: TMPFloatFormat;
  const Precision: Integer): String;
begin
  Result := ToString(FormatSettings, Format, Precision);
end;

function DoubleDouble.ToString(const FormatSettings: TFormatSettings;
  const Format: TMPFloatFormat; const Precision: Integer): String;
var
  SB: TStringBuilder;
  FromString: Double;
  Off, D, DWithExtra, I, E: Integer;
  T: TArray<Char>;
begin
  E := 0;
  SB := TStringBuilder.Create;
  try
    if (IsNan) then
      SB.Append('NAN')
    else
    begin
      if (IsNegative) then
        SB.Append('-');

      if (IsInfinity) then
        SB.Append('INF')
      else if IsZero then
      begin
        { Zero case }
        SB.Append('0');
        if (Precision > 0) then
        begin
          SB.Append(FormatSettings.DecimalSeparator);
          SB.Append('0', Precision);
        end;
      end
      else
      begin
        { Non-zero case }
        if (Format = TMPFloatFormat.Fixed) then
          Off := 1 + Floor(Neslib.MultiPrecision.Log10(Abs(Self))).ToInteger
        else
          Off := 1;
        D := Precision + Off;

        DWithExtra := D;
        if (Format = TMPFloatFormat.Fixed) and (D < 60) then
          { Longer than the max accuracy for DD }
          DWithExtra := 60;

        { Highly special case - fixed mode, precision is zero, Abs(Self) < 1.0
          without this trap a number like 0.9 printed fixed with 0 precision
          prints as 0 should be rounded to 1. }
        if (Format = TMPFloatFormat.Fixed) and (Precision = 0) and (Abs(Self) < 1) then
        begin
          if (Abs(Self) >= 0.5) then
            SB.Append('1')
          else
            SB.Append('0');
          Result := SB.ToString;
          Exit;
        end;

        { Handle near zero to working precision (but not exactly zero) }
        if (Format = TMPFloatFormat.Fixed) and (D <= 0) then
        begin
          SB.Append('0');
          if (Precision > 0) then
          begin
            SB.Append(FormatSettings.DecimalSeparator);
            SB.Append('0', Precision);
          end;
        end
        else
        begin
          { Default }
          if (Format = TMPFloatFormat.Fixed) then
          begin
            SetLength(T, DWithExtra + 1);
            ToDigits(T, E, DWithExtra);
          end
          else
          begin
            SetLength(T, D + 1);
            ToDigits(T, E, D);
          end;

          Off := E + 1;
          if (Format = TMPFloatFormat.Fixed) then
          begin
            { Fix the string if it's been computed incorrectly round here in the
              decimal string if required }
            RoundString(T, D, Off);

            if (Off > 0) then
            begin
              SB.Append(T, 0, Off);
              if (Precision > 0) then
              begin
                SB.Append(FormatSettings.DecimalSeparator);
                SB.Append(T, Off, Precision);
              end;
            end
            else
            begin
              SB.Append('0.');
              if (Off < 0) then
                SB.Append('0', -Off);
              SB.Append(T, 0, D)
            end;
          end
          else
          begin
            SB.Append(T[0]);
            if (Precision > 0) then
              SB.Append(FormatSettings.DecimalSeparator);
            SB.Append(T, 1, Precision);
          end;
        end;
      end;

      if (not IsInfinity) then
      begin
        { Trap for improper offset with large values. Without this trap, output of
          values of the for 10^J - 1 fail for J > 28 and are output with the point
          in the wrong place, leading to a dramatically off value }
        if (Format = TMPFloatFormat.Fixed) and (Precision > 0) and (not IsZero) then
        begin
          { Make sure that the value isn't dramatically larger }
          FromString := StrToFloat(SB.ToString, FormatSettings);

          { If this ratio is large, then we've got problems }
          if (System.Abs(FromString / X[0]) > 3) then
          begin
            { Loop on the string, find the point, move it up one.
              Don't act on the first character }
            for I := 1 to SB.Length - 1 do
            begin
              if (SB.Chars[I] = FormatSettings.DecimalSeparator) then
              begin
                SB.Chars[I] := SB.Chars[I - 1];
                SB.Chars[I - 1] := FormatSettings.DecimalSeparator;
                Break;
              end;
            end;
          end;
        end;

        if (Format <> TMPFloatFormat.Fixed) then
        begin
          { Fill in exponent part }
          SB.Append('E');
          AppendExponent(SB, E);
        end;
      end;
    end;

    Result := SB.ToString;
  finally
    SB.Free;
  end;
end;

{ QuadDouble }

class operator QuadDouble.Add(const A: QuadDouble; const B: Double): QuadDouble;
begin
  _qd_add_qd_d(A, @B, Result);
end;

class operator QuadDouble.Add(const A, B: QuadDouble): QuadDouble;
begin
  _qd_add(A, B, Result);
end;

class operator QuadDouble.Add(const A: Double; const B: QuadDouble): QuadDouble;
begin
  _qd_add_qd_d(B, @A, Result);
end;

class operator QuadDouble.Add(const A: DoubleDouble; const B: QuadDouble): QuadDouble;
begin
  _qd_add_qd_dd(B, A, Result);
end;

class operator QuadDouble.Add(const A: QuadDouble; const B: DoubleDouble): QuadDouble;
begin
  _qd_add_qd_dd(A, B, Result);
end;

procedure QuadDouble.Clear;
begin
  X[0] := 0;
  X[1] := 0;
  X[2] := 0;
  X[3] := 0;
end;

class operator QuadDouble.Divide(const A: Double; const B: QuadDouble): QuadDouble;
begin
  _qd_div_d_qd(@A, B, Result);
end;

class operator QuadDouble.Divide(const A, B: QuadDouble): QuadDouble;
begin
  _qd_div(A, B, Result);
end;

class operator QuadDouble.Divide(const A: QuadDouble; const B: Double): QuadDouble;
begin
  _qd_div_qd_d(A, @B, Result);
end;

class operator QuadDouble.Divide(const A: DoubleDouble; const B: QuadDouble): QuadDouble;
begin
  _qd_div_dd_qd(A, B, Result);
end;

class operator QuadDouble.Divide(const A: QuadDouble; const B: DoubleDouble): QuadDouble;
begin
  _qd_div_qd_dd(A, B, Result);
end;

class operator QuadDouble.Equal(const A: Double; const B: QuadDouble): Boolean;
begin
  Result := (B.X[0] = A) and (B.X[1] = 0) and (B.X[2] = 0) and (B.X[3] = 0);
end;

class operator QuadDouble.Equal(const A: QuadDouble; const B: Double): Boolean;
begin
  Result := (A.X[0] = B) and (A.X[1] = 0) and (A.X[2] = 0) and (A.X[3] = 0);
end;

class operator QuadDouble.Equal(const A, B: QuadDouble): Boolean;
begin
  Result := (A.X[0] = B.X[0]) and (A.X[1] = B.X[1]) and (A.X[2] = B.X[2]) and (A.X[3] = B.X[3]);
end;

class operator QuadDouble.Equal(const A: QuadDouble; const B: DoubleDouble): Boolean;
begin
  Result := (A.X[0] = B.X[0]) and (A.X[1] = B.X[1]) and (A.X[2] = 0) and (A.X[3] = 0);
end;

class operator QuadDouble.Equal(const A: DoubleDouble; const B: QuadDouble): Boolean;
begin
  Result := (A.X[0] = B.X[0]) and (A.X[1] = B.X[1]) and (B.X[2] = 0) and (B.X[3] = 0);
end;

function QuadDouble.Equals(const A: DoubleDouble): Boolean;
begin
  Result := (X[0] = A.X[0]) and (X[1] = A.X[1]) and (X[2] = 0) and (X[3] = 0);
end;

function QuadDouble.Equals(const A: QuadDouble): Boolean;
begin
  Result := (A.X[0] = X[0]) and (A.X[1] = X[1]) and (A.X[2] = X[2]) and (A.X[3] = X[3]);
end;

function QuadDouble.Equals(const A: Double): Boolean;
begin
  Result := (X[0] = A) and (X[1] = 0) and (X[2] = 0) and (X[3] = 0);
end;

class operator QuadDouble.GreaterThan(const A: QuadDouble;
  const B: Double): Boolean;
begin
  Result := (A.X[0] > B) or ((A.X[0] = B) and (A.X[1] > 0));
end;

class operator QuadDouble.GreaterThan(const A: Double;
  const B: QuadDouble): Boolean;
begin
  Result := (B < A);
end;

class operator QuadDouble.GreaterThan(const A, B: QuadDouble): Boolean;
begin
  Result := (A.X[0] > B.X[0]) or
           ((A.X[0] = B.X[0]) and ((A.X[1] > B.X[1]) or
                                  ((A.X[1] = B.X[1]) and ((A.X[2] > B.X[2]) or
                                                         ((A.X[2] = B.X[2]) and (A.X[3] > B.X[3]))))));
end;

class operator QuadDouble.GreaterThan(const A: QuadDouble;
  const B: DoubleDouble): Boolean;
begin
  Result := (A.X[0] > B.X[0]) or
           ((A.X[0] = B.X[0]) and ((A.X[1] > B.X[1]) or
                                  ((A.X[1] = B.X[1]) and ((A.X[2] > 0)))));
end;

function QuadDouble.GetExp: UInt64;
begin
  Result := X[0].Exp;
end;

function QuadDouble.GetSign: Boolean;
begin
  Result := X[0].Sign;
end;

function QuadDouble.GetSpecialType: TFloatSpecial;
begin
  if (IsZero) then
  begin
    if (PUInt64(@Self)^ = $8000000000000000) then
      Result := fsNZero
    else
      Result := fsZero;
  end
  else if (IsPositiveInfinity) then
    Result := fsInf
  else if (IsNegative) then
    Result := fsNInf
  else if (IsNaN) then
    Result := fsNaN
  else if (IsPositive) then
    Result := fsPositive
  else
    Result := fsNegative;
end;

class operator QuadDouble.GreaterThan(const A: DoubleDouble;
  const B: QuadDouble): Boolean;
begin
  Result := (B < A);
end;

class operator QuadDouble.GreaterThanOrEqual(const A, B: QuadDouble): Boolean;
begin
  Result := (A.X[0] > B.X[0]) or
           ((A.X[0] = B.X[0]) and ((A.X[1] > B.X[1]) or
                                  ((A.X[1] = B.X[1]) and ((A.X[2] > B.X[2]) or
                                                         ((A.X[2] = B.X[2]) and (A.X[3] >= B.X[3]))))));
end;

class operator QuadDouble.GreaterThanOrEqual(const A: Double;
  const B: QuadDouble): Boolean;
begin
  Result := (B <= A);
end;

class operator QuadDouble.GreaterThanOrEqual(const A: QuadDouble;
  const B: Double): Boolean;
begin
  Result := (A.X[0] > B) or ((A.X[0] = B) and (A.X[1] >= 0));
end;

class operator QuadDouble.GreaterThanOrEqual(const A: QuadDouble;
  const B: DoubleDouble): Boolean;
begin
  Result := (A.X[0] > B.X[0]) or
           ((A.X[0] = B.X[0]) and ((A.X[1] > B.X[1]) or
                                  ((A.X[1] = B.X[1]) and (A.X[2] >= 0))));
end;

class operator QuadDouble.GreaterThanOrEqual(const A: DoubleDouble;
  const B: QuadDouble): Boolean;
begin
  Result := (B <= A);
end;

class operator QuadDouble.Implicit(const S: String): QuadDouble;
begin
  Result.Init(S, _USFormatSettings);
  if (Result.IsNan) then
    raise EConvertError.CreateResFmt(@SInvalidFloat, [S]);
end;

class operator QuadDouble.Explicit(const Value: DoubleDouble): QuadDouble;
begin
  Result.Init(Value);
end;

class operator QuadDouble.Explicit(const Value: Double): QuadDouble;
begin
  Result.Init(Value);
end;

procedure QuadDouble.Init;
begin
  X[0] := 0;
  X[1] := 0;
  X[2] := 0;
  X[3] := 0;
end;

procedure QuadDouble.Init(const Value: Double);
begin
  X[0] := Value;
  X[1] := 0;
  X[2] := 0;
  X[3] := 0;
end;

procedure QuadDouble.Init(const Value: DoubleDouble);
begin
  X[0] := Value.X[0];
  X[1] := Value.X[1];
  X[2] := 0;
  X[3] := 0;
end;

procedure QuadDouble.Init(const X0, X1, X2, X3: Double);
begin
  X[0] := X0;
  X[1] := X1;
  X[2] := X2;
  X[3] := X3;
end;

procedure QuadDouble.Init(const S: String;
  const FormatSettings: TFormatSettings);
var
  P: PChar;
  C: Char;
  Sign, Point, ND, D, E, ESign: Integer;
  R, Ten: QuadDouble;
  HasDigits: Boolean;
begin
  P := PChar(S);
  Sign := 0;
  Point := -1;
  ND := 0;
  E := 0;
  Self := NaN;
  HasDigits := False;
  R.Init;

  while (P^ <= ' ') do
    Inc(P);

  while True do
  begin
    C := P^;
    if (C <= ' ') then
      Break;

    if (C >= '0') and (C <= '9') then
    begin
      D := Ord(C) - Ord('0');
      R := (R * 10) + D;
      Inc(ND);
      HasDigits := True;
    end
    else
    begin
      case C of
        '.',
        ',': begin
               if (Point >= 0) then
                 Exit;
               if (C = FormatSettings.DecimalSeparator) then
                 Point := ND;
             end;

        '-',
        '+': begin
               if (Sign <> 0) or (ND > 0) then
                 Exit;
               if (C = '-') then
                 Sign := -1
               else
                 Sign := 1;
             end;

        'E',
        'e': begin
               if (not HasDigits) then
                 Exit;

               HasDigits := False;
               Inc(P);
               ESign := 0;
               if (P^ = '-') then
               begin
                 ESign := -1;
                 Inc(P);
               end
               else if (P^ = '+') then
                 Inc(P);

               while (P^ >= '0') and (P^ <= '9') do
               begin
                 D := Ord(P^) - Ord('0');
                 E := (E * 10) + D;
                 Inc(P);
                 HasDigits := True;
               end;
               if (not HasDigits) then
                 Exit;

               if (ESign = -1) then
                 E := -E;

               Break;
             end;
      else
        Exit;
      end;
    end;

    Inc(P);
  end;

  if (not HasDigits) then
    Exit;

  if (Point >= 0) then
    Dec(E, ND - Point);

  if (E <> 0) then
  begin
    Ten.Init(10);
    R := R * IntPower(Ten, E);
  end;

  if (Sign = -1) then
    Self := -R
  else
    Self := R;
end;

procedure QuadDouble.Init(const S: String);
begin
  Init(S, FormatSettings);
end;

function QuadDouble.IsInfinity: Boolean;
begin
  Result := X[0].IsInfinity;
end;

function QuadDouble.IsNan: Boolean;
begin
  Result := X[0].IsNan or X[1].IsNan or X[2].IsNan or X[3].IsNan;
end;

function QuadDouble.IsNegative: Boolean;
begin
  Result := (X[0] < 0);
end;

function QuadDouble.IsNegativeInfinity: Boolean;
begin
  Result := X[0].IsNegativeInfinity;
end;

function QuadDouble.IsOne: Boolean;
begin
  Result := (X[0] = 1) and (X[1] = 0) and (X[2] = 0) and (X[3] = 0);
end;

function QuadDouble.IsPositive: Boolean;
begin
  Result := (X[0] > 0);
end;

function QuadDouble.IsPositiveInfinity: Boolean;
begin
  Result := X[0].IsPositiveInfinity;
end;

function QuadDouble.IsZero: Boolean;
begin
  Result := (X[0] = 0);
end;

class operator QuadDouble.LessThan(const A: Double; const B: QuadDouble): Boolean;
begin
  Result := (B > A);
end;

class operator QuadDouble.LessThan(const A, B: QuadDouble): Boolean;
begin
  Result := (A.X[0] < B.X[0]) or
           ((A.X[0] = B.X[0]) and ((A.X[1] < B.X[1]) or
                                  ((A.X[1] = B.X[1]) and ((A.X[2] < B.X[2]) or
                                                         ((A.X[2] = B.X[2]) and (A.X[3] < B.X[3]))))));
end;

class operator QuadDouble.LessThan(const A: QuadDouble; const B: Double): Boolean;
begin
  Result := (A.X[0] < B) or ((A.X[0] = B) and (A.X[1] < 0));
end;

class operator QuadDouble.LessThan(const A: QuadDouble; const B: DoubleDouble): Boolean;
begin
  Result := (A.X[0] < B.X[0]) or
           ((A.X[0] = B.X[0]) and ((A.X[1] < B.X[1]) or
                                  ((A.X[1] = B.X[1]) and ((A.X[2] < 0)))));
end;

class operator QuadDouble.LessThan(const A: DoubleDouble; const B: QuadDouble): Boolean;
begin
  Result := (B > A);
end;

class operator QuadDouble.LessThanOrEqual(const A: Double;
  const B: QuadDouble): Boolean;
begin
  Result := (B >= A);
end;

class operator QuadDouble.LessThanOrEqual(const A: QuadDouble;
  const B: Double): Boolean;
begin
  Result := (A.X[0] < B) or ((A.X[0] = B) and (A.X[1] <= 0));
end;

class operator QuadDouble.LessThanOrEqual(const A, B: QuadDouble): Boolean;
begin
  Result := (A.X[0] < B.X[0]) or
           ((A.X[0] = B.X[0]) and ((A.X[1] < B.X[1]) or
                                  ((A.X[1] = B.X[1]) and ((A.X[2] < B.X[2]) or
                                                         ((A.X[2] = B.X[2]) and (A.X[3] <= B.X[3]))))));
end;

class operator QuadDouble.LessThanOrEqual(const A: QuadDouble;
  const B: DoubleDouble): Boolean;
begin
  Result := (A.X[0] < B.X[0]) or
           ((A.X[0] = B.X[0]) and ((A.X[1] < B.X[1]) or
                                  ((A.X[1] = B.X[1]) and (A.X[2] <= 0))));
end;

class operator QuadDouble.LessThanOrEqual(const A: DoubleDouble;
  const B: QuadDouble): Boolean;
begin
  Result := (B >= A);
end;

class operator QuadDouble.Multiply(const A: Double; const B: QuadDouble): QuadDouble;
begin
  _qd_mul_d_qd(@A, B, Result);
end;

class operator QuadDouble.Multiply(const A, B: QuadDouble): QuadDouble;
begin
  _qd_mul(A, B, Result);
end;

class operator QuadDouble.Multiply(const A: QuadDouble; const B: Double): QuadDouble;
begin
  _qd_mul_qd_d(A, @B, Result);
end;

class operator QuadDouble.Multiply(const A: DoubleDouble;
  const B: QuadDouble): QuadDouble;
begin
  _qd_mul_qd_dd(B, A, Result);
end;

class operator QuadDouble.Multiply(const A: QuadDouble;
  const B: DoubleDouble): QuadDouble;
begin
  _qd_mul_qd_dd(A, B, Result);
end;

class operator QuadDouble.Negative(const A: QuadDouble): QuadDouble;
begin
  Result.X[0] := -A.X[0];
  Result.X[1] := -A.X[1];
  Result.X[2] := -A.X[2];
  Result.X[3] := -A.X[3];
end;

class operator QuadDouble.NotEqual(const A: Double; const B: QuadDouble): Boolean;
begin
  Result := not (A = B);
end;

class operator QuadDouble.NotEqual(const A: QuadDouble; const B: Double): Boolean;
begin
  Result := not (A = B);
end;

class operator QuadDouble.NotEqual(const A, B: QuadDouble): Boolean;
begin
  Result := not (A = B);
end;

class operator QuadDouble.NotEqual(const A: QuadDouble; const B: DoubleDouble): Boolean;
begin
  Result := not (A = B);
end;

class operator QuadDouble.NotEqual(const A: DoubleDouble; const B: QuadDouble): Boolean;
begin
  Result := not (A = B);
end;

class function QuadDouble.Parse(const S: String): QuadDouble;
begin
  Result.Init(S, FormatSettings);
end;

class function QuadDouble.Parse(const S: String;
  const FormatSettings: TFormatSettings): QuadDouble;
begin
  Result.Init(S, FormatSettings);
end;

class operator QuadDouble.Subtract(const A: DoubleDouble;
  const B: QuadDouble): QuadDouble;
begin
  _qd_sub_dd_qd(A, B, Result);
end;

procedure QuadDouble.SetExp(const Value: UInt64);
begin
  X[0].Exp := Value;
end;

procedure QuadDouble.SetSign(const Value: Boolean);
begin
  X[0].Sign := Value;
  X[1].Sign := Value;
  X[2].Sign := Value;
  X[3].Sign := Value;
end;

class function QuadDouble.Size: Integer;
begin
  Result := SizeOf(QuadDouble);
end;

class operator QuadDouble.Subtract(const A: QuadDouble;
  const B: DoubleDouble): QuadDouble;
begin
  _qd_sub_qd_dd(A, B, Result);
end;

class operator QuadDouble.Subtract(const A, B: QuadDouble): QuadDouble;
begin
  _qd_sub(A, B, Result);
end;

class operator QuadDouble.Subtract(const A: Double; const B: QuadDouble): QuadDouble;
begin
  _qd_sub_d_qd(@A, B, Result);
end;

class operator QuadDouble.Subtract(const A: QuadDouble; const B: Double): QuadDouble;
begin
  _qd_sub_qd_d(A, @B, Result);
end;

procedure QuadDouble.ToDigits(const S: TArray<Char>; var Exponent: Integer;
  const Precision: Integer);
var
  NumDigits, D, E, I: Integer;
  Ten, R: QuadDouble;
begin
  NumDigits := Precision + 1;
  R := Abs(Self);

  if (X[0] = 0) then
  begin
    Exponent := 0;
    for I := 0 to Precision - 1 do
      S[I] := '0';
    Exit;
  end;

  { First determine the (approximate) exponent. }
  E := System.Trunc(System.Math.Floor(System.Math.Log10(System.Abs(X[0]))));

  Ten.Init(10);
  if (E < -300) then
  begin
    R := R * IntPower(Ten, 300);
    R := R / IntPower(Ten, E + 300);
  end
  else if (E > 300) then
  begin
    R := Ldexp(R, -53);
    R := R / IntPower(Ten, E);
    R := Ldexp(R, 53);
  end
  else
    R := R / IntPower(Ten, E);

  { Fix exponent if we are off by one }
  if (R >= 10) then
  begin
    R := R / 10;
    Inc(E);
  end
  else if (R < 1) then
  begin
    R := R * 10;
    Dec(E);
  end;

  if (R >= 10) or (R < 1) then
    Exit;

  { Extract the digits }
  for I := 0 to NumDigits - 1 do
  begin
    D := System.Trunc(R.X[0]);
    R := R - D;
    R := R * 10.0;
    S[I] := Char(D + Ord('0'));
  end;

  { Fix out of range digits. }
  for I := NumDigits - 1 downto 1 do
  begin
    if (S[I] < '0') then
    begin
      S[I - 1] := Char(Ord(S[I - 1]) - 1);
      S[I] := Char(Ord(S[I]) + 10);
    end
    else if (S[I] > '9') then
    begin
      S[I - 1] := Char(Ord(S[I - 1]) + 1);
      S[I] := Char(Ord(S[I]) - 10);
    end;
  end;

  if (S[0] <= '0') then
    Exit;

  { Round, handle carry }
  if (S[NumDigits - 1] >= '5') then
  begin
    S[NumDigits - 2] := Char(Ord(S[NumDigits - 2]) + 1);
    I := NumDigits - 2;
    while (I > 0) and (S[I] > '9') do
    begin
      S[I] := Char(Ord(S[I]) - 10);
      Dec(I);
      S[I] := Char(Ord(S[I]) + 1);
    end;
  end;

  { If first digit is 10, shift everything. }
  if (S[0] > '9') then
  begin
    Inc(E);
    for I := Precision downto 2 do
      S[I] := S[I - 1];
    S[0] := '1';
    S[1] := '0';
  end;

  S[Precision] := #0;
  Exponent := E;
end;

function QuadDouble.ToDouble: Double;
begin
  Result := X[0];
end;

function QuadDouble.ToDoubleDouble: DoubleDouble;
begin
  Result.Init(X[0], X[1]);
end;

function QuadDouble.ToInteger: Integer;
begin
  Result := System.Trunc(X[0]);
end;

class function QuadDouble.ToString(const Value: QuadDouble;
  const FormatSettings: TFormatSettings; const Format: TMPFloatFormat;
  const Precision: Integer): String;
begin
  Result := Value.ToString(FormatSettings, Format, Precision);
end;

class function QuadDouble.TryParse(const S: String;
  out Value: QuadDouble): Boolean;
begin
  Value.Init(S, FormatSettings);
  Result := (not Value.IsNan);
end;

class function QuadDouble.TryParse(const S: String; out Value: QuadDouble;
  const FormatSettings: TFormatSettings): Boolean;
begin
  Value.Init(S, FormatSettings);
  Result := (not Value.IsNan);
end;

class function QuadDouble.ToString(const Value: QuadDouble;
  const Format: TMPFloatFormat; const Precision: Integer): String;
begin
  Result := Value.ToString(FormatSettings, Format, Precision);
end;

function QuadDouble.ToString(const Format: TMPFloatFormat;
  const Precision: Integer): String;
begin
  Result := ToString(FormatSettings, Format, Precision);
end;

function QuadDouble.ToString(const FormatSettings: TFormatSettings;
  const Format: TMPFloatFormat; const Precision: Integer): String;
var
  SB: TStringBuilder;
  FromString: Double;
  Off, D, DWithExtra, I, E: Integer;
  T: TArray<Char>;
begin
  E := 0;
  SB := TStringBuilder.Create;
  try
    if (IsNan) then
      SB.Append('NAN')
    else
    begin
      if (IsNegative) then
        SB.Append('-');

      if (IsInfinity) then
        SB.Append('INF')
      else if IsZero then
      begin
        { Zero case }
        SB.Append('0');
        if (Precision > 0) then
        begin
          SB.Append(FormatSettings.DecimalSeparator);
          SB.Append('0', Precision);
        end;
      end
      else
      begin
        { Non-zero case }
        if (Format = TMPFloatFormat.Fixed) then
          Off := 1 + Floor(Neslib.MultiPrecision.Log10(Abs(Self))).ToInteger
        else
          Off := 1;
        D := Precision + Off;

        DWithExtra := D;
        if (Format = TMPFloatFormat.Fixed) and (D < 120) then
          { Longer than the max accuracy for DD }
          DWithExtra := 120;

        { Highly special case - fixed mode, precision is zero, Abs(Self) < 1.0
          without this trap a number like 0.9 printed fixed with 0 precision
          prints as 0 should be rounded to 1. }
        if (Format = TMPFloatFormat.Fixed) and (Precision = 0) and (Abs(Self) < 1) then
        begin
          if (Abs(Self) >= 0.5) then
            SB.Append('1')
          else
            SB.Append('0');
          Result := SB.ToString;
          Exit;
        end;

        { Handle near zero to working precision (but not exactly zero) }
        if (Format = TMPFloatFormat.Fixed) and (D <= 0) then
        begin
          SB.Append('0');
          if (Precision > 0) then
          begin
            SB.Append(FormatSettings.DecimalSeparator);
            SB.Append('0', Precision);
          end;
        end
        else
        begin
          { Default }
          if (Format = TMPFloatFormat.Fixed) then
          begin
            SetLength(T, DWithExtra + 1);
            ToDigits(T, E, DWithExtra);
          end
          else
          begin
            SetLength(T, D + 1);
            ToDigits(T, E, D);
          end;

          Off := E + 1;
          if (Format = TMPFloatFormat.Fixed) then
          begin
            { Fix the string if it's been computed incorrectly round here in the
              decimal string if required }
            RoundString(T, D, Off);

            if (Off > 0) then
            begin
              SB.Append(T, 0, Off);
              if (Precision > 0) then
              begin
                SB.Append(FormatSettings.DecimalSeparator);
                SB.Append(T, Off, Precision);
              end;
            end
            else
            begin
              SB.Append('0.');
              if (Off < 0) then
                SB.Append('0', -Off);
              SB.Append(T, 0, D)
            end;
          end
          else
          begin
            SB.Append(T[0]);
            if (Precision > 0) then
              SB.Append(FormatSettings.DecimalSeparator);
            SB.Append(T, 1, Precision);
          end;
        end;
      end;

      if (not IsInfinity) then
      begin
        { Trap for improper offset with large values. Without this trap, output of
          values of the for 10^J - 1 fail for J > 28 and are output with the point
          in the wrong place, leading to a dramatically off value }
        if (Format = TMPFloatFormat.Fixed) and (Precision > 0) and (not IsZero) then
        begin
          { Make sure that the value isn't dramatically larger }
          FromString := StrToFloat(SB.ToString, FormatSettings);

          { If this ratio is large, then we've got problems }
          if (System.Abs(FromString / X[0]) > 3) then
          begin
            { Loop on the string, find the point, move it up one.
              Don't act on the first character }
            for I := 1 to SB.Length - 1 do
            begin
              if (SB.Chars[I] = FormatSettings.DecimalSeparator) then
              begin
                SB.Chars[I] := SB.Chars[I - 1];
                SB.Chars[I - 1] := FormatSettings.DecimalSeparator;
                Break;
              end;
            end;
          end;
        end;

        if (Format <> TMPFloatFormat.Fixed) then
        begin
          { Fill in exponent part }
          SB.Append('E');
          AppendExponent(SB, E);
        end;
      end;
    end;

    Result := SB.ToString;
  finally
    SB.Free;
  end;
end;

initialization
  Initialize;

end.
