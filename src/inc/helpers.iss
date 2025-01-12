[Code]

procedure PatchMountPoint;
var
  InstallPath, fstabFileName: String;

begin
  if IsFoundationMinGW then
  begin
    InstallPath := ExpandConstant('{app}');
    StringChangeEx(InstallPath, '\', '/', True);
    fstabFileName := ExpandConstant('{app}\msys\1.0\etc\fstab');
    PatchFile(fstabFileName, '{app}', InstallPath);
    PatchFile(fstabFileName + '.sample', '{app}', InstallPath); 
  end;
end;

procedure SetupApplication;
var
  ResultCode: Integer;
  ManagerFileName,
  Parameters,
  RubySwitch: String;

begin
  ManagerFileName := ExpandConstant('{code:GetApplicationComponentManagerFilePath}');
  
  RubySwitch := '';
  if IsRubyEnabled then
    RubySwitch := ' --enable-ruby';

  Parameters := Format('--post-install --home-dir "%s"%s', [
    ExpandConstant('{app}'), RubySwitch]);

  Log(Format('%s %s', [ManagerFileName, Parameters]));

  if not ExecAsOriginalUser(ManagerFileName, Parameters, '', SW_SHOWNORMAL,
    ewWaitUntilTerminated, ResultCode) then
      MsgBox(CustomMessage('UnableToFinalizeSetup'), mbCriticalError, MB_OK);
end;

procedure SetPackageVersion;
var
  VersionFileName: String;

begin
  VersionFileName := ExpandConstant('{code:GetApplicationMainPath}\VERSION');
  PatchFile(VersionFileName, '(RELEASE)', '{#MyAppVersion}');  
  PatchFile(VersionFileName, '(DATE)', '{#BuildDateTime}');
  PatchFile(VersionFileName, '(BUILD_NUMBER)', '{#FullVersionNumber}');
end;

procedure CreateJunctions;
begin
  Log('CreateJunctions');
  if IsFoundationMinGW then
    CreateJunction('{code:GetMsysInstallationPath}', '{app}\usr');
end;

procedure RemoveJunctions;
begin
  Log('RemoveJunctions');
  if IsFoundationMinGW then
    RemoveJunction('{app}\usr');
end;

procedure AddGitSafeDirectories;
begin
  AddGitSafeDirectory('kos');
  AddGitSafeDirectory('kos-ports');
  AddGitSafeDirectory('dcload\dcload-serial');
  AddGitSafeDirectory('dcload\dcload-ip');
end;

procedure LoadFoundationFromFile;
var
  Buffer: AnsiString;
  FoundationIndex: Integer;

begin
  Log('LoadFoundationFromFile');
  LoadStringFromFile(ExpandConstant('{code:GetFoundationFilePath}'), Buffer);
  FoundationIndex := StrToIntDef(Buffer, -1);
  case FoundationIndex of
    1: SetFoundation(efkMinGWMSYS);
    2: SetFoundation(efkMinGW64MSYS2);
  end;
end;

procedure SaveFoundationToFile;
var
  Buffer: String;
  
begin
  Log('SaveFoundationToFile');
  Buffer := IntToStr(Ord(Foundation));
  SaveStringToFile(ExpandConstant('{code:GetFoundationFilePath}'), Buffer, False);
end;

procedure RemoveFoundationFile;
var
  FileName: String;

begin
  FileName := ExpandConstant('{code:GetFoundationFilePath}');
  if FileExists(FileName) then
    DeleteFile(FileName);
end;

