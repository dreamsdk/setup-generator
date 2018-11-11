[Code]
type
  TPrerequisiteApplication = (paGit, paPython, paSubversion);
  
const
  PYTHON_BRANCH_VERSION = '2.7';

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
  end;
  
  if FileExists(TmpFileName) then
    DeleteFile(TmpFileName);
end;

// Verify that all prerequisites are installed.
function CheckPrerequisites: Boolean;
var
  PrerequisiteVersion: String;

begin
  // Check Git
  PrerequisiteVersion := GetPrerequisiteVersion(paGit);
  IsGitInstalled := PrerequisiteVersion <> '';
  
  // Check Python
  PrerequisiteVersion := GetPrerequisiteVersion(paPython);    
  IsPythonInstalled := StartsWith(PYTHON_BRANCH_VERSION, PrerequisiteVersion);

  // Check Subversion
  PrerequisiteVersion := GetPrerequisiteVersion(paSubversion);
  IsSubversionInstalled := PrerequisiteVersion <> '';

  // Final result
  Result := IsGitInstalled and IsPythonInstalled and IsSubversionInstalled;  
end;

// Helper function that concat prerequisite message
function MakePrerequisiteMessage(const ActualValue, NewPrerequisite: String): string;
begin
  Result := ActualValue + sLineBreak + ' - ' + CustomMessage(NewPrerequisite);
end;

// This func is used when one or more prerequisite is missing.
function GeneratePrerequisiteMessage: String;
begin
  Result := '';    
  if not IsGitInstalled then
    Result := MakePrerequisiteMessage(Result, 'PrerequisiteMissingGit');
  if not IsPythonInstalled then
    Result := MakePrerequisiteMessage(Result, 'PrerequisiteMissingPython');
  if not IsSubversionInstalled then
    Result := MakePrerequisiteMessage(Result, 'PrerequisiteMissingSubversion');    
  Result := Format(CustomMessage('PrerequisiteMissing'), [Result]); 
end;

procedure PatchMountPoint;
var
  InstallPath, fstabFileName: String;

begin
  InstallPath := ExpandConstant('{app}');
  StringChangeEx(InstallPath, '\', '/', True);
  fstabFileName := ExpandConstant('{app}\msys\1.0\etc\fstab');
  PatchFile(fstabFileName, '{app}', InstallPath); 
end;

procedure SetupDreamSDK;
var
  ResultCode: Integer;
  ManagerFileName: String;

begin
  ManagerFileName := ExpandConstant('{#AppManagerExeName}');
  if not Exec(ManagerFileName, '--post-install', '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode) then
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
    Log(CustomMessage('LogCheckingConnection'));
    try
      WinHttpReq := CreateOleObject('WinHttp.WinHttpRequest.5.1');
      WinHttpReq.Open('GET', '{#MyAppURL}', False);
      WinHttpReq.Send('');
      Log(Format(CustomMessage('LogInternetConnectionAvailable'), [WinHttpReq.Status, WinHttpReq.StatusText]));
      Connected := True;
    except
      Log(Format(CustomMessage('LogInternetConnectionNotAvailable'), [GetExceptionMessage]));
      if WizardSilent then
      begin
        Log(CustomMessage('LogInternetConnectionNotAvailableAbortSilent'));
        Result := False;
        Exit;
      end
      else 
        if MsgBox(CustomMessage('InactiveInternetConnection'), mbError, MB_RETRYCANCEL) = IDRETRY then
          Log(CustomMessage('LogInternetConnectionRetry'))
        else
        begin
          Log(CustomMessage('LogInternetConnectionAbort'));
          Result := False;
          Exit;
        end;
    end;
  until Connected;
  Result := True;
end;
