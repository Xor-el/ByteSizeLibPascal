unit uByteSize;

{$ZEROBASEDSTRINGS ON}
{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

interface

uses

{$IFDEF FPC}
  SysUtils, StrUtils
{$ELSE}
    System.SysUtils, System.StrUtils, System.Generics.Defaults
{$ENDIF};

type

  TByteSize = record

  public

    Bits: Int64;
    Bytes: Double;
    KiloBytes: Double;
    MegaBytes: Double;
    GigaBytes: Double;
    TeraBytes: Double;
    PetaBytes: Double;

  strict private

    function GetMinValue: TByteSize;
    function GetMaxValue: TByteSize;

    function LargestWholeNumberSymbol: String;
    function LargestWholeNumberValue: Double;

    function has(const SubStr: String; const Str: String): Boolean;
    function output(n: Double; formatsettings: TFormatSettings;
      const formatstr: String): String;

    { Utils }

    class function Contains(InChar: Char; const InString: String)
      : Boolean; static;
    class function IndexOf(const SubStr: String; const Str: String;
      caseSensitive: Boolean): Integer; static;
    class function IsNullOrWhiteSpace(const InValue: string): Boolean; static;
    class function FloatingMod(a: Double; b: Double): Double; static;

  const

    Int64MaxValue = Int64(9223372036854775807);

    BitsInByte = Int64(8);
    BytesInKiloByte = Int64(1024);
    BytesInMegaByte = Int64(1048576);
    BytesInGigaByte = Int64(1073741824);
    BytesInTeraByte = Int64(1099511627776);
    BytesInPetaByte = Int64(1125899906842624);

    BitSymbol = 'b';
    ByteSymbol = 'B';
    KiloByteSymbol = 'KB';
    MegaByteSymbol = 'MB';
    GigaByteSymbol = 'GB';
    TeraByteSymbol = 'TB';
    PetaByteSymbol = 'PB';

  public

    property MinValue: TByteSize read GetMinValue;
    property MaxValue: TByteSize read GetMaxValue;

    constructor Create(byteSize: Double);

    class function FromBits(value: Int64): TByteSize; static;
    class function FromBytes(value: Double): TByteSize; static;
    class function FromKiloBytes(value: Double): TByteSize; static;
    class function FromMegaBytes(value: Double): TByteSize; static;
    class function FromGigaBytes(value: Double): TByteSize; static;
    class function FromTeraBytes(value: Double): TByteSize; static;
    class function FromPetaBytes(value: Double): TByteSize; static;

    class function TryParse(const s: String; out varresult: TByteSize)
      : Boolean; static;
    class function Parse(const s: String): TByteSize; static;

    /// <summary>
    /// Converts the value of the current ByteSize object to a string.
    /// The metric prefix symbol (bit, byte, kilo, mega, giga, tera) used is
    /// the largest metric prefix such that the corresponding value is greater
    // than or equal to one.
    /// </summary>
    function ToString: String; overload;
    function ToString(lformat: String): String; overload;
    function ToString(lformat: String; formatsettings: TFormatSettings)
      : String; overload;

    function Equals(value: TByteSize): Boolean;
    function CompareTo(other: TByteSize): Integer;

    function Add(bs: TByteSize): TByteSize;
    function AddBits(value: Int64): TByteSize;
    function AddBytes(value: Double): TByteSize;
    function AddKiloBytes(value: Double): TByteSize;
    function AddMegaBytes(value: Double): TByteSize;
    function AddGigaBytes(value: Double): TByteSize;
    function AddTeraBytes(value: Double): TByteSize;
    function AddPetaBytes(value: Double): TByteSize;
    function Subtract(bs: TByteSize): TByteSize;

    class operator Add(b1: TByteSize; b2: TByteSize): TByteSize;
    class operator Subtract(b1: TByteSize; b2: TByteSize): TByteSize;
    class operator Inc(b: TByteSize): TByteSize;
    class operator Dec(b: TByteSize): TByteSize;
    class operator Positive(b: TByteSize): TByteSize;
    class operator Negative(b: TByteSize): TByteSize;
    class operator Equal(b1: TByteSize; b2: TByteSize): Boolean;
    class operator NotEqual(b1: TByteSize; b2: TByteSize): Boolean;
    class operator LessThan(b1: TByteSize; b2: TByteSize): Boolean;
    class operator LessThanOrEqual(b1: TByteSize; b2: TByteSize): Boolean;
    class operator GreaterThan(b1: TByteSize; b2: TByteSize): Boolean;
    class operator GreaterThanOrEqual(b1: TByteSize; b2: TByteSize): Boolean;

  end;

  EFormatException = class(Exception);
{$IFDEF FPC}
  EArgumentNilException = class(Exception);
{$ENDIF}

implementation

constructor TByteSize.Create(byteSize: Double);
var
  tempDouble: Double;
begin
  tempDouble := byteSize * BitsInByte;
  // Get Truncation because bits are whole units
  Bits := Trunc(tempDouble);

  Bytes := byteSize;
  KiloBytes := byteSize / BytesInKiloByte;
  MegaBytes := byteSize / BytesInMegaByte;
  GigaBytes := byteSize / BytesInGigaByte;
  TeraBytes := byteSize / BytesInTeraByte;
  PetaBytes := byteSize / BytesInPetaByte;

end;

function TByteSize.LargestWholeNumberSymbol: String;
begin

  // Absolute value is used to deal with negative values
  if (Abs(Self.PetaBytes) >= 1) then
  begin
    result := TByteSize.PetaByteSymbol;
    Exit;
  end;

  if (Abs(Self.TeraBytes) >= 1) then
  begin
    result := TByteSize.TeraByteSymbol;
    Exit;
  end;

  if (Abs(Self.GigaBytes) >= 1) then
  begin
    result := TByteSize.GigaByteSymbol;
    Exit;
  end;

  if (Abs(Self.MegaBytes) >= 1) then
  begin
    result := TByteSize.MegaByteSymbol;
    Exit;
  end;

  if (Abs(Self.KiloBytes) >= 1) then
  begin
    result := TByteSize.KiloByteSymbol;
    Exit;
  end;

  if (Abs(Self.Bytes) >= 1) then
  begin
    result := TByteSize.ByteSymbol;
    Exit;
  end;

  result := TByteSize.BitSymbol;

end;

function TByteSize.LargestWholeNumberValue: Double;
begin

  // Absolute value is used to deal with negative values
  if (Abs(Self.PetaBytes) >= 1) then
  begin
    result := Self.PetaBytes;
    Exit;
  end;

  if (Abs(Self.TeraBytes) >= 1) then
  begin
    result := Self.TeraBytes;
    Exit;
  end;

  if (Abs(Self.GigaBytes) >= 1) then
  begin
    result := Self.GigaBytes;
    Exit;
  end;

  if (Abs(Self.MegaBytes) >= 1) then
  begin
    result := Self.MegaBytes;
    Exit;
  end;

  if (Abs(Self.KiloBytes) >= 1) then
  begin
    result := Self.KiloBytes;
    Exit;
  end;

  if (Abs(Self.Bytes) >= 1) then
  begin
    result := Self.Bytes;
    Exit;
  end;

  result := Self.Bits;
end;

class function TByteSize.FromBits(value: Int64): TByteSize;
var
  tempDouble, dBitsInByte: Double;
begin
  dBitsInByte := BitsInByte * 1.0;
  tempDouble := value / dBitsInByte;
  result := TByteSize.Create(tempDouble);
end;

class function TByteSize.FromBytes(value: Double): TByteSize;
begin
  result := TByteSize.Create(value);
end;

class function TByteSize.FromKiloBytes(value: Double): TByteSize;
var
  tempDouble: Double;
begin
  tempDouble := value * BytesInKiloByte;
  result := TByteSize.Create(tempDouble);
end;

class function TByteSize.FromMegaBytes(value: Double): TByteSize;
var
  tempDouble: Double;
begin
  tempDouble := value * BytesInMegaByte;
  result := TByteSize.Create(tempDouble);
end;

class function TByteSize.FromGigaBytes(value: Double): TByteSize;
var
  tempDouble: Double;
begin
  tempDouble := value * BytesInGigaByte;
  result := TByteSize.Create(tempDouble);
end;

class function TByteSize.FromTeraBytes(value: Double): TByteSize;
var
  tempDouble: Double;
begin
  tempDouble := value * BytesInTeraByte;
  result := TByteSize.Create(tempDouble);
end;

class function TByteSize.FromPetaBytes(value: Double): TByteSize;
var
  tempDouble: Double;
begin
  tempDouble := value * BytesInPetaByte;
  result := TByteSize.Create(tempDouble);
end;

function TByteSize.ToString: String;
var
  lFormatSettings: TFormatSettings;
begin
{$IFDEF FPC}
  GetLocaleFormatSettings(0, lFormatSettings);
{$ELSE}
  lFormatSettings := TFormatSettings.Create;
{$ENDIF}
  result := Self.ToString('#.##', lFormatSettings);

end;

function TByteSize.ToString(lformat: String): String;
var
  lFormatSettings: TFormatSettings;
begin
{$IFDEF FPC}
  GetLocaleFormatSettings(0, lFormatSettings);
{$ELSE}
  lFormatSettings := TFormatSettings.Create;
{$ENDIF}
  result := Self.ToString(lformat, lFormatSettings);
end;

function TByteSize.ToString(lformat: String;
  formatsettings: TFormatSettings): String;

{$IFNDEF FPC}
var
  comparer: IComparer<TFormatSettings>;
{$ENDIF}
begin
  if ((not Contains('#', lformat)) and (not Contains('0', lformat))) then
  begin
    lformat := '#.## ' + lformat;
  end;

{$IFDEF FPC}
  if formatsettings.DecimalSeparator = '' then
  begin
    GetLocaleFormatSettings(0, formatsettings);
  end;
{$ELSE}
  comparer := TComparer<TFormatSettings>.Default;

  if comparer.Compare(formatsettings, Default (TFormatSettings)) = 0 then
    formatsettings := TFormatSettings.Create;
{$ENDIF}
  if (has('PB', lformat)) then
  begin
    result := output(Self.PetaBytes, formatsettings, lformat);
    Exit;
  end;
  if (has('TB', lformat)) then
  begin
    result := output(Self.TeraBytes, formatsettings, lformat);
    Exit;
  end;
  if (has('GB', lformat)) then
  begin
    result := output(Self.GigaBytes, formatsettings, lformat);
    Exit;
  end;
  if (has('MB', lformat)) then
  begin
    result := output(Self.MegaBytes, formatsettings, lformat);
    Exit;
  end;
  if (has('KB', lformat)) then
  begin
    result := output(Self.KiloBytes, formatsettings, lformat);
    Exit;
  end;
  // Byte and Bit symbol must be case-sensitive
  if (IndexOf(TByteSize.ByteSymbol, lformat, True) <> -1) then
  begin
    result := output(Self.Bytes, formatsettings, lformat);
    Exit;
  end;

  if (IndexOf(TByteSize.BitSymbol, lformat, True) <> -1) then
  begin
    result := output(Self.Bits, formatsettings, lformat);
    Exit;
  end;

  result := Format('%s %s', [FormatFloat(lformat, Self.LargestWholeNumberValue,
    formatsettings), Self.LargestWholeNumberSymbol]);

end;

function TByteSize.Equals(value: TByteSize): Boolean;
begin
  result := Self.Bits = value.Bits;
end;

function TByteSize.CompareTo(other: TByteSize): Integer;
begin
  if Self.Bits = other.Bits then
  begin
    result := 0;
    Exit;
  end;

  if Self.Bits < other.Bits then
  begin
    result := -1;
    Exit;
  end
  else
  begin
    result := 1;
    Exit;
  end;

end;

function TByteSize.Add(bs: TByteSize): TByteSize;
begin
  result := TByteSize.Create(Self.Bytes + bs.Bytes);
end;

function TByteSize.AddBits(value: Int64): TByteSize;
begin
  result := Self + FromBits(value);
end;

function TByteSize.AddBytes(value: Double): TByteSize;
begin
  result := Self + TByteSize.FromBytes(value);
end;

function TByteSize.AddKiloBytes(value: Double): TByteSize;
begin
  result := Self + TByteSize.FromKiloBytes(value);
end;

function TByteSize.AddMegaBytes(value: Double): TByteSize;
begin
  result := Self + TByteSize.FromMegaBytes(value);
end;

function TByteSize.AddGigaBytes(value: Double): TByteSize;
begin
  result := Self + TByteSize.FromGigaBytes(value);
end;

function TByteSize.AddTeraBytes(value: Double): TByteSize;
begin
  result := Self + TByteSize.FromTeraBytes(value);
end;

function TByteSize.AddPetaBytes(value: Double): TByteSize;
begin
  result := Self + TByteSize.FromPetaBytes(value);
end;

function TByteSize.Subtract(bs: TByteSize): TByteSize;
begin
  result := TByteSize.Create(Self.Bytes - bs.Bytes);
end;

class operator TByteSize.Add(b1: TByteSize; b2: TByteSize): TByteSize;
begin
  result := TByteSize.Create(b1.Bytes + b2.Bytes);
end;

class operator TByteSize.Subtract(b1: TByteSize; b2: TByteSize): TByteSize;
begin
  result := TByteSize.Create(b1.Bytes - b2.Bytes);
end;

class operator TByteSize.Inc(b: TByteSize): TByteSize;
begin
  result := TByteSize.Create(b.Bytes + 1);
end;

class operator TByteSize.Dec(b: TByteSize): TByteSize;
begin
  result := TByteSize.Create(b.Bytes - 1);
end;

class operator TByteSize.Positive(b: TByteSize): TByteSize;
begin
  result := TByteSize.Create(+b.Bytes);
end;

class operator TByteSize.Negative(b: TByteSize): TByteSize;
begin
  result := TByteSize.Create(-b.Bytes);
end;

class operator TByteSize.Equal(b1: TByteSize; b2: TByteSize): Boolean;
begin
  result := b1.Bits = b2.Bits;
end;

class operator TByteSize.NotEqual(b1: TByteSize; b2: TByteSize): Boolean;
begin
  result := b1.Bits <> b2.Bits;
end;

class operator TByteSize.LessThan(b1: TByteSize; b2: TByteSize): Boolean;
begin
  result := b1.Bits < b2.Bits;
end;

class operator TByteSize.LessThanOrEqual(b1: TByteSize; b2: TByteSize): Boolean;
begin
  result := b1.Bits <= b2.Bits;
end;

class operator TByteSize.GreaterThan(b1: TByteSize; b2: TByteSize): Boolean;
begin
  result := b1.Bits > b2.Bits;
end;

class operator TByteSize.GreaterThanOrEqual(b1: TByteSize;
  b2: TByteSize): Boolean;
begin
  result := b1.Bits >= b2.Bits;
end;

class function TByteSize.TryParse(const s: String;
  out varresult: TByteSize): Boolean;
var
  num, lastNumber, tempInt: Integer;
  found: Boolean;
  numberPart, sizePart, tempS: String;
  number, d1: Double;
  lFormatSettings: TFormatSettings;

begin
  // Arg checking
  if (IsNullOrWhiteSpace(s)) then
    raise EArgumentNilException.Create('Input String is null or whitespace');

  // Setup the result
  varresult := Default (TByteSize);

  // Get the index of the first non-digit character
  tempS := TrimLeft(s); // Protect against leading spaces
  found := false;

  // Pick first non-digit number

  for num := 0 to Pred(Length(tempS)) do
  begin
    if (not(CharInSet(tempS[num], ['0' .. '9']) or (tempS[num] = '.'))) then
    begin
      found := True;
      break;
    end;

  end;

  if (not found) then
  begin
    result := false;
    Exit;
  end;

  lastNumber := num;

  // Cut the input string in half
  numberPart := Trim(Copy(tempS, 0, lastNumber));
  sizePart := Trim(Copy(tempS, lastNumber + 1, Length(tempS) - lastNumber));

{$IFDEF FPC}
  GetLocaleFormatSettings(0, lFormatSettings);
{$ELSE}
  lFormatSettings := TFormatSettings.Create;
{$ENDIF}
  // Get the numeric part
  if not(TryStrToFloat(numberPart, number, lFormatSettings)) then
  begin
    result := false;
    Exit;
  end;

  // Get the magnitude part
  tempInt := AnsiIndexStr(sizePart, ['b', 'B', 'KB', 'kB', 'kb', 'MB', 'mB',
    'mb', 'GB', 'gB', 'gb', 'TB', 'tB', 'tb', 'PB', 'pB', 'pb']);
  case tempInt of
    0:
      begin

        d1 := 1 * 1.0;
        if (FloatingMod(number, d1) <> 0) then // Can't have partial bits
        begin
          result := false;
          Exit;
        end
        else
        begin
          varresult := FromBits(Trunc(number));
        end;

      end;

    1:
      begin
        varresult := FromBytes(number);
      end;

    2 .. 4:
      begin
        varresult := FromKiloBytes(number);
      end;

    5 .. 7:
      begin
        varresult := FromMegaBytes(number);
      end;

    8 .. 10:
      begin
        varresult := FromGigaBytes(number);
      end;

    11 .. 13:
      begin
        varresult := FromTeraBytes(number);
      end;

    14 .. 16:
      begin
        varresult := FromPetaBytes(number);
      end;

  end;

  result := True;

end;

class function TByteSize.Parse(const s: String): TByteSize;
begin

  if not(TryParse(s, result)) then
  begin
    raise EFormatException.Create('Value is not in the correct format');
  end;

end;

function TByteSize.has(const SubStr: String; const Str: String): Boolean;
begin
  result := IndexOf(SubStr, Str, false) <> -1;
end;

function TByteSize.output(n: Double; formatsettings: TFormatSettings;
  const formatstr: String): String;
begin
  result := FormatFloat(formatstr, n, formatsettings);
end;

class function TByteSize.Contains(InChar: Char; const InString: String)
  : Boolean;
var
  i: Integer;

begin
  result := false;
  for i := Low(InString) to High(InString) do

  begin
    if InString[i] = InChar then
    begin
      result := True;
      Exit;
    end;
  end;

end;

class function TByteSize.IndexOf(const SubStr: String; const Str: String;
  caseSensitive: Boolean): Integer;

begin
  if caseSensitive then
    result := Pos(SubStr, Str) - 1
  else
    result := Pos(AnsiUpperCase(SubStr), AnsiUpperCase(Str)) - 1;
end;

class function TByteSize.IsNullOrWhiteSpace(const InValue: string): Boolean;
begin
  result := Length(Trim(InValue)) = 0;
end;

class function TByteSize.FloatingMod(a: Double; b: Double): Double;
var
  tempDouble: Double;
begin
  tempDouble := (a / b);
  result := a - b * Trunc(tempDouble);
end;

function TByteSize.GetMinValue: TByteSize;
begin
  result := TByteSize.FromBits(0);
end;

function TByteSize.GetMaxValue: TByteSize;
begin
  result := TByteSize.FromBits(Int64MaxValue);
end;

end.
