[Code]

function GetMsysInstallationPath(Dummy: String): String;
begin
  Result := ExpandConstant('{app}');
  if IsFoundationMinGW then
    Result := ExpandConstant('{app}\msys\1.0\');
end;

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
  ManagerFileName := ExpandConstant('{app}\{#AppManagerExeName}');
  
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
  VersionFileName := ExpandConstant('{app}\{#AppMainDirectory}\' + 'VERSION');
  PatchFile(VersionFileName, '(RELEASE)', '{#MyAppVersion}');  
  PatchFile(VersionFileName, '(DATE)', '{#BuildDateTime}');
  PatchFile(VersionFileName, '(BUILD_NUMBER)', '{#FullVersionNumber}');
end;

procedure CreateJunctions;
begin
  if IsFoundationMinGW then
    CreateJunction('{code:GetMsysInstallationPath}', '{app}\usr');
end;

procedure RemoveJunctions;
begin
//  if IsFoundationMinGW then
    RemoveJunction('{app}\usr');
end;

procedure AddGitSafeDirectories;
begin
  AddGitSafeDirectory('kos');
  AddGitSafeDirectory('kos-ports');
  AddGitSafeDirectory('dcload\dcload-serial');
  AddGitSafeDirectory('dcload\dcload-ip');
end;
