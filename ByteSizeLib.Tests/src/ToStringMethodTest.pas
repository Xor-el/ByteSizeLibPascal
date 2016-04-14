unit ToStringMethodTest;

interface

uses
  System.SysUtils, Winapi.Windows, DUnitX.TestFramework, uByteSize;

type

  [TestFixture]
  TToStringMethod = class(TObject)
  class var
    FFormatSettings: TFormatSettings;
  public
    [Setup]
    procedure Setup();
    [Test]
    procedure ReturnsLargestMetricSuffix();
    [Test]
    procedure ReturnsDefaultNumberFormat();
    [Test]
    procedure ReturnsProvidedNumberFormat();
    [Test]
    procedure ReturnsBits();
    [Test]
    procedure ReturnsBytes();
    [Test]
    procedure ReturnsKiloBytes();
    [Test]
    procedure ReturnsMegaBytes();
    [Test]
    procedure ReturnsGigaBytes();
    [Test]
    procedure ReturnsTeraBytes();
    [Test]
    procedure ReturnsPetaBytes();
    [Test]
    procedure ReturnsSelectedFormat();
    [Test]
    procedure ReturnsLargestMetricPrefixLargerThanZero();
    [Test]
    procedure ReturnsLargestMetricPrefixLargerThanZeroForNegativeValues();
    [Test]
    procedure ReturnsLargestMetricSuffixUsingCustomFormatSettingsOne();
    [Test]
    procedure ReturnsLargestMetricSuffixUsingCustomFormatSettingsTwo();
    [Test]
    procedure ReturnsLargestMetricSuffixUsingCustomFormatSettingsThree();
    [Test]
    procedure ReturnsLargestMetricSuffixUsingCurrentLocale();
  end;

implementation

procedure TToStringMethod.Setup();

begin
  FFormatSettings := TFormatSettings.Create;
end;

procedure TToStringMethod.ReturnsLargestMetricSuffix();
var
  b: TByteSize;
  result: String;
  lDouble: Double;
begin
  lDouble := 10.5;
  // Arrange
  b := TByteSize.FromKiloBytes(10.5);

  // Act
  result := b.ToString();

  // Assert
  Assert.AreEqual(FormatFloat('0.0 KB', lDouble, FFormatSettings), result);
end;

procedure TToStringMethod.ReturnsDefaultNumberFormat();
var
  b: TByteSize;
  result: String;
  lDouble: Double;
begin
  lDouble := 10.5;
  // Arrange
  b := TByteSize.FromKiloBytes(10.5);

  // Act
  result := b.ToString('KB');

  // Assert
  Assert.AreEqual(FormatFloat('0.0 KB', lDouble, FFormatSettings), result);
end;

procedure TToStringMethod.ReturnsProvidedNumberFormat();
var
  b: TByteSize;
  result: String;
  lDouble: Double;
begin
  lDouble := 10.1234;
  // Arrange
  b := TByteSize.FromKiloBytes(10.1234);

  // Act
  result := b.ToString('#.#### KB');

  // Assert
  Assert.AreEqual(FormatFloat('0.0000 KB', lDouble, FFormatSettings), result);
end;

procedure TToStringMethod.ReturnsBits();
var
  b: TByteSize;
  result: String;
begin
  // Arrange
  b := TByteSize.FromBits(10);

  // Act
  result := b.ToString('##.#### b');

  // Assert
  Assert.AreEqual('10 b', result);
end;

procedure TToStringMethod.ReturnsBytes();
var
  b: TByteSize;
  result: String;
begin
  // Arrange
  b := TByteSize.FromBytes(10);

  // Act
  result := b.ToString('##.#### B');

  // Assert
  Assert.AreEqual('10 B', result);
end;

procedure TToStringMethod.ReturnsKiloBytes();
var
  b: TByteSize;
  result: String;
begin
  // Arrange
  b := TByteSize.FromKiloBytes(10);

  // Act
  result := b.ToString('##.#### KB');

  // Assert
  Assert.AreEqual('10 KB', result);
end;

procedure TToStringMethod.ReturnsMegaBytes();
var
  b: TByteSize;
  result: String;
begin
  // Arrange
  b := TByteSize.FromMegaBytes(10);

  // Act
  result := b.ToString('##.#### MB');

  // Assert
  Assert.AreEqual('10 MB', result);
end;

procedure TToStringMethod.ReturnsGigaBytes();
var
  b: TByteSize;
  result: String;
