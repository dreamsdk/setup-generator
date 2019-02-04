[Code]
const
  sLineBreak = #13#10;
  MAX_RAND_SEED = $FFFFFFFF;  

var
  BrowseForFolderExFakePage: TInputDirWizardPage;
    
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
function ExtractStr(LeftSubStr, RightSubStr, S: String): String;
begin
  Result := Left(RightSubStr, Right(LeftSubStr, S));
end;

function IsInString(const SubStr, S: string): Boolean;
begin
  Result := Pos(LowerCase(SubStr), LowerCase(S)) > 0;
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

function CreateBrowseForFolderExFakePage: Integer;
begin
  // Create BrowseForFolderExFakePage
  BrowseForFolderExFakePage := CreateInputDirPage(wpWelcome, '', '', '', False, SetupMessage(msgButtonNewFolder));
  BrowseForFolderExFakePage.Add('');
  Result := BrowseForFolderExFakePage.ID;
end;

procedure BrowseForFolderEx(var Directory: String);
begin
  BrowseForFolderExFakePage.Values[0] := Directory;
  BrowseForFolderExFakePage.Buttons[0].OnClick(BrowseForFolderExFakePage.Buttons[0]);
  Directory := BrowseForFolderExFakePage.Values[0];
end;

function RunCommand(const CommandLine: String): String;
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
    Log(CustomMessage('LogRunCommandError'));
  
  if LoadStringFromFile(TmpFileName, ExecBuffer) then
  begin
    ExecBuffer := AdjustLineBreaks(ExecBuffer);
    Result := ExecBuffer;
    Log(Result);
  end
  else
    Log(CustomMessage('LogRunCommandNoOutputError'));
  
  if FileExists(TmpFileName) then
    DeleteFile(TmpFileName);
end;
