unit ArithmeticMethodsTest;

interface

uses
  System.SysUtils, DUnitX.TestFramework, uByteSize;

type

  [TestFixture]
  TArithmeticMethods = class(TObject)

  public

    [Test]
    procedure AddMethod();
    [Test]
    procedure AddBitsMethod();
    [Test]
    procedure AddBytesMethod();
    [Test]
    procedure AddKiloBytesMethod();
    [Test]
    procedure AddMegaBytesMethod();
    [Test]
    procedure AddGigaBytesMethod();
    [Test]
    procedure AddTeraBytesMethod();
    [Test]
    procedure AddPetaBytesMethod();
    [Test]
    procedure SubtractMethod();
    [Test]
    procedure IncrementOperator();
    [Test]
    procedure DecrementOperator();
    [Test]
    procedure MinusOperator();
  end;

implementation

procedure TArithmeticMethods.AddMethod();
var
  size1, result: TByteSize;
  d2: Double;
  i16: Int64;
begin
  d2 := 2;
  i16 := 16;
  size1 := TByteSize.FromBytes(1);
  result := size1.Add(size1);

  Assert.AreEqual(d2, result.Bytes);
  Assert.AreEqual(i16, result.Bits);
end;

procedure TArithmeticMethods.AddBitsMethod();
var
  size: TByteSize;
  d2: Double;
  i16: Int64;
begin
  d2 := 2;
  i16 := 16;
  size := TByteSize.FromBytes(1).AddBits(8);

  Assert.AreEqual(d2, size.Bytes);
  Assert.AreEqual(i16, size.Bits);
end;

procedure TArithmeticMethods.AddBytesMethod();
var
  size: TByteSize;
  d2: Double;
  i16: Int64;
begin
  d2 := 2;
  i16 := 16;
  size := TByteSize.FromBytes(1).AddBytes(1);

  Assert.AreEqual(d2, size.Bytes);
  Assert.AreEqual(i16, size.Bits);
end;

procedure TArithmeticMethods.AddKiloBytesMethod();
var
  size: TByteSize;
  d1, d2: Double;
begin
  d1 := 4 * 1024;
  d2 := 4;
  size := TByteSize.FromKiloBytes(2).AddKiloBytes(2);

  Assert.AreEqual(Int64(4 * 1024 * 8), size.Bits);
  Assert.AreEqual(d1, size.Bytes);
  Assert.AreEqual(d2, size.KiloBytes);
end;

procedure TArithmeticMethods.AddMegaBytesMethod();
var
  size: TByteSize;
  d1, d2, d3: Double;
begin
  d1 := 4 * 1024 * 1024;
  d2 := 4 * 1024;
  d3 := 4;
  size := TByteSize.FromMegaBytes(2).AddMegaBytes(2);

  Assert.AreEqual(Int64(4 * 1024 * 1024 * 8), size.Bits);
  Assert.AreEqual(d1, size.Bytes);
  Assert.AreEqual(d2, size.KiloBytes);
  Assert.AreEqual(d3, size.MegaBytes);
end;

procedure TArithmeticMethods.AddGigaBytesMethod();
var
  size: TByteSize;
  d0, d1, d2, d3, d4: Double;
begin

  d0 := (4.0 * 1024 * 1024 * 1024 * 8);
  d1 := (4.0 * 1024 * 1024 * 1024);
  d2 := (4.0 * 1024 * 1024);
  d3 := 4.0 * 1024;
  d4 := 4.0;
  size := TByteSize.FromGigaBytes(2).AddGigaBytes(2);
  Assert.AreEqual(d0, size.Bits.ToDouble);
  Assert.AreEqual(d1, size.Bytes);
  Assert.AreEqual(d2, size.KiloBytes);
  Assert.AreEqual(d3, size.MegaBytes);
  Assert.AreEqual(d4, size.GigaBytes);
end;

procedure TArithmeticMethods.AddTeraBytesMethod();
var
  size: TByteSize;
  d0, d1, d2, d3, d4, d5: Double;
begin

  d0 := (4.0 * 1024 * 1024 * 1024 * 1024 * 8);
  d1 := (4.0 * 1024 * 1024 * 1024 * 1024);
  d2 := (4.0 * 1024 * 1024 * 1024);
  d3 := (4.0 * 1024 * 1024);
  d4 := (4.0 * 1024);
  d5 := 4.0;
  size := TByteSize.FromTeraBytes(2).AddTeraBytes(2);

  Assert.AreEqual(d0, size.Bits.ToDouble);
  Assert.AreEqual(d1, size.Bytes);
  Assert.AreEqual(d2, size.KiloBytes);
  Assert.AreEqual(d3, size.MegaBytes);
  Assert.AreEqual(d4, size.GigaBytes);
  Assert.AreEqual(d5, size.TeraBytes);
end;

procedure TArithmeticMethods.AddPetaBytesMethod();
var
  size: TByteSize;
  d0, d1, d2, d3, d4, d5, d6: Double;
begin

  d0 := (4.0 * 1024 * 1024 * 1024 * 1024 * 1024 * 8);
  d1 := (4.0 * 1024 * 1024 * 1024 * 1024 * 1024);
  d2 := (4.0 * 1024 * 1024 * 1024 * 1024);
  d3 := (4.0 * 1024 * 1024 * 1024);
  d4 := (4.0 * 1024 * 1024);
  d5 := 4.0 * 1024;
  d6 := 4.0;

  size := TByteSize.FromPetaBytes(2).AddPetaBytes(2);

  Assert.AreEqual(d0, size.Bits.ToDouble);
  Assert.AreEqual(d1, size.Bytes);
  Assert.AreEqual(d2, size.KiloBytes);
  Assert.AreEqual(d3, size.MegaBytes);
  Assert.AreEqual(d4, size.GigaBytes);
  Assert.AreEqual(d5, size.TeraBytes);
  Assert.AreEqual(d6, size.PetaBytes);
end;

procedure TArithmeticMethods.SubtractMethod();
var
  size: TByteSize;
begin
  size := (TByteSize.FromBytes(4)).Subtract(TByteSize.FromBytes(2));
  Assert.AreEqual(Int64(16), size.Bits);
  Assert.AreEqual((2).ToDouble, size.Bytes);
end;

procedure TArithmeticMethods.IncrementOperator();
var
  size: TByteSize;
begin
  size := TByteSize.FromBytes(2);
  Inc(size);

  Assert.AreEqual(Int64(24), size.Bits);
  Assert.AreEqual((3).ToDouble, size.Bytes);
end;

procedure TArithmeticMethods.DecrementOperator();
var
  size: TByteSize;
begin
  size := TByteSize.FromBytes(2);
  Dec(size);

  Assert.AreEqual(Int64(8), size.Bits);
  Assert.AreEqual((1).ToDouble, size.Bytes);
end;

procedure TArithmeticMethods.MinusOperator();
var
  size: TByteSize;
begin
  size := TByteSize.FromBytes(2);
  size := -size;

  Assert.AreEqual(Int64(-16), size.Bits);
  Assert.AreEqual((-2).ToDouble, size.Bytes);
end;

initialization

TDUnitX.RegisterTestFixture(TArithmeticMethods);

end.
