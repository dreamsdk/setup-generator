[Code]
const
  sLineBreak = #13#10;
  MAX_RAND_SEED = $FFFFFFFF;  

var
  BrowseForFolderExFakePage: TInputDirWizardPage;
  CurrentUserRealAppDataDirectory: String;
    
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
    Log('Run Command Error!');
  
  if LoadStringFromFile(TmpFileName, ExecBuffer) then
  begin
    ExecBuffer := AdjustLineBreaks(ExecBuffer);
    OemToCharBuff(ExecBuffer);
    Result := ExecBuffer;
    Log(Result);
  end
  else
    Log('Run Command Error: No output catch!');
  
  if FileExists(TmpFileName) then
    DeleteFile(TmpFileName);
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

// https://stackoverflow.com/a/43248500
function GetCurrentUserRealAppDataDirectory: String;
var
  AppDataPath,
  TempFileName,
  Cmd,
  Params: String;
  ResultCode: Integer;
  Buf: AnsiString;

begin
  if not DirExists(CurrentUserRealAppDataDirectory) then
  begin
    AppDataPath := ExpandConstant('{userappdata}');
    Log(Format('Default/Fallback application data path: %s', [AppDataPath]));
    TempFileName := ExpandConstant('{tmp}\is-appdata.tmp');
    Cmd := ExpandConstant('{cmd}');
    Params := Format('/C echo %%AppData%% > "%s"', [TempFileName]);
    Log(Format('Resolving AppData using %s', [Params]));
    if ExecAsOriginalUser(Cmd, Params, '', SW_HIDE, ewWaitUntilTerminated, ResultCode) 
      and (ResultCode = 0) then
    begin
      if LoadStringFromFile(TempFileName, Buf) then
      begin
        AppDataPath := Trim(Buf);
        Log(Format('AppData resolved to %s', [AppDataPath]));
      end
      else
        Log(Format('Error reading %s', [TempFileName]));
      DeleteFile(TempFileName);
    end
    else
      Log(Format('Error %d resolving AppData', [ResultCode]));
    CurrentUserRealAppDataDirectory := AddBackslash(AppDataPath);
  end;
  Result := CurrentUserRealAppDataDirectory;
end;

function SetPageIcon(const Name: string; Page: TWizardPage): TBitmapImage;var
  FileName: string;

begin
  FileName := Name + '.bmp';

  ExtractTemporaryFile(FileName);
    
  Result := TBitmapImage.Create(Page);

  with Result do
  begin
    Parent := Page.Surface;
    Bitmap.LoadFromFile(ExpandConstant('{tmp}') + '\' + FileName);
    Bitmap.AlphaFormat := afPremultiplied;
    AutoSize := True;
    Left := 0;
    Top := 0;
  end;
end;

function SetMultiLinesLabel(ControlLabel: TLabel; Lines: Integer): Boolean;
var
  ParentPage: TWizardPage;
  SingleLineHeight: Integer;

begin
  ParentPage := (ControlLabel.Owner as TWizardPage);
  Result := Assigned(ParentPage);

  if Result then
  begin
    SingleLineHeight := ControlLabel.Height;
    ControlLabel.AutoSize := False;
    ControlLabel.WordWrap := True;
    ControlLabel.Height := SingleLineHeight * Lines;
    ControlLabel.Width := ParentPage.SurfaceWidth;
  end;
end;