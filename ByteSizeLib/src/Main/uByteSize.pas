unit uByteSize;

{$IFNDEF FPC}
{$IF CompilerVersion >= 24}  // XE3 and Above
{$ZEROBASEDSTRINGS OFF}
{$LEGACYIFEND ON}
{$IFEND}
{$IF CompilerVersion >= 22}  // XE and Above
{$DEFINE SUPPORT_TFORMATSETTINGS_CREATE_INSTANCE}
{$IFEND}
{$IF CompilerVersion >= 23}  // XE2 and Above
{$DEFINE SCOPEDUNITNAMES}
{$IFEND}
{$ELSE}
{$MODE delphi}
{$ENDIF FPC}

interface

uses
{$IFDEF SCOPEDUNITNAMES}
  System.SysUtils,
  System.StrUtils,
  System.Generics.Defaults;
{$ELSE}
{$IFNDEF FPC}
  Generics.Defaults,
{$ENDIF FPC}
  SysUtils,
  StrUtils;
{$ENDIF}

resourcestring
  SEmptyString = 'Input String is null or whitespace';
  SInvalidInput = 'No byte indicator found in value "%s".';
  SInvalidInput2 = 'No number found in value "%s".';
  SInvalidBit = 'Can''t have partial bits for value "%s".';
  SUnSupportedMagnitude = 'Bytes of magnitude "%s" is not supported.';

type

  TByteSize = record

  public

  strict private

    FBits: Int64;
    FBytes: Double;

    function GetBits: Int64; inline;
    function GetBytes: Double; inline;
    function GetKiloBytes: Double; inline;
    function GetMegaBytes: Double; inline;
    function GetGigaBytes: Double; inline;
    function GetTeraBytes: Double; inline;
    function GetPetaBytes: Double; inline;

    function GetLargestWholeNumberSymbol: String;
    property LargestWholeNumberSymbol: String read GetLargestWholeNumberSymbol;
    function GetLargestWholeNumberValue: Double;
    property LargestWholeNumberValue: Double read GetLargestWholeNumberValue;

    class function GetMinValue: TByteSize; static; inline;
    class function GetMaxValue: TByteSize; static; inline;

    { Utils }

    class function has(const SubStr: String; const Str: String): Boolean;
      static; inline;
    class function output(n: Double; formatsettings: TFormatSettings;
      const formatstr: String): String; static; inline;

    class function Contains(InChar: Char; const InString: String)
      : Boolean; static;
    class function IndexOf(const SubStr: String; const Str: String;
      caseSensitive: Boolean): Integer; static;
    class function IsNullOrWhiteSpace(const InValue: string): Boolean;
      static; inline;
    class function FloatingMod(a: Double; b: Double): Double; static; inline;

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

    property Bits: Int64 read GetBits;
    property Bytes: Double read GetBytes;
    property KiloBytes: Double read GetKiloBytes;
    property MegaBytes: Double read GetMegaBytes;
    property GigaBytes: Double read GetGigaBytes;
    property TeraBytes: Double read GetTeraBytes;
    property PetaBytes: Double read GetPetaBytes;

    class property MinValue: TByteSize read GetMinValue;
    class property MaxValue: TByteSize read GetMaxValue;

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
  EArgumentNilException = class(Exception);

implementation

constructor TByteSize.Create(byteSize: Double);
var
  tempDouble: Double;
begin
  tempDouble := byteSize * BitsInByte;
  // Get Truncation because bits are whole units
  FBits := Trunc(tempDouble);
  FBytes := byteSize;
end;

function TByteSize.GetLargestWholeNumberSymbol: String;
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

function TByteSize.GetLargestWholeNumberValue: Double;
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
  lFormatSettings := DefaultFormatSettings;
{$ELSE}
{$IFDEF SUPPORT_TFORMATSETTINGS_CREATE_INSTANCE}
  lFormatSettings := TFormatSettings.Create;
{$ELSE}
  GetLocaleFormatSettings(0, lFormatSettings);
{$ENDIF}
{$ENDIF}
  result := Self.ToString('0.##', lFormatSettings);

end;

function TByteSize.ToString(lformat: String): String;
var
  lFormatSettings: TFormatSettings;
begin
{$IFDEF FPC}
  lFormatSettings := DefaultFormatSettings;
{$ELSE}
{$IFDEF SUPPORT_TFORMATSETTINGS_CREATE_INSTANCE}
  lFormatSettings := TFormatSettings.Create;
{$ELSE}
  GetLocaleFormatSettings(0, lFormatSettings);
{$ENDIF}
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
    lformat := '0.## ' + lformat;
  end;

{$IFDEF FPC}
  if formatsettings.DecimalSeparator = '' then
  begin
    formatsettings := DefaultFormatSettings;
  end;
{$ELSE}
  comparer := TComparer<TFormatSettings>.Default;

  if comparer.Compare(formatsettings, Default (TFormatSettings)) = 0 then
{$IF DEFINED (SUPPORT_TFORMATSETTINGS_CREATE_INSTANCE)}
    formatsettings := TFormatSettings.Create;
{$ELSE}
    GetLocaleFormatSettings(0, formatsettings);
{$IFEND}
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

