[Code]
type
  TPrerequisiteApplication = (paGit, paPython, paSubversion);

var
  IsPythonInstalled,
  IsGitInstalled,
  IsSubversionInstalled: Boolean;
  
function PrerequisiteToString(const Prerequisite: TPrerequisiteApplication): String;
begin
  Result := '';
  case Prerequisite of
    paGit: 
      Result := 'git'; 
    paPython:
      Result := 'python';
    paSubversion:
      Result := 'svn';
  end;
end;

function GetExtractionTag(const Prerequisite: TPrerequisiteApplication): String;
begin
  Result := '';
  case Prerequisite of
    paGit:
      Result := 'git version';                  
    paPython:
      Result := 'Python';
    paSubversion:
      Result := 'svn, version';
  end;
end;

// Retrieve installed prerequisite version
function GetPrerequisiteVersion(const Prerequisite: TPrerequisiteApplication): String;
var
  TmpFileName, CommandLine, PrerequisiteName, ExtractionTag: String;
  ExecBuffer: AnsiString;
  ResultCode: Integer; 

begin
  PrerequisiteName := PrerequisiteToString(Prerequisite);
  ExtractionTag := GetExtractionTag(Prerequisite);
      
  TmpFileName := Format('%s\%s.tmp', [ExpandConstant('{tmp}'), PrerequisiteName]);
  CommandLine := Format('/C %s --version > "%s" 2>&1', [PrerequisiteName, TmpFileName]);
  
  Exec(ExpandConstant('{cmd}'), CommandLine, '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  if LoadStringFromFile(TmpFileName, ExecBuffer) then
  begin
    ExecBuffer := AdjustLineBreaks(ExecBuffer);
    Result := Trim(ExtractStr(ExtractionTag, sLineBreak, ExecBuffer));
    Log(Format('Prerequisite %s version: %s.', [PrerequisiteName, Result]));
  end;
  
  if FileExists(TmpFileName) then
    DeleteFile(TmpFileName);
end;

function CheckMandatoryPrerequisites: Boolean;
var
  PrerequisiteVersion: String;

begin
  // Check Python
  PrerequisiteVersion := GetPrerequisiteVersion(paPython);    
  IsPythonInstalled := PrerequisiteVersion <> '';
  
  // Final result
  Result := IsPythonInstalled; 
end;

// Verify that all prerequisites are installed.
function CheckOnlineMandatoryPrerequisites: Boolean;
var
  PrerequisiteVersion: String;

begin
  // Check Git
  PrerequisiteVersion := GetPrerequisiteVersion(paGit);
  IsGitInstalled := PrerequisiteVersion <> '';
  
  // Final result
  Result := IsGitInstalled;  
end;

// Verify that all optional prerequisites are installed.
function CheckOnlineOptionalPrerequisites: Boolean;
var
  PrerequisiteVersion: String;

begin
  // Check Subversion
  PrerequisiteVersion := GetPrerequisiteVersion(paSubversion);
  IsSubversionInstalled := PrerequisiteVersion <> '';

  // Final result
  Result := IsSubversionInstalled;
end;

function MakePrerequisiteMessage(Prerequisite: String; Mandatory: Boolean): String;
var
  Message: String;

begin
  Message := CustomMessage('PrerequisiteMissing') + ' ';
  if Mandatory then
    Message := Message + CustomMessage('PrerequisiteMissingHintMandatory')
  else
    Message := Message + CustomMessage('PrerequisiteMissingHintOptional');
  Result := Format(Message, [CustomMessage(Prerequisite)]);
end;

// This func is used when one or more prerequisites is missing.
function GenerateMandatoryPrerequisiteMessage: String;
begin
  Result := '';    
  if not IsPythonInstalled then
    Result := MakePrerequisiteMessage('PrerequisiteMissingPython', True);
end;

// Online: This func is used when one or more optional prerequisites is missing. 
function GenerateOnlinePrerequisiteMessage: String;
begin
  Result := '';    
  if not IsGitInstalled then
    Result := MakePrerequisiteMessage('PrerequisiteMissingGit', True); 
end;

// Online: This func is used when one or more optional prerequisites is missing.
function GenerateOnlineOptionalPrerequisiteMessage: String;
begin
  Result := '';
  if not IsSubversionInstalled then
    Result := MakePrerequisiteMessage('PrerequisiteMissingSubversion', False); 
end;

procedure PatchMountPoint;
var
  InstallPath, fstabFileName: String;

begin
  InstallPath := ExpandConstant('{app}');
  StringChangeEx(InstallPath, '\', '/', True);
  fstabFileName := ExpandConstant('{app}\msys\1.0\etc\fstab');
  PatchFile(fstabFileName, '{app}', InstallPath);
  PatchFile(fstabFileName + '.sample', '{app}', InstallPath); 
end;

procedure SetupDreamSDK;
var
  ResultCode: Integer;
  ManagerFileName: String;

begin
  ManagerFileName := ExpandConstant('{#AppManagerExeName}');
  if not ExecAsOriginalUser(ManagerFileName, '--post-install', '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode) then
    MsgBox(CustomMessage('UnableToFinalizeSetup'), mbCriticalError, MB_OK);
end;

procedure SetPackageVersion;
var
  VersionFileName: String;

begin
  VersionFileName := ExpandConstant('{#AppMainDirectory}\' + 'VERSION');
  PatchFile(VersionFileName, '(RELEASE)', '{#MyAppVersion}');  
  PatchFile(VersionFileName, '(DATE)', '{#BuildDateTime}');
end;

procedure FinalizeSetup;
begin
  SetPackageVersion;
  PatchMountPoint;
  SetupDreamSDK;
end;
// https://stackoverflow.com/a/39291592/3726096
function CheckInternetConnection: Boolean;
var
  WinHttpReq: Variant;
  Connected: Boolean;

begin
  Connected := False;
  repeat
    Log('Checking connection to the server');
    try
      WinHttpReq := CreateOleObject('WinHttp.WinHttpRequest.5.1');
      WinHttpReq.Open('GET', '{#TestConnectionURL}', False);
      WinHttpReq.Send('');
      Log(Format('Connected to the server; status: %s %s', [WinHttpReq.Status, WinHttpReq.StatusText]));
      Connected := True;
    except
      Log(Format('Error connecting to the server: %s', [GetExceptionMessage]));
      if WizardSilent then
      begin
        Log('Connection to the server is not available, aborting silent installation');
        Result := False;
        Exit;
      end
      else 
        if MsgBox(CustomMessage('InactiveInternetConnection'), mbError, MB_RETRYCANCEL) = IDRETRY then
          Log('Retrying')
        else
        begin
          Log('Aborting');
          Result := False;
          Exit;
        end;
    end;
  until Connected;
  Result := True;
end;
