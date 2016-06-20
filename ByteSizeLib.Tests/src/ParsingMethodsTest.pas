unit ParsingMethodsTest;

interface

uses
  DUnitX.TestFramework, System.SysUtils, Winapi.Windows, uByteSize;

type

  [TestFixture]
  TParsingMethods = class(TObject)
  public
    // Base parsing functionality
    [Test]
    procedure Parse();
    [Test]
    procedure TryParse();
    [Test]
    procedure ParseDecimalMB();
    [Test]
    procedure TryParseReturnsFalseOnBadValue();
    [Test]
    procedure TryParseReturnsFalseOnMissingMagnitude();
    [Test]
    procedure TryParseReturnsFalseOnMissingValue();
    [Test]
    procedure TryParseWorksWithLotsOfSpaces();
    [Test]
    procedure ParsePartialBits();
    // Parse method throws exceptions
    [Test]
    procedure ParseThrowsOnInvalid();
    // Various magnitudes
    [Test]
    procedure ParseBits();
    [Test]
    procedure ParseBytes();
    [Test]
    procedure ParseKB();
    [Test]
    procedure ParseMB();
    [Test]
    procedure ParseGB();
    [Test]
    procedure ParseTB();
    [Test]
    procedure ParsePB();
    [Test]
    procedure ParseLocaleNumberSeparator();

  end;

implementation

procedure TParsingMethods.Parse();
var
  val: String;
  result, expected: TByteSize;
begin
  val := '1020KB';
  expected := TByteSize.FromKiloBytes(1020);

  result := TByteSize.Parse(val);
  Assert.AreEqual(expected, result);
end;

procedure TParsingMethods.TryParse();
var
  val: String;
  resultByteSize, expected: TByteSize;
  resultBool: Boolean;
begin
  val := '1020KB';
  expected := TByteSize.FromKiloBytes(1020);
  resultBool := TByteSize.TryParse(val, resultByteSize);

  Assert.IsTrue(resultBool);
  Assert.AreEqual(expected, resultByteSize);
end;

procedure TParsingMethods.ParseDecimalMB();
var
  val: String;
  result, expected: TByteSize;
begin
  val := '100.5MB';
  expected := TByteSize.FromMegaBytes(100.5);

  result := TByteSize.Parse(val);
  Assert.AreEqual(expected, result);
end;

procedure TParsingMethods.TryParseReturnsFalseOnBadValue();
var
  val: String;
  resultByteSize: TByteSize;
  resultBool: Boolean;
begin
  val := 'Unexpected Value';
  resultBool := TByteSize.TryParse(val, resultByteSize);

  Assert.IsFalse(resultBool);
  Assert.AreEqual(Default (TByteSize), resultByteSize);
end;

procedure TParsingMethods.TryParseReturnsFalseOnMissingMagnitude();
var
  val: String;
  resultByteSize: TByteSize;
  resultBool: Boolean;
begin
  val := '1000';
  resultBool := TByteSize.TryParse(val, resultByteSize);

  Assert.IsFalse(resultBool);
  Assert.AreEqual(Default (TByteSize), resultByteSize);
end;

procedure TParsingMethods.TryParseReturnsFalseOnMissingValue();
var
  val: String;
  resultByteSize: TByteSize;
  resultBool: Boolean;
begin
  val := 'KB';
  resultBool := TByteSize.TryParse(val, resultByteSize);

  Assert.IsFalse(resultBool);
  Assert.AreEqual(Default (TByteSize), resultByteSize);
end;

procedure TParsingMethods.TryParseWorksWithLotsOfSpaces();
var
  val: String;
  result, expected: TByteSize;
begin
  val := ' 100 KB ';
  expected := TByteSize.FromKiloBytes(100);

  result := TByteSize.Parse(val);
  Assert.AreEqual(expected, result);
end;

procedure TParsingMethods.ParsePartialBits();
var
  val: String;
begin
  val := '10.5b';

  Assert.WillRaise(
    procedure
    begin
      TByteSize.Parse(val);
    end, EFormatException);
end;

procedure TParsingMethods.ParseThrowsOnInvalid();
var
  badValue: String;
begin
  badValue := 'Unexpected Value';

  Assert.WillRaise(
    procedure
    begin
      TByteSize.Parse(badValue);
    end, EFormatException);
end;

procedure TParsingMethods.ParseBits();
var
  val: String;
  result, expected: TByteSize;
begin
  val := '1b';
  expected := TByteSize.FromBits(1);

  result := TByteSize.Parse(val);
  Assert.AreEqual(expected, result);
end;

procedure TParsingMethods.ParseBytes();
var
  val: String;
  result, expected: TByteSize;
begin
  val := '1B';
  expected := TByteSize.FromBytes(1);

  result := TByteSize.Parse(val);
  Assert.AreEqual(expected, result);
end;

procedure TParsingMethods.ParseKB();
var
  val: String;
  result, expected: TByteSize;
begin
  val := '1020KB';
  expected := TByteSize.FromKiloBytes(1020);

  result := TByteSize.Parse(val);
  Assert.AreEqual(expected, result);
end;

procedure TParsingMethods.ParseMB();
var
  val: String;
  result, expected: TByteSize;
begin
  val := '1000MB';
  expected := TByteSize.FromMegaBytes(1000);

  result := TByteSize.Parse(val);
  Assert.AreEqual(expected, result);
end;

procedure TParsingMethods.ParseGB();
var
  val: String;
  result, expected: TByteSize;
begin
  val := '805GB';
  expected := TByteSize.FromGigaBytes(805);

  result := TByteSize.Parse(val);
  Assert.AreEqual(expected, result);
end;

procedure TParsingMethods.ParseTB();
var
  val: String;
  result, expected: TByteSize;
begin
  val := '100TB';
  expected := TByteSize.FromTeraBytes(100);

  result := TByteSize.Parse(val);
  Assert.AreEqual(expected, result);
end;

procedure TParsingMethods.ParsePB();
var
  val: String;
  result, expected: TByteSize;
begin
  val := '100PB';
  expected := TByteSize.FromPetaBytes(100);

  result := TByteSize.Parse(val);
  Assert.AreEqual(expected, result);
end;

procedure TParsingMethods.ParseLocaleNumberSeparator();
var
  OriginalLocale: Cardinal;
  val: String;
  expected, result: TByteSize;
begin

  OriginalLocale := GetThreadLocale;
  if SetThreadLocale(1031) then // Set Locale to German (de-DE)
  begin
    val := '1,5 MB';
    // Arrange
    expected := TByteSize.FromMegaBytes(1.5);

    // Act
    result := TByteSize.Parse(val);

    // Assert
    Assert.AreEqual(expected, result);
  end
  else
  begin
    raise Exception.Create('Error Setting Locale (First Instance)');
  end;

  if not(SetThreadLocale(OriginalLocale)) then
    raise Exception.Create('Error Setting Locale (Second Instance)');
end;

initialization

TDUnitX.RegisterTestFixture(TParsingMethods);

end.
