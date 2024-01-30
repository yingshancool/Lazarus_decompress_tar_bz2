# Lazarus_decompress_tar_bz2
Lazarus_decompress_tar_bz2 is an open source project written using Lazarus (Free Pascal IDE) and aims to provide a simple and efficient tool for decompressing files in tar.bz2 format. This project leverages relevant components and libraries in Lazarus.

## import the library
```
uses
  ...... bzip2stream, libtar;
```

## register function on TForm1 Class
```
  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure DecompressTar(FileName, OutputFileName: string);
    function DecompressBzip2(SourceFile, TargetFile: string): boolean;
  private

  public  
```

## function a
```
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
```


## function b
```
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
```


## Usage example
```
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
```
