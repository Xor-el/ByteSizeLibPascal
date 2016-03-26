program ByteSizeLibPascal;

uses
  Vcl.Forms,
  uByteSize in 'src\Main\uByteSize.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Run;
end.
