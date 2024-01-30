unit uMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, bzip2stream, libtar;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure DecompressTar(FileName, OutputFileName: string);
    function DecompressBzip2(SourceFile, TargetFile: string): boolean;
  private

  public


  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

function TForm1.DecompressBzip2(SourceFile, TargetFile: string): boolean;
var
  InFile: TFileStream;
  Decompressed: TDecompressBzip2Stream;
  OutFile: TFileStream;
  Buffer: Pointer;
  i: integer;
const
  buffersize = 8096;
begin
  Result := False;
  InFile := TFileStream.Create(SourceFile, fmOpenRead);
  try
    Decompressed := TDecompressBzip2Stream.Create(InFile);
    OutFile := TFileStream.Create(TargetFile, fmCreate);
    try
      GetMem(Buffer, BufferSize);
      repeat
        i := Decompressed.Read(buffer^, BufferSize);
        if i > 0 then
          OutFile.WriteBuffer(buffer^, i);
      until i < BufferSize;
      Result := True;
    finally
      Decompressed.Free;
      OutFile.Free;
    end;
  finally
    InFile.Free;
  end;
end;

procedure TForm1.DecompressTar(FileName, OutputFileName: string);
var
  TA: TTarArchive;
  DirRec: TTarDirRec;
begin
  TA := TTarArchive.Create(FileName);
  TA.Reset;

  while TA.FindNext(DirRec) do
  begin
    if (DirRec.FileType = ftDirectory) and not DirectoryExists(OutputFileName + ExtractFilePath(DirRec.Name)) then;
    begin
      ForceDirectories(OutputFileName + ExtractFilePath(DirRec.Name));
    end;

    TA.ReadFile(OutputFileName + DirRec.Name);
  end;


  TA.Free;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  InputFileName, OutputFileName: string;
begin
  // 输入和输出文件名
  InputFileName := 'Git-2.43.0-64-bit.tar.bz2';
  OutputFileName := 'decompressed_file.tar';

  DecompressBzip2(InputFileName, OutputFileName);

  if not DirectoryExists('./abc/') then
  begin
    CreateDir('./abc/');
  end;


  DecompressTar(OutputFileName, './abc/');
end;




end.
