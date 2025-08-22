// Destination Path [Support]
#define AppSupportDirectoryName "support"

[Code]

//=============================================================================
// PATHS
//=============================================================================

function GetApplicationRootPath(Dummy: String): String;
begin
  Result := sEmptyStr;
  if (not UninstallMode) and (not IsWizardDirValueInitialized) then
    Result := GetRegistryValue('{#MyAppID}', 'Inno Setup: App Path');
  if (Result = sEmptyStr) then
    Result := ExpandConstant('{app}');
end;

function GetMsysInstallationPath(Dummy: String): String;
begin  
  Result := ExpandConstant('{code:GetApplicationRootPath}');
  if IsFoundationMinGW then
    Result := ExpandConstant('{code:GetApplicationRootPath}\msys\1.0');
end;

function GetMsysUserBasePath(Dummy: String): String;
begin  
  Result := ExpandConstant('{code:GetMsysInstallationPath}\usr');
  if IsFoundationMinGW() then
    Result := ExpandConstant('{code:GetMsysInstallationPath}');
end;

function GetMsysOptBasePath(Dummy: String): String;
begin
  Result := ExpandConstant('{code:GetMsysInstallationPath}\opt');
end;

function GetApplicationSupportPath(Dummy: String): String;
begin
  Result := ExpandConstant('{code:GetApplicationRootPath}\{#AppSupportDirectoryName}');
end;

function GetApplicationShortcutsPath(Dummy: String): String;
begin
  Result := ExpandConstant('{code:GetApplicationSupportPath}\shortcuts');
end;

function GetApplicationToolchainBasePath(Dummy: String): String;
begin
  Result := ExpandConstant('{code:GetMsysOptBasePath}\toolchains\dc'); 
end;

function GetApplicationToolchainSuperHPath(Dummy: String): String;
begin
  Result := ExpandConstant('{code:GetApplicationToolchainBasePath}\sh-elf'); 
end;

function GetApplicationMainPath(Dummy: String): String;
begin
  Result := ExpandConstant('{code:GetMsysOptBasePath}\dreamsdk');
end;

function GetApplicationHelpersPath(Dummy: String): String;
begin
  Result := ExpandConstant('{code:GetApplicationMainPath}\helpers');
end;

function GetApplicationAddonsPath(Dummy: String): String;
begin
  Result := ExpandConstant('{code:GetApplicationMainPath}\addons');
end;

function GetApplicationToolsPath(Dummy: String): String;
begin
  Result := ExpandConstant('{code:GetApplicationMainPath}\tools');
end;

function GetApplicationPackagesPath(Dummy: String): String;
begin
  Result := ExpandConstant('{code:GetApplicationMainPath}\packages');
end;

//=============================================================================
// FILENAMES
//=============================================================================

function GetApplicationComponentShellFilePath(Dummy: String): String;
begin
  Result := ExpandConstant('{code:GetApplicationMainPath}\dreamsdk-shell.exe');
end;

function GetApplicationComponentManagerFilePath(Dummy: String): String;
begin
  Result := ExpandConstant('{code:GetApplicationMainPath}\dreamsdk-manager.exe');
end;

function GetApplicationComponentHelpFilePath(Dummy: String): String;
begin
  Result := ExpandConstant('{code:GetApplicationMainPath}\dreamsdk.chm');
end;

function GetApplicationComponentGettingStartedFilePath(Dummy: String): String;
begin
  Result := ExpandConstant('{code:GetApplicationMainPath}\docs\getstart.html');
end;

function GetFoundationFilePath(Dummy: String): String;
begin
  Result := ExpandConstant('{code:GetApplicationSupportPath}\instfndn.dat');
end;

//=============================================================================
// DEBUG
//=============================================================================

#if InstallerMode == DEBUG

// Display all targets paths in the log
procedure LogCalculatedTargets;
var
  Dummy: String;

begin
  Dummy := sEmptyStr;

  Log('--- Calculated Target Directory Paths ---');  
  Log(Format('GetApplicationRootPath: "%s"', [GetApplicationRootPath(Dummy)]));

  Log(Format('GetMsysOptBasePath: "%s"', [GetMsysOptBasePath(Dummy)]));
  Log(Format('GetMsysUserBasePath: "%s"', [GetMsysUserBasePath(Dummy)]));

  Log(Format('GetApplicationSupportPath: "%s"', [GetApplicationSupportPath(Dummy)]));
  Log(Format('GetApplicationShortcutsPath: "%s"', [GetApplicationShortcutsPath(Dummy)]));  
  Log(Format('GetApplicationToolchainBasePath: "%s"', [GetApplicationToolchainBasePath(Dummy)]));
  Log(Format('GetApplicationToolchainSuperHPath: "%s"', [GetApplicationToolchainSuperHPath(Dummy)]));
  Log(Format('GetApplicationMainPath: "%s"', [GetApplicationMainPath(Dummy)]));
  Log(Format('GetApplicationHelpersPath: "%s"', [GetApplicationHelpersPath(Dummy)]));
  Log(Format('GetApplicationAddonsPath: "%s"', [GetApplicationAddonsPath(Dummy)]));
  Log(Format('GetApplicationToolsPath: "%s"', [GetApplicationToolsPath(Dummy)]));
  Log(Format('GetApplicationPackagesPath: "%s"', [GetApplicationPackagesPath(Dummy)]));

  Log('--- Calculated Target File Paths ---');
  Log(Format('GetApplicationComponentShellFilePath: "%s"', [GetApplicationComponentShellFilePath(Dummy)]));
  Log(Format('GetApplicationComponentManagerFilePath: "%s"', [GetApplicationComponentManagerFilePath(Dummy)]));
  Log(Format('GetApplicationComponentHelpFilePath: "%s"', [GetApplicationComponentHelpFilePath(Dummy)]));
  Log(Format('GetApplicationComponentGettingStartedFilePath: "%s"', [GetApplicationComponentGettingStartedFilePath(Dummy)]));
  Log(Format('GetFoundationFilePath: "%s"', [GetFoundationFilePath(Dummy)]));
end;

#endif