begin
  try
    varresult := Parse(s);
    result := True;
  except
    varresult := Default (TByteSize);
    result := False;
  end;
end;

class function TByteSize.Parse(const s: String): TByteSize;
var
  num, lastNumber, tempInt: Integer;
  found: Boolean;
  numberPart, sizePart, tempS: String;
  number, d1: Double;
  lFormatSettings: TFormatSettings;
  decimalSeperator, groupSeperator: Char;
begin

  // Arg checking
  if (IsNullOrWhiteSpace(s)) then
    raise EArgumentNilException.CreateRes(@SEmptyString);

  // Get the index of the first non-digit character
  tempS := TrimLeft(s); // Protect against leading spaces
  found := False;

{$IFDEF FPC}
  lFormatSettings := DefaultFormatSettings;
{$ELSE}
{$IF DEFINED (SUPPORT_TFORMATSETTINGS_CREATE_INSTANCE)}
  lFormatSettings := TFormatSettings.Create;
{$ELSE}
  GetLocaleFormatSettings(0, lFormatSettings);
{$IFEND}
{$ENDIF}
  decimalSeperator := lFormatSettings.DecimalSeparator;
  groupSeperator := lFormatSettings.ThousandSeparator;

  // Pick first non-digit number

  for num := 1 to Length(tempS) do
  begin
    if (not(CharInSet(tempS[num], ['0' .. '9']) or
      (tempS[num] = decimalSeperator) or (tempS[num] = groupSeperator))) then

    begin
      found := True;
      break;
    end;

  end;

  if (not found) then
  begin

    raise EFormatException.CreateResFmt(@SInvalidInput, [s]);

  end;

  lastNumber := num;

  // Cut the input string in half
  numberPart := Trim(Copy(tempS, 1, lastNumber - 1));
  sizePart := Trim(Copy(tempS, lastNumber, Length(tempS) - (lastNumber - 1)));

  // Get the numeric part
  // since ThousandSeperators and Currency Symbols are not allowed in
  // "TryStrToFloat" and "StrToFloat" for ("Delphi"), we simply replace our "ThousandSeperators"
  // with an empty Char.
  numberPart := StringReplace(numberPart, groupSeperator, '',
    [rfReplaceAll, rfIgnoreCase]);
  if not(TryStrToFloat(numberPart, number, lFormatSettings)) then
  begin
    raise EFormatException.CreateResFmt(@SInvalidInput2, [s]);
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
          raise EFormatException.CreateResFmt(@SInvalidBit, [s]);
        end
        else
        begin
          result := FromBits(Trunc(number));
          Exit;
        end;

      end;

    1:
      begin
        result := FromBytes(number);
        Exit;
      end;

    2 .. 4:
      begin
        result := FromKiloBytes(number);
        Exit;
      end;

    5 .. 7:
      begin
        result := FromMegaBytes(number);
        Exit;
      end;

    8 .. 10:
      begin
        result := FromGigaBytes(number);
        Exit;
      end;

    11 .. 13:
      begin
        result := FromTeraBytes(number);
        Exit;
      end;

    14 .. 16:
      begin
        result := FromPetaBytes(number);
        Exit;
      end;

  else
    raise EFormatException.CreateResFmt(@SUnSupportedMagnitude, [sizePart]);

  end;

end;

class function TByteSize.has(const SubStr: String; const Str: String): Boolean;
begin
  result := IndexOf(SubStr, Str, False) <> -1;
end;

class function TByteSize.output(n: Double; formatsettings: TFormatSettings;
  const formatstr: String): String;
begin
  result := FormatFloat(formatstr, n, formatsettings);
end;

class function TByteSize.Contains(InChar: Char; const InString: String)
  : Boolean;
var
  i: Integer;

begin
  result := False;
  for i := 1 to Length(InString) do

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

class function TByteSize.GetMinValue: TByteSize;
begin
  result := TByteSize.FromBits(0);
end;

function TByteSize.GetPetaBytes: Double;
begin
  result := Bytes / BytesInPetaByte;
end;

function TByteSize.GetTeraBytes: Double;
begin
  result := Bytes / BytesInTeraByte;
end;

function TByteSize.GetBits: Int64;
begin
  result := FBits;
end;

function TByteSize.GetBytes: Double;
begin
  result := FBytes;
end;

function TByteSize.GetGigaBytes: Double;
begin
  result := Bytes / BytesInGigaByte;
end;

function TByteSize.GetKiloBytes: Double;
begin
  result := Bytes / BytesInKiloByte;
end;

class function TByteSize.GetMaxValue: TByteSize;
begin
  result := TByteSize.FromBits(Int64MaxValue);
end;

function TByteSize.GetMegaBytes: Double;
begin
  result := Bytes / BytesInMegaByte;
end;

end.