begin
  // Arrange
  b := TByteSize.FromGigaBytes(10);

  // Act
  result := b.ToString('##.#### GB');

  // Assert
  Assert.AreEqual('10 GB', result);
end;

procedure TToStringMethod.ReturnsTeraBytes();
var
  b: TByteSize;
  result: String;
begin
  // Arrange
  b := TByteSize.FromTeraBytes(10);

  // Act
  result := b.ToString('##.#### TB');

  // Assert
  Assert.AreEqual('10 TB', result);
end;

procedure TToStringMethod.ReturnsPetaBytes();
var
  b: TByteSize;
  result: String;
begin
  // Arrange
  b := TByteSize.FromPetaBytes(10);

  // Act
  result := b.ToString('##.#### PB');

  // Assert
  Assert.AreEqual('10 PB', result);
end;

procedure TToStringMethod.ReturnsSelectedFormat();
var
  b: TByteSize;
  result: String;
  lDouble: Double;
begin
  lDouble := 10;
  // Arrange
  b := TByteSize.FromTeraBytes(10);

  // Act
  result := b.ToString('0.0 TB');

  // Assert
  Assert.AreEqual(FormatFloat('0.0 TB', lDouble, FFormatSettings), result);
end;

procedure TToStringMethod.ReturnsLargestMetricPrefixLargerThanZero();
var
  b: TByteSize;
  result: String;
begin
  // Arrange
  b := TByteSize.FromMegaBytes(0.5);

  // Act
  result := b.ToString('#.#');

  // Assert
  Assert.AreEqual('512 KB', result);
end;

procedure TToStringMethod.
  ReturnsLargestMetricPrefixLargerThanZeroForNegativeValues();
var
  b: TByteSize;
  result: String;
begin
  // Arrange
  b := TByteSize.FromMegaBytes(-0.5);

  // Act
  result := b.ToString('#.#');

  // Assert
  Assert.AreEqual('-512 KB', result);
end;

procedure TToStringMethod.
  ReturnsLargestMetricSuffixUsingCustomFormatSettingsOne();
var
  FrenchFormatSettings: TFormatSettings;
  b: TByteSize;
  result: String;
begin
  FrenchFormatSettings := TFormatSettings.Create('fr-FR');

  // Arrange
  b := TByteSize.FromKiloBytes(10000);

  // Act
  result := b.ToString('#.##', FrenchFormatSettings);

  // Assert
  Assert.AreEqual('9,77 MB', result);
end;

procedure TToStringMethod.
  ReturnsLargestMetricSuffixUsingCustomFormatSettingsTwo();
var
  GermanFormatSettings: TFormatSettings;
  b: TByteSize;
  result: String;
begin
  GermanFormatSettings := TFormatSettings.Create('de-DE');

  // Arrange
  b := TByteSize.FromKiloBytes(10000);

  // Act
  result := b.ToString('#.#', GermanFormatSettings);

  // Assert
  Assert.AreEqual('9,8 MB', result);
end;

procedure TToStringMethod.
  ReturnsLargestMetricSuffixUsingCustomFormatSettingsThree();
var
  GermanFormatSettings: TFormatSettings;
  b: TByteSize;
  result: String;
  lDouble: Double;
begin
  lDouble := 10.5;
  GermanFormatSettings := TFormatSettings.Create('de-DE');

  // Arrange
  b := TByteSize.FromKiloBytes(10.5);

  // Act
  result := b.ToString('0.0 KB', GermanFormatSettings);

  // Assert
  Assert.AreEqual(FormatFloat('0.0 KB', lDouble, GermanFormatSettings), result);
end;

procedure TToStringMethod.ReturnsLargestMetricSuffixUsingCurrentLocale();
var
  b: TByteSize;
  result: String;
  OriginalLocale: Cardinal;
begin
  OriginalLocale := GetThreadLocale;
  if SetThreadLocale(1036) then // Set Locale to French (fr-FR)
  begin
    // Arrange
    b := TByteSize.FromKiloBytes(10000);

    // Act
    result := b.ToString();

    // Assert
    Assert.AreEqual('9,77 MB', result);
  end
  else
  begin
    raise Exception.Create('Error Setting Locale (First Instance)');
  end;

  if not(SetThreadLocale(OriginalLocale)) then
    raise Exception.Create('Error Setting Locale (Second Instance)');
end;

initialization

TDUnitX.RegisterTestFixture(TToStringMethod);

end.
