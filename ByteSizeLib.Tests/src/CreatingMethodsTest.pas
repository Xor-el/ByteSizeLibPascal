unit CreatingMethodsTest;

interface

uses
  System.SysUtils, DUnitX.TestFramework, uByteSize;

type

  [TestFixture]
  TCreatingMethods = class(TObject)
  public
    [Test]
    procedure cConstructor();
    [Test]
    procedure FromBitsMethod();
    [Test]
    procedure FromBytesMethod();
    [Test]
    procedure FromKiloBytesMethod();
    [Test]
    procedure FromMegaBytesMethod();
    [Test]
    procedure FromGigaBytesMethod();
    [Test]
    procedure FromTeraBytesMethod();
    [Test]
    procedure FromPetaBytesMethod();
  end;

implementation

procedure TCreatingMethods.cConstructor();
var
  byteSize, d0, d1, d2, d3, d4: Double;
  result: TByteSize;
begin
  // Arrange
  byteSize := 1125899906842624;

  // Act
  result := TByteSize.Create(byteSize);

  d0 := (byteSize * 8);
  d1 := byteSize / 1024;
  d2 := byteSize / 1024 / 1024;
  d3 := byteSize / 1024 / 1024 / 1024;
  d4 := byteSize / 1024 / 1024 / 1024 / 1024;

  // Assert
  Assert.AreEqual(d0, (result.Bits).ToDouble);
  Assert.AreEqual(byteSize, result.Bytes);
  Assert.AreEqual(d1, result.KiloBytes);
  Assert.AreEqual(d2, result.MegaBytes);
  Assert.AreEqual(d3, result.GigaBytes);
  Assert.AreEqual(d4, result.TeraBytes);
  Assert.AreEqual((1).ToDouble, result.PetaBytes);
end;

procedure TCreatingMethods.FromBitsMethod();
var
  value: Int64;
  result: TByteSize;
begin
  // Arrange
  value := 8;

  // Act
  result := TByteSize.FromBits(value);

  // Assert
  Assert.AreEqual((8).ToDouble, (result.Bits).ToDouble);
  Assert.AreEqual((1).ToDouble, result.Bytes);
end;

procedure TCreatingMethods.FromBytesMethod();
var
  value, d0: Double;
  result: TByteSize;
begin
  // Arrange
  value := 1.5;
  d0 := 1.5;

  // Act
  result := TByteSize.FromBytes(value);

  // Assert
  Assert.AreEqual((12).ToDouble, (result.Bits).ToDouble);
  Assert.AreEqual(d0, result.Bytes);
end;

procedure TCreatingMethods.FromKiloBytesMethod();
var
  value, d0: Double;
  result: TByteSize;
begin
  // Arrange
  value := 1.5;
  d0 := 1.5;

  // Act
  result := TByteSize.FromKiloBytes(value);

  // Assert
  Assert.AreEqual((1536).ToDouble, result.Bytes);
  Assert.AreEqual(d0, result.KiloBytes);
end;

procedure TCreatingMethods.FromMegaBytesMethod();
var
  value, d0: Double;
  result: TByteSize;
begin
  // Arrange
  value := 1.5;
  d0 := 1.5;

  // Act
  result := TByteSize.FromMegaBytes(value);

  // Assert
  Assert.AreEqual((1572864).ToDouble, result.Bytes);
  Assert.AreEqual(d0, result.MegaBytes);
end;

procedure TCreatingMethods.FromGigaBytesMethod();
var
  value, d0: Double;
  result: TByteSize;
begin
  // Arrange
  value := 1.5;
  d0 := 1.5;

  // Act
  result := TByteSize.FromGigaBytes(value);

  // Assert
  Assert.AreEqual((1610612736).ToDouble, result.Bytes);
  Assert.AreEqual(d0, result.GigaBytes);
end;

procedure TCreatingMethods.FromTeraBytesMethod();
var
  value, d0: Double;
  result: TByteSize;
begin
  // Arrange
  value := 1.5;
  d0 := 1.5;

  // Act
  result := TByteSize.FromTeraBytes(value);

  // Assert
  Assert.AreEqual((1649267441664).ToDouble, result.Bytes);
  Assert.AreEqual(d0, result.TeraBytes);
end;

procedure TCreatingMethods.FromPetaBytesMethod();
var
  value, d0: Double;
  result: TByteSize;
begin
  // Arrange
  value := 1.5;
  d0 := 1.5;

  // Act
  result := TByteSize.FromPetaBytes(value);

  // Assert
  Assert.AreEqual((1688849860263936).ToDouble, result.Bytes);
  Assert.AreEqual(d0, result.PetaBytes);
end;

initialization

TDUnitX.RegisterTestFixture(TCreatingMethods);

end.
