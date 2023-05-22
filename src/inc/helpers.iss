[Code]

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

procedure SetupApplication;
var
  ResultCode: Integer;
  ManagerFileName,
  Parameters,
  RubySwitch: String;

begin
  ManagerFileName := ExpandConstant('{#AppManagerExeName}');
  
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
  VersionFileName := ExpandConstant('{#AppMainDirectory}\' + 'VERSION');
  PatchFile(VersionFileName, '(RELEASE)', '{#MyAppVersion}');  
  PatchFile(VersionFileName, '(DATE)', '{#BuildDateTime}');
  PatchFile(VersionFileName, '(BUILD_NUMBER)', '{#FullVersionNumber}');
end;

procedure CreateJunctions;
begin
  CreateJunction('{#AppMsysBase}', '{app}\usr');
end;

procedure RemoveJunctions;
begin
  RemoveJunction('{app}\usr');
end;
