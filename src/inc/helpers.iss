[Code]
const
  CODEBLOCKS_EXE_NAME = 'codeblocks.exe';

// Unload all helper DLLs, otherwise they aren't deleted
procedure UnloadHelperLibraries();
begin
  PSVinceUnload();
  HelperLibraryUnload();
end;

function IsModulesRunning(): Boolean;
begin
  Result := False;

  // Check if Code::Blocks is running
  Result := IsProcessRunning(CODEBLOCKS_EXE_NAME);
  if Result then
  begin
    MsgBox(CustomMessage('CodeBlocksRunning'), mbError, MB_OK);
    Exit;    
  end;   
end;

procedure PatchMountPoint();
var
  InstallPath,
  fstabFileName: String;

begin
  if not IsFoundationMinGW then
    Exit;

  InstallPath := ExpandConstant('{app}');
  StringChangeEx(InstallPath, '\', '/', True);
  fstabFileName := ExpandConstant('{code:GetMsysInstallationPath}\etc\fstab');
  PatchFile(fstabFileName, '{app}', InstallPath);
  PatchFile(fstabFileName + '.sample', '{app}', InstallPath); 
end;

procedure PatchSystemSettings();
var
  MSystemFilePath,
  ProfileFilePath: String;

begin
  MSystemFilePath := ExpandConstant('{code:GetMsysInstallationPath}\etc\msystem');
  PatchFile(MSystemFilePath, '{MSYSTEM:-MSYS}', '{MSYSTEM:-MINGW64}');
  ProfileFilePath := ExpandConstant('{code:GetMsysInstallationPath}\etc\profile');
  PatchFile(ProfileFilePath, '{MSYS2_PATH_TYPE:-minimal}', '{MSYS2_PATH_TYPE:-inherit}');
end;

procedure ApplyPostInstallPatches();
begin
  if IsFoundationMinGW() then
    PatchMountPoint();

  if IsFoundationMinGW64() then
    PatchSystemSettings();
end;

// Fallback: execute the post-install steps through DreamSDK Manager
procedure SetupApplicationWithManager();
var
  ResultCode: Integer;
  ManagerFileName,
  Parameters: String;

begin
  ManagerFileName := ExpandConstant('{code:GetApplicationComponentManagerFilePath}');
   
  Parameters := Format('--post-install --home-dir "%s"', [
    ExpandConstant('{code:GetApplicationRootPath}')
  ]);

  Log(Format('%s %s', [ManagerFileName, Parameters]));

  if not ExecAsOriginalUser(ManagerFileName, Parameters, '', SW_SHOWNORMAL,
    ewWaitUntilTerminated, ResultCode) then
      MsgBox(CustomMessage('UnableToFinalizeSetup'), mbCriticalError, MB_OK);
end;

// Execute the post-install steps (i.e., unpacking toolchains, installing
// KallistiOS, KallistiOS Ports and Dreamcast Tool)
procedure SetupApplication();
var
  HomeDirectory: String;

begin
  HomeDirectory := ExpandConstant('{code:GetApplicationRootPath}');
  case RunPostInstallHelper(HomeDirectory) of
    POST_INSTALL_STATUS_SUCCEEDED:
      Log('SetupApplication: post-install done');

    POST_INSTALL_STATUS_FAILED:
      MsgBox(FmtMessage(CustomMessage('PostInstallFailed'),
        [GetPostInstallLogFileName(HomeDirectory)]), mbError, MB_OK);

    POST_INSTALL_STATUS_ABORTED:
      MsgBox(CustomMessage('PostInstallAborted'), mbInformation, MB_OK);

  else
    begin
      // The post-install helper couldn't be used at all
      Log('SetupApplication: post-install helper unavailable, using DreamSDK Manager');
      SetupApplicationWithManager();
    end;
  end;
end;

procedure SetPackageVersion();
var
  VersionFileName: String;

begin
  VersionFileName := ExpandConstant('{code:GetApplicationMainPath}\VERSION');
  PatchFile(VersionFileName, '(RELEASE)', '{#MyAppVersion}');  
  PatchFile(VersionFileName, '(DATE)', '{#BuildDateTime}');
  PatchFile(VersionFileName, '(BUILD_NUMBER)', '{#FullVersionNumber}');
end;

procedure CreateJunctions();
begin
  Log('CreateJunctions');

  if IsFoundationMinGW() then
    // MinGW/MSYS
    CreateJunction('{code:GetMsysInstallationPath}', '{app}\usr')
  else if not DirExists(ExpandConstant('{app}\msys')) then
  begin
    // MinGW-w64/MSYS2  
    ForceDirectories(ExpandConstant('{app}\msys'));
    if CreateJunction('{code:GetMsysInstallationPath}', '{app}\msys\1.0') then
      HideFileOrDirectory(ExpandConstant('{app}\msys'));
  end;
end;

procedure RemoveJunctions();
begin
  Log('RemoveJunctions');

  if IsFoundationMinGW() then
    // MinGW/MSYS  
    RemoveJunction(ExpandConstant('{app}\usr'))
  else
  begin
    // MinGW-w64/MSYS2    
    if RemoveJunction(ExpandConstant('{app}\msys\1.0')) then
      DelTree(ExpandConstant('{app}\msys'), True, False, False);
  end;
end;

procedure AddGitSafeDirectories();
begin
  AddGitSafeDirectory('kos');
  AddGitSafeDirectory('kos-ports');
  AddGitSafeDirectory('dcload\dcload-serial');
  AddGitSafeDirectory('dcload\dcload-ip');
end;

procedure LoadFoundationFromFile();
var
  Buffer: AnsiString;
  FoundationIndex: Integer;

begin
  Log('LoadFoundationFromFile');
  LoadStringFromFile(ExpandConstant('{code:GetFoundationFilePath}'), Buffer);
  FoundationIndex := StrToIntDef(Buffer, -1);  
  Log(Format('  FoundationIndex: %d', [FoundationIndex]));
  if (FoundationIndex >= 2) then
    SetFoundation(efkMinGW64MSYS2)
  else
    SetFoundation(efkMinGWMSYS);  
end;

procedure SaveFoundationToFile();
var
  Buffer: String;
  
begin
  Log('SaveFoundationToFile');
  Buffer := IntToStr(Ord(Foundation));
  SaveStringToFile(ExpandConstant('{code:GetFoundationFilePath}'), Buffer, False);
  HideFileOrDirectory(ExpandConstant('{code:GetFoundationFilePath}'));
end;

procedure RemoveFoundationFile();
var
  FileName: String;

begin
  FileName := ExpandConstant('{code:GetFoundationFilePath}');
  if FileExists(FileName) then
    DeleteFile(FileName);
end;

procedure RenamePreviousDirectoriesBeforeInstallation();
begin
  Log('RenamePreviousDirectoriesBeforeInstallation');

  if IsFoundationMinGW64() then
    RenameFileOrDirectoryAsBackup(ExpandConstant('{code:GetApplicationRootPath}\msys'));

  RenameFileOrDirectoryAsBackup(ExpandConstant('{code:GetApplicationToolchainBasePath}'));
  RenameFileOrDirectoryAsBackup(ExpandConstant('{code:GetMsysOptBasePath}\mruby'));
end;

function VersionSanitizer(const VersionNumber: String): String;
var
  DevSuffixPosition: Integer;

begin
  Result := VersionNumber;
  StringChangeEx(Result, 'R', '', True);
  // Remove "-dev" and the optional debug suffix after it (e.g., "-dev-alpha1")
  DevSuffixPosition := Pos('-dev', Result);
  if DevSuffixPosition > 0 then
    Result := Copy(Result, 1, DevSuffixPosition - 1);
  Log(Format('VersionSanitizer: Old=%s, New=%s', [VersionNumber, Result]));
end;

procedure VersionBeforeUninstall();
begin
  Log('VersionBeforeUninstall called');
  
  LoadFoundationFromFile();

  RenamePreviousDirectoriesBeforeInstallation();
end;

procedure GlobalInitialization();
begin
  Log('GlobalInitialization called');

  SetWizardDirValueInitialized(False);
  VersionSetDynamicFunctionSanitize(@VersionSanitizer);
  SetDoBeforeUninstall(@VersionBeforeUninstall);
end;

procedure SetupPreferredTerminal();
var
  ConfigurationFilePath: String;

begin
  ConfigurationFilePath := ExpandConstant('{code:GetMsysInstallationPath}\etc\dreamsdk\dreamsdk.conf');  
  SetIniBool('Settings', 'UseMinTTY', IsShellMinTTY, ConfigurationFilePath);  
end;

procedure SetupRepositories();
var
  ConfigurationFilePath: String;

begin
  ConfigurationFilePath := ExpandConstant('{code:GetMsysInstallationPath}\etc\dreamsdk\dreamsdk.conf');
  SaveRepositoriesConfiguration(ConfigurationFilePath);
end;
