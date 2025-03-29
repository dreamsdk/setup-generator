[Code]

const
  sEmptyStr = '';  
  sLineBreak = #13#10;
  MAX_RAND_SEED = $FFFFFFFF;  
  MAX_PATH = 260;

// Thanks Michel (Phidels.com)
function Left(SubStr, S: String): String;
begin
  result:=copy(s, 1, pos(substr, s)-1);
end;

// Thanks Michel (Phidels.com)
function Right(SubStr, S: String): String;
begin
  if pos(substr,s)=0 then result:='' else
    result:=copy(s, pos(substr, s)+length(substr), length(s)-pos(substr, s)+length(substr));
end;

// Thanks Michel (Phidels.com)
function ExtremeRight(SubStr: string; S: string): string;
begin
  Repeat
    S:= Right(substr,s);
  until pos(substr,s)=0;
  result:=S;
end;

// Thanks Michel (Phidels.com)
function ExtractStr(LeftSubStr, RightSubStr, S: String): String;
begin
  Result := Left(RightSubStr, Right(LeftSubStr, S));
end;

function IsInString(const SubStr, S: string): Boolean;
begin
  Result := Pos(LowerCase(SubStr), LowerCase(S)) > 0;
end;

// Replace the last occurrence of a substring in a string with something else
const
  EXTREME_RIGHT_SEPARATOR = '§§';

function ReplaceLastOccurrence(S, OldSubStr, NewSubStr: String): String;
var
  Temp,
  LeftPart,
  RightPart: String;

begin  
  Temp := S;  
  RightPart := ExtremeRight(OldSubStr, Temp);
  StringChangeEx(Temp, OldSubStr + RightPart, EXTREME_RIGHT_SEPARATOR + RightPart, True);                                     
  LeftPart := Left(EXTREME_RIGHT_SEPARATOR, Temp);
  Result := LeftPart + NewSubStr + RightPart;
end;

function AdjustLineBreaks(const S: String): String;
begin
  Result := S;
  if (Pos(sLineBreak, Result) = 0) and (Pos(#10, Result) > 0) then
    StringChangeEx(Result, #10, sLineBreak, True);
end;

// https://stackoverflow.com/a/1282143/3726096
function StartsWith(const AMatchStr, ATestStr : String) : Boolean;
begin
  Result := AMatchStr = Copy( ATestStr, 1, Length( AMatchStr ));
end;

// Replace a string in a existing file
function PatchFile(const FileName, OldValue, NewValue: String): Boolean;
var
  Temp: String;
  Buffer: TStringList;

begin
  Result := False;
  if FileExists(FileName) then
  begin
    Buffer := TStringList.Create;
    try
      Buffer.LoadFromFile(FileName);
      Temp := Buffer.Text;
      StringChangeEx(Temp, OldValue, NewValue, True);
      Buffer.Text := Temp;
      Buffer.SaveToFile(FileName);
      Result := True;
    finally
      Buffer.Free;
    end;
  end;
end;

function RunCommand(const CommandLine: String; const AutoTrim: Boolean): String;
var
  TmpFileName, Executable, RealCommandLine: String;
  ExecBuffer: AnsiString;
  ResultCode: Integer;

begin
  Executable := ExpandConstant('{cmd}');
  TmpFileName := Format('%s\%.8x.tmp', [ExpandConstant('{tmp}'), Random(MAX_RAND_SEED)]);  
  RealCommandLine := Format('/C "%s > %s 2>&1"', [CommandLine, TmpFileName]);
  
  Log(Executable + ' ' + RealCommandLine);

  if not Exec(Executable, RealCommandLine, '', SW_HIDE, ewWaitUntilTerminated, ResultCode) then
    Log('Run Command Error!');
  
  if LoadStringFromFile(TmpFileName, ExecBuffer) then
  begin
    ExecBuffer := AdjustLineBreaks(ExecBuffer);
    OemToCharBuff(ExecBuffer);
    Result := ExecBuffer;
    Log(Result);
  end
  else
    Log('Run Command Error: No output catched!');
  
  if FileExists(TmpFileName) then
    DeleteFile(TmpFileName);

  if AutoTrim then
    Result := Trim(Result);
end;

function SetDirectoryRights(DirectoryName, SID, Rights: String): Boolean;
var
  Executable,
  CommandLine: String;
  ResultCode: Integer;

begin
  Result := False;
  Log('SetDirectoryRights');
  if DirExists(DirectoryName) then
  begin
    Executable := ExpandConstant('{sys}\icacls.exe');
    if FileExists(Executable) then
    begin
      CommandLine := Format('"%s" /t /grant *%s:(OI)(CI)%s', [DirectoryName, SID, Rights]);
      Log(Format('  Executable: "%s", CommandLine: "%s"', [Executable, CommandLine]));
      
      Result := Exec(Executable, CommandLine, '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
      Log(Format('  Result: %d', [Result]));
    end
    else
      Result := True;
  end;
end;

// Split a string into an array using passed delimeter.
// Thanks to: https://stackoverflow.com/a/36895908/3726096
function Split(Expression, Delimiter: String): TArrayOfString;
var
  i: Integer;
  tmpArray : TArrayOfString;
  curString : String;

begin
  SetArrayLength(tmpArray, 0);
  if (Expression = '') then
  begin
    Result := tmpArray; 
    Exit;
  end;

  i := 0;
  curString := Expression;

  repeat
    SetArrayLength(tmpArray, i+1);
    If Pos(Delimiter, curString) > 0 then
    begin
      tmpArray[i] := Copy(curString, 1, Pos(Delimiter, curString)-1);
      curString := Copy(curString, Pos(Delimiter,curString) + Length(Delimiter), Length(curString));
      Inc(i);
    end 
    else 
    begin
      tmpArray[i] := curString;
      curString := '';
    end;
  until Length(curString) = 0;

  Result:= tmpArray;
end;

function FormatSize(Size: Int64): String;
var
  GB, MB, KB, B: Int64;

begin
  GB := Size div (1024 * 1024 * 1024);
  MB := (Size mod (1024 * 1024 * 1024)) div (1024 * 1024);
  KB := ((Size mod (1024 * 1024 * 1024)) mod (1024 * 1024)) div 1024;
  B := ((Size mod (1024 * 1024 * 1024)) mod (1024 * 1024)) mod 1024;
  if GB > 0 then
    Result := Format('%d GB', [GB])
  else if MB > 0 then
    Result := Format('%d MB', [MB])
  else if KB > 0 then
    Result := Format('%d KB', [KB])
  else
    Result := Format('%d B', [B]);
end;

function BoolToStrCustom(B: Boolean; const TrueS: String; const FalseS: String): String;
begin
  Result := TrueS;
  if not B then Result := FalseS;    
end;

function BoolToStr(B: Boolean): String;
begin
  Result := BoolToStrCustom(B, 'True', 'False');
end;
