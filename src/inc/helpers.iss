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
  Parameters: String;

begin
  ManagerFileName := ExpandConstant('{#AppManagerExeName}');
  Parameters := Format('--post-install --home-dir "%s"', [
    ExpandConstant('{app}')]);
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
end;
