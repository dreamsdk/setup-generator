; DreamSDK Inno Setup Script
#define MyAppID "{DF847892-5D85-4FFA-8603-E71750D81602}"
#define MyAppName "DreamSDK"
#define MyAppVersion "R2"
#define MyAppPublisher "The DreamSDK Team"
#define MyAppURL "http://dreamsdk.sizious.com/"
#define MyAppCopyright "© Copyleft 2019"

#define MyAppNameHelp MyAppName + " Help"

#define PackageVersion "2.0.0.0"
#define ProductVersion "2.0.0.0"

#define AppMainName "Shell"
#define AppManagerName "Manager" 

#define FullAppMainName MyAppName + " " + AppMainName
#define FullAppManagerName MyAppName + " " + AppManagerName

#define AppMainDirectory "{app}\msys\1.0\opt\dreamsdk"
#define AppMainExeName AppMainDirectory + "\dreamsdk.exe"
#define AppManagerExeName AppMainDirectory + "\dreamsdk-manager.exe"
#define AppHelpFile AppMainDirectory + "\dreamsdk.chm"
#define AppSupportDirectory "{app}\support"
#define AppSupportIntegrationDirectory AppSupportDirectory + "\ide"

#define OutputBaseFileName MyAppName + '-' + MyAppVersion + '-' + "Setup"
#define SourceDirectory "C:\dcsdk(FAKE)"

#define BuildDateTime GetDateTimeString('yyyy/mm/dd @ hh:nn:ss', '-', ':');

#define IdeCodeBlocksName "Code::Blocks"
#define IdeCodeBlocksVersion "17.12"
#define IdeCodeBlocksVerName IdeCodeBlocksName + " " + IdeCodeBlocksVersion

#define PSVinceLibraryFileName "psvince.dll"
#define PSVinceLibrary AppSupportDirectory + "\" + PSVinceLibraryFileName

#include "inc/utils.iss"
#include "inc/helpers.iss"
#include "inc/environ.iss"
#include "inc/ide.iss"
#include "inc/version.iss"

