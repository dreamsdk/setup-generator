// Destination Path [Support]
#define AppSupportDirectoryName "support"

// Destination Paths [MinGW]
// #define AppOptBase "opt"
// #define AppToolchainBase AppOptBase + "\toolchains\dc"
// #define AppToolchainSuperHDirectory AppToolchainBase + "\sh-elf"

// Destination Paths [AppMainDirectory; Dependency: AppOptBase]
// #define AppMainDirectory AppOptBase + "\dreamsdk"
// #define AppHelpersDirectory AppMainDirectory + "\helpers"
// #define AppAddonsDirectory AppMainDirectory + "\addons"
// #define AppToolsDirectory AppMainDirectory + "\tools"
// #define AppPackagesDirectory AppMainDirectory + "\packages"

// #define AppMainExeName AppMainDirectory + "\dreamsdk-shell.exe"
// #define AppManagerExeName AppMainDirectory + "\dreamsdk-manager.exe"
// #define AppHelpFile AppMainDirectory + "\dreamsdk.chm"
// #define AppGettingStartedFile AppMainDirectory + "\getstart.rtf"

[Code]

//=============================================================================
// PATHS
//=============================================================================

function GetMsysInstallationPath(Dummy: String): String;
begin
  Result := ExpandConstant('{app}');
  if IsFoundationMinGW then
    Result := ExpandConstant('{app}\msys\1.0\');
end;

function GetApplicationSupportPath(Dummy: String): String;
begin
  Result := ExpandConstant('{app}\{#AppSupportDirectoryName}');
end;

function GetApplicationShortcutsPath(Dummy: String): String;
begin
  Result := ExpandConstant('{code:GetApplicationSupportPath}\shortcuts');
end;

function GetApplicationOptBasePath(Dummy: String): String;
begin
  Result := ExpandConstant('{code:GetMsysInstallationPath}\opt');
end;

function GetApplicationToolchainBasePath(Dummy: String): String;
begin
  Result := ExpandConstant('{code:GetApplicationOptBasePath}\toolchains\dc'); 
end;

function GetApplicationToolchainSuperHPath(Dummy: String): String;
begin
  Result := ExpandConstant('{code:GetApplicationToolchainBasePath}\sh-elf'); 
end;

function GetApplicationMainPath(Dummy: String): String;
begin
  Result := ExpandConstant('{code:GetApplicationOptBasePath}\dreamsdk');
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
  Result := ExpandConstant('{code:GetApplicationMainPath}\getstart.rtf');
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
  Log(Format('GetApplicationSupportPath: "%s"', [GetApplicationSupportPath(Dummy)]));
  Log(Format('GetApplicationShortcutsPath: "%s"', [GetApplicationShortcutsPath(Dummy)]));
  Log(Format('GetApplicationOptBasePath: "%s"', [GetApplicationOptBasePath(Dummy)]));
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
