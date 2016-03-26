ByteSizeLibPascal 
===========

**This is a Port of [ByteSize](https://github.com/omar/ByteSize) to Delphi/FreePascal.**

`TByteSize` is a utility "record" that makes byte size representation in code easier by removing ambiguity of the value being represented.

`TByteSize` is to bytes what `System.TimeSpan.TTimeSpan` is to time.

#### Building

This project was created using Delphi 10 Seattle Update 1 but should compile in 
any Delphi version from XE3 and FreePascal 3.0 Upwards.  

## Usage 

Without `TByteSize`:

```pascal
const
  MaxFileSizeMBs = 1.5;

// I need it in KBs!

var 
 kilobytes: Double;
begin
 kilobytes := MaxFileSizeMBs * 1024;
end;
```

With `ByteSize`:

```pascal
var
 MaxFileSize: TByteSize;
begin
 MaxFileSize := TByteSize.FromMegaBytes(1.5);
end;

// I have it in KBs!
MaxFileSize.KiloBytes;
```

`TByteSize` behaves like any other `record` backed by a numerical value.

```pascal
// Add
var
monthlyUsage, currentUsage, total, delta, : TByteSize;
begin 
 monthlyUsage := TByteSize.FromGigaBytes(10);
 currentUsage := TByteSize.FromMegaBytes(512);
 total := monthlyUsage + currentUsage;

total.Add(ByteSize.FromKiloBytes(10));
total.AddGigaBytes(10);

// Subtract
delta := total.Subtract(TByteSize.FromKiloBytes(10));
delta := delta - TByteSize.FromGigaBytes(100);
delta := delta.AddMegaBytes(-100);

end;
```

### Constructors

You can create a `ByteSize` "object" from `bits`, `bytes`, `kilobytes`, `megabytes`, `gigabytes`, and `terabytes`.

```pascal
 TByteSize.Create(1.5);           // Constructor takes in bytes

// Static Constructors
TByteSize.FromBits(10);       // Bits are whole numbers only
TByteSize.FromBytes(1.5);     // Same as constructor
TByteSize.FromKiloBytes(1.5);
TByteSize.FromMegaBytes(1.5);
TByteSize.FromGigaBytes(1.5);
TByteSize.FromTeraBytes(1.5);
TByteSize.FromPetaBytes(1.5);

```

### Properties

A `TByteSize` "object" contains representations in `bits`, `bytes`, `kilobytes`, `megabytes`, `gigabytes`, `terabytes` and `petabytes`.

```pascal
var
maxFileSize: TByteSize;
begin
 maxFileSize := TByteSize.FromKiloBytes(10);

maxFileSize.Bits;      // 81920
maxFileSize.Bytes;     // 10240
maxFileSize.KiloBytes; // 10
maxFileSize.MegaBytes; // 0.009765625
maxFileSize.GigaBytes; // 9.53674316e-6
maxFileSize.TeraBytes; // 9.31322575e-9
end;
```

A `TByteSize` "object" also contains two properties that represent the largest metric prefix symbol and value.

```pascal
var 
maxFileSize: TByteSize;
begin
 maxFileSize := TByteSize.FromKiloBytes(10);

maxFileSize.LargestWholeNumberSymbol;  // "KB"
maxFileSize.LargestWholeNumberValue;   // 10

end;
```

### String Representation

#### ToString

`TByteSize` comes with a handy `ToString` method that uses the largest metric prefix whose value is greater than or equal to 1.

```pascal
TByteSize.FromBits(7).ToString;         // 7 b
TByteSize.FromBits(8).ToString;         // 1 B
TByteSize.FromKiloBytes(.5).ToString;   // 512 B
TByteSize.FromKiloBytes(1000).ToString; // 1000 KB
TByteSize.FromKiloBytes(1024).ToString; // 1 MB
TByteSize.FromGigabytes(.5).ToString;   // 512 MB
TByteSize.FromGigabytes(1024).ToString; // 1 TB
```

#### Formatting

The `ToString` method accepts a single `string` parameter to format the output. The formatter can contain the symbol of the value to display: `b`, `B`, `KB`, `MB`, `GB`, `TB`, `PB`. The formatter uses the built in [`FormatFloat` method](http://docwiki.embarcadero.com/Libraries/Seattle/en/System.SysUtils.FormatFloat). The default number format is `#.##` which rounds the number to two decimal places.

You can include symbol and number formats.

```pascal
var 
b: TByteSize;
begin
b := TByteSize.FromKiloBytes(10.505);

// Default number format is #.##
b.ToString('KB');         // 10.52 KB
b.ToString('MB');         // .01 MB
b.ToString('b');          // 86057 b

// Default symbol is the largest metric prefix value >= 1
b.ToString('#.#');        // 10.5 KB

// All valid values of double.ToString(string format) are acceptable
b.ToString('0.0000');     // 10.5050 KB
b.ToString('000.00');     // 010.51 KB

// You can include number format and symbols
b.ToString('#.#### MB');  // .0103 MB
b.ToString('0.00 GB');    // 0 GB
b.ToString('#.## B');     // 10757.12 B
end;
```

#### Parsing

`ByteSize` has a `Parse` and `TryParse` method.

Like other `TryParse` methods, `ByteSize.TryParse` returns `boolean` value indicating whether or not the parsing was successful. If the value is parsed it is output to the `out` parameter supplied.

```pascal
var
output: TByteSize;
begin
TByteSize.TryParse('1.5mb', output);

// Invalid
TByteSize.Parse('1.5 b');   // Can't have partial bits

// Valid
TByteSize.Parse('5b');
TByteSize.Parse('1.55B');
TByteSize.Parse('1.55KB');
TByteSize.Parse('1.55 kB '); // Spaces are trimmed
TByteSize.Parse('1.55 kb');
TByteSize.Parse('1.55 MB');
TByteSize.Parse('1.55 mB');
TByteSize.Parse('1.55 mb');
TByteSize.Parse('1.55 GB');
TByteSize.Parse('1.55 gB');
TByteSize.Parse('1.55 gb');
TByteSize.Parse('1.55 TB');
TByteSize.Parse('1.55 tB');
TByteSize.Parse('1.55 tb');
end;
```

###Unit Tests

    Unit Tests can be found in ByteSizeLib.Tests Folder.
    The unit tests makes use of DUnitX and TestInsight.

###License

This "Software" is Licensed Under  **`MIT License (MIT)`** .

###Conclusion


   Special Thanks to [Omar Khudeira](https://github.com/omar/) for [this](https://github.com/omar/ByteSize) awesome library.
(Thanks to the developers of [DUnitX Testing Framework](https://github.com/VSoftTechnologies/DUnitX/) and [TestInsight](https://bitbucket.org/sglienke/testinsight/wiki/Home/) for making tools that simplifies unit testing.

