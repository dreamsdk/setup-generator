[Code]

procedure PatchMountPoint;
var
  InstallPath,
  fstabFileName: String;

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
  Parameters: String;

begin
  ManagerFileName := ExpandConstant('{code:GetApplicationComponentManagerFilePath}');
   
  Parameters := Format('--post-install --home-dir "%s"', [
    ExpandConstant('{app}')
  ]);

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
  Log(Format('  FoundationIndex: %d', [FoundationIndex]));
  if (FoundationIndex = 2) then
    SetFoundation(efkMinGW64MSYS2)
  else
    SetFoundation(efkMinGWMSYS);  
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

procedure RenamePreviousDirectoriesBeforeInstallation;
begin
  Log('RenamePreviousDirectoriesBeforeInstallation');
  RenameFileOrDirectoryAsBackup(ExpandConstant('{code:GetApplicationToolchainBasePath}'));
  RenameFileOrDirectoryAsBackup(ExpandConstant('{code:GetApplicationOptBasePath}\mruby'));
end;

function VersionSanitizer(const VersionNumber: String): String;
begin
  Result := VersionNumber;  
  StringChangeEx(Result, 'R', '', True);
  StringChangeEx(Result, '-dev', '', True);
  Log(Format('VersionSanitizer: Old=%s, New=%s', [VersionNumber, Result]));
end;

procedure VersionBeforeUninstall;
begin
  Log('VersionBeforeUninstall called');
  
  LoadFoundationFromFile;

  RenameFileOrDirectoryAsBackup(ExpandConstant('{code:GetApplicationToolchainBasePath}'));
  RenameFileOrDirectoryAsBackup(ExpandConstant('{code:GetApplicationOptBasePath}\mruby'));
end;

procedure GlobalInitialization();
begin
  Log('GlobalInitialization called');

  SetWizardDirValueInitialized(False);
  VersionSetDynamicFunctionSanitize(@VersionSanitizer);
  SetDoBeforeUninstall(@VersionBeforeUninstall);
end;