[Setup]
AppId={{#MyAppID}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={sd}\{#MyAppName}
DefaultGroupName={#MyAppName}
OutputDir=..\bin
OutputBaseFilename={#OutputBaseFileName}
Compression=lzma2/ultra64
;Compression=none
SolidCompression=False
DisableWelcomePage=False
UninstallDisplayIcon={#AppSupportDirectory}uninst.ico
UninstallFilesDir={#AppSupportDirectory}
ChangesEnvironment=True
WizardSmallImageFile=..\rsrc\dreamsdk-48.bmp
WizardImageFile=..\rsrc\banner\banner.bmp
SetupIconFile=..\rsrc\package\setup.ico
AppCopyright={#MyAppCopyright}
UninstallDisplayName={#MyAppName}
VersionInfoVersion={#PackageVersion}
VersionInfoCompany={#MyAppPublisher}
VersionInfoCopyright={#MyAppCopyright}
VersionInfoProductName={#MyAppName}
VersionInfoProductTextVersion={#MyAppVersion}
VersionInfoDescription={#MyAppName} Setup
VersionInfoProductVersion={#ProductVersion}

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"; LicenseFile: "..\rsrc\text\license.rtf"; InfoAfterFile: "..\rsrc\text\after.rtf"

[Tasks]
Name: "envpath"; Description: "{cm:AddToPathEnvironmentVariable}" 
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1

[Files]
Source: "..\rsrc\helpers\{#PSVinceLibraryFileName}"; DestDir: "{#AppSupportDirectory}"; Flags: ignoreversion noencryption nocompression
Source: "..\rsrc\ide\codeblocks.bmp"; Flags: dontcopy noencryption nocompression
Source: "..\rsrc\text\license.rtf"; DestDir: "{#AppSupportDirectory}"; Flags: ignoreversion
Source: "..\rsrc\uninst\uninst.ico"; DestDir: "{#AppSupportDirectory}"; Flags: ignoreversion
Source: "{#SourceDirectory}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#FullAppMainName}"; Filename: "{#AppMainExeName}"; WorkingDir: "{#AppMainDirectory}"; Comment: "{cm:ExecuteMainApplication}"
Name: "{group}\{#FullAppManagerName}"; Filename: "{#AppManagerExeName}"; WorkingDir: "{#AppMainDirectory}"; Comment: "{cm:ExecuteManagerApplication}"
Name: "{group}\{cm:DocumentationGroupDirectory}\{cm:ProgramOnTheWeb,{#MyAppName}}"; Filename: "{#MyAppURL}"
Name: "{group}\{cm:DocumentationGroupDirectory}\{cm:LicenseInformation}"; Filename: "{#AppSupportDirectory}\license.rtf"
Name: "{group}\{cm:DocumentationGroupDirectory}\{cm:ProgramHelp}"; Filename: "{#AppHelpFile}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"; WorkingDir: "{app}"; IconFilename: "{#AppSupportDirectory}\uninst.ico"; Comment: "{cm:UninstallPackage}"
Name: "{commondesktop}\{#FullAppMainName}"; Filename: "{#AppMainExeName}"; WorkingDir: "{#AppMainDirectory}"; Comment: "{cm:ExecuteMainApplication}"; Tasks: desktopicon
Name: "{commonappdata}\Microsoft\Internet Explorer\Quick Launch\{#FullAppMainName}"; Filename: "{#AppMainExeName}"; Comment: "{cm:ExecuteMainApplication}"; Tasks: quicklaunchicon

[Run]
Filename: "{#AppManagerExeName}"; Parameters: "--first-run --directory ""{app}"""; WorkingDir: "{#AppMainDirectory}"; Flags: nowait postinstall skipifsilent; Description: "{cm:LaunchProgram,{#StringChange(FullAppManagerName, '&', '&&')}}"
Filename: "{#AppHelpFile}"; WorkingDir: "{#AppMainDirectory}"; Flags: nowait postinstall skipifsilent unchecked; Description: "{cm:LaunchProgram,{#StringChange(MyAppNameHelp, '&', '&&')}}"
;Filename: "{#AppMainExeName}"; WorkingDir: "{#AppMainDirectory}"; Flags: nowait postinstall skipifsilent unchecked; Description: "{cm:LaunchProgram,{#StringChange(FullAppMainName, '&', '&&')}}"

[CustomMessages]
AddToPathEnvironmentVariable=Add {#MyAppName} to PATH variable
ExecuteMainApplication=Start a new {#FullAppMainName} session
ExecuteManagerApplication=Configure and manage your {#MyAppName} installation
DocumentationGroupDirectory=Documentation
InstallationDirectoryContainSpaces=Sorry, target installation directory cannot contain spaces. Choose a different one.
PrerequisiteMissing=Sorry, but prerequisites are not fully met, some components are missing from your computer: %s%n%nPlease install all of these components, then check they are available on your PATH environment variable and finally restart the installation.
PrerequisiteMissingPython=Python 2.7.x
PrerequisiteMissingGit=Git
PrerequisiteMissingSubversion=Subversion Client (SVN)
UnableToFinalizeSetup=Unable to finalize the {#MyAppName} Setup!%nThe {#FullAppManagerName} application cannot be started.%nPlease notify {#MyAppPublisher} to fix this issue, visit {#MyAppURL} for more information.
UninstallPackage=Remove {#MyAppName} from your computer
InactiveInternetConnection=The {#MyAppName} Setup need to be connected to Internet, as some critical components are downloaded at the installation's end. Please check your Internet connection and click the Retry button or click the Cancel button to exit the installer.
LicenseInformation={#MyAppName} License Information
ProgramHelp={#MyAppNameHelp}
ComponentMainFiles=Program files (Required)
ComponentAdditionalTools=Additional tools
ComponentIDE={#IdeCodeBlocksVerName} integrationCodeBlocksTitlePage={#IdeCodeBlocksVerName} Integration
CodeBlocksSubtitlePage=Where are located the {#IdeCodeBlocksName} files? 
LabelCodeBlocksIntroduction={#IdeCodeBlocksName} must be installed before {#MyAppName} to enable the integration.ButtonBrowse=Browse...
LabelCodeBlocksInstallationDirectory=Select the {#IdeCodeBlocksName} installation directory:
LabelCodeBlocksConfigurationFile=Select the {#IdeCodeBlocksName} configuration file:
FilterCodeBlocksConfigurationFile=Configuration Files (*.conf)|*.conf|All Files (*.*)|*.*
CodeBlocksInstallationDirectoryNotExists=The specified {#IdeCodeBlocksName} installation directory doesn't exists. Please install {#IdeCodeBlocksName} and run it at least once.
CodeBlocksConfigurationFileNotExists=The specified {#IdeCodeBlocksName} configuration file doesn't exists. Please run {#IdeCodeBlocksName} at least once.
CodeBlocksBinaryFileNameNotExists=There is no {#IdeCodeBlocksName} SDK dynamic library (codeblocks.dll) in the specified directory. Are you sure that you have installed {#IdeCodeBlocksName} in that directory? 
CodeBlocksBinaryHashDifferent=The installed {#IdeCodeBlocksName} version seems NOT to be the expected {#IdeCodeBlocksVersion}. There is no guarantee that it will work. Continue anyway?
CodeBlocksIntegrationSetupFailed=Error when patching Code::Blocks!%n%n%s
CodeBlocksRunning={#IdeCodeBlocksName} is running, please close it to continue.
PreviousVersionUninstall={#MyAppName} %s is already installed. This version will be uninstalled. Continue?
PreviousVersionUninstallFailed=Failed to uninstall {#MyAppName} %s (Error 0x%.8x). You should restart your computer and run Setup again. Continue anyway?
VersionAlreadyInstalled={#MyAppName} %s is already installed. If you want to reinstall it, it need to be uninstalled first. Continue anyway?
NewerVersionAlreadyInstalled={#MyAppName} %s is already installed, which is newer that the version provided in this package (%s). Setup will exit now.
PreviousVersionUninstallUnableToGetCommand=Failed to uninstall {#MyAppName} %s. The uninstall command was not retrieved from the registry! Continue anyway?

[Registry]
Root: "HKLM"; Subkey: "System\CurrentControlSet\Control\Session Manager\Environment"; ValueType: string; ValueName: "DREAMSDK_HOME"; ValueData: "{app}"; Flags: preservestringtype uninsdeletevalue

[UninstallDelete]
Type: filesandordirs; Name: "{app}\msys\1.0\opt\toolchains\dc\*"

[InstallDelete]
Type: filesandordirs; Name: "{app}\msys\1.0\opt\toolchains\dc\*"

[Components]
Name: "main"; Description: "{cm:ComponentMainFiles}"; Types: full compact custom; Flags: fixed
Name: "ide"; Description: "{cm:ComponentIDE}"; ExtraDiskSpaceRequired: 52428800; Types: full
;Name: "addons"; Description: "{cm:ComponentAdditionalTools}"; Types: full

[Code]
const
  CODEBLOCKS_EXE_NAME = 'codeblocks.exe';

var
  IsUninstallMode: Boolean;
  IntegratedDevelopmentEnvironmentSettingsPageID: Integer;
  BrowseForFolderExFakePageID: Integer;

function IsModuleLoaded(modulename: AnsiString): Boolean;
external 'IsModuleLoaded@files:{#PSVinceLibraryFileName} stdcall';

function IsModuleLoadedU(modulename: String):  Boolean;
external 'IsModuleLoaded@{#PSVinceLibrary} stdcall uninstallonly';

procedure InitializeWizard;
begin
  BrowseForFolderExFakePageID := CreateBrowseForFolderExFakePage;
  IntegratedDevelopmentEnvironmentSettingsPageID := CreateIntegratedDevelopmentEnvironmentPage;
end;

function IsProcessRunning(const ProcessName: String): Boolean;
begin
  if IsUninstallMode then
    Result := IsModuleLoadedU(ProcessName)
  else
    Result := IsModuleLoaded(ProcessName);
end;

function IsModulesRunning: Boolean;
begin
  Result := False;

  // Check if Code::Blocks is running
  if IsProcessRunning(CODEBLOCKS_EXE_NAME) then
  begin
    MsgBox(CustomMessage('CodeBlocksRunning'), mbError, MB_OK);
    Result := True;
    Exit;    
  end;   
end;

function InitializeSetup: Boolean;
begin
  Result := True;
  IsUninstallMode := False;

  // Check modules running
  if IsModulesRunning then
  begin
    Result := False;
    Exit;
  end;

  // Check prerequisites
  Result := Result and CheckPrerequisites;
  if not Result then
    MsgBox(GeneratePrerequisiteMessage, mbError, MB_OK);

  // Check internet connection
  Result := Result and CheckInternetConnection;
  
  // Check if an old version is installed
  Result := Result and HandlePreviousVersion('{#MyAppID}', '{#MyAppVersion}');
end;

function InitializeUninstall: Boolean;
begin
  Result := True;
  IsUninstallMode := True;

  // Check modules running
  if IsModulesRunning then
  begin
    Result := False;
    Exit;
  end;

  // Unload the DLL, otherwise the dll is not deleted
  UnloadDLL(ExpandConstant('{#PSVinceLibrary}'));
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;
  
  // Avoid spaces in the Installation Path
  if (CurPageID = wpSelectDir) and (Pos(' ', WizardDirValue) > 0) then
  begin
    Result := False;
    MsgBox(CustomMessage('InstallationDirectoryContainSpaces'), mbError, MB_OK);
  end;

  // Checking if the Code::Blocks Integration page is well filled
  if (CurPageID = IntegratedDevelopmentEnvironmentSettingsPageID) then
    if (IsCodeBlocksIntegrationEnabled) and (not IsCodeBlocksIntegrationReady) then
      Result := False;

  // Finalizing the installation.
  if (CurPageID = wpInfoAfter) then
  begin
    // Patch fstab and setup KallistiOS.
    FinalizeSetup;

    // Install Code::Blocks Integration if requested.
    if IsCodeBlocksIntegrationEnabled then
      SetupCodeBlocksIntegration(ExpandConstant('{#AppSupportIntegrationDirectory}'));
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if (CurStep = ssPostInstall) and IsTaskSelected('envpath') then
    EnvAddPath(ExpandConstant('{#AppMainDirectory}'));
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if (CurUninstallStep = usUninstall) then
    UninstallCodeBlocksIntegration(ExpandConstant('{#AppSupportIntegrationDirectory}'));
  if (CurUninstallStep = usPostUninstall) then
    EnvRemovePath(ExpandConstant('{#AppMainDirectory}'));
end;

function ShouldSkipPage(PageID: Integer): Boolean;
begin 
  Result := False;

  // Skip BrowseForFolderExFakePage...
  if (PageID = BrowseForFolderExFakePageID) then
    Result := True;
    
  // Display IDE Page only if needed
  if (PageID = IntegratedDevelopmentEnvironmentSettingsPageID) then
  begin
    Result := not IsCodeBlocksIntegrationEnabled;
    Log(Format('Should Skip Page IDE: %d', [Result]));
  end;
end;

