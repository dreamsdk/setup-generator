; DreamSDK Inno Setup Script

#define MyAppName "DreamSDK"
#define MyAppVersion "R1"
#define MyAppPublisher "The DreamSDK Team"
#define MyAppURL "http://dreamsdk.sizious.com/"
#define MyAppCopyright "© Copyleft 2018"

#define AppMainName "Shell"
#define AppManagerName "Manager" 

#define FullAppMainName MyAppName + " " + AppMainName
#define FullAppManagerName MyAppName + " " + AppManagerName

#define AppMainDirectory "{app}\msys\1.0\opt\dreamsdk\"
#define AppMainExeName AppMainDirectory + "\dreamsdk.exe"
#define AppManagerExeName AppMainDirectory + "\dreamsdk-manager.exe"
#define AppSupportDirectory "{app}\support\"

#define OutputBaseFileName MyAppName + '-' + MyAppVersion + '-' + "Setup"
#define SourceDirectory "C:\dcsdk"

#define BuildDateTime GetDateTimeString('yyyy/mm/dd @ hh:nn:ss', '-', ':');

#include "inc/utils.iss"
#include "inc/helpers.iss"
#include "inc/environ.iss"

[Setup]
AppId={{DF847892-5D85-4FFA-8603-E71750D81602}
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
SolidCompression=True
DisableWelcomePage=False
UninstallDisplayIcon={#AppSupportDirectory}\uninst.ico
UninstallFilesDir={#AppSupportDirectory}
ChangesEnvironment=True
WizardSmallImageFile=..\rsrc\dreamsdk-48.bmp
WizardImageFile=..\rsrc\banner\banner.bmp
SetupIconFile=..\rsrc\package\setup.ico
AppCopyright={#MyAppCopyright}
UninstallDisplayName={#MyAppName}
VersionInfoVersion=1.0.0.0
VersionInfoCompany={#MyAppPublisher}
VersionInfoCopyright={#MyAppCopyright}
VersionInfoProductName={#MyAppName}
VersionInfoProductTextVersion={#MyAppVersion}
VersionInfoDescription={#MyAppName} Setup

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"; LicenseFile: "..\rsrc\text\license.rtf"; InfoAfterFile: "..\rsrc\text\after.rtf"

[Tasks]
Name: "envpath"; Description: "{cm:AddToPathEnvironmentVariable}" 
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1

[Files]
Source: "{#SourceDirectory}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\rsrc\text\license.rtf"; DestDir: "{#AppSupportDirectory}"; Flags: ignoreversion
Source: "..\rsrc\uninst\uninst.ico"; DestDir: "{#AppSupportDirectory}"; Flags: ignoreversion

[Icons]
Name: "{group}\{#FullAppMainName}"; Filename: "{#AppMainExeName}"; WorkingDir: "{#AppMainDirectory}"; Comment: "{cm:ExecuteMainApplication}"
Name: "{group}\{#FullAppManagerName}"; Filename: "{#AppManagerExeName}"; WorkingDir: "{#AppMainDirectory}"; Comment: "{cm:ExecuteManagerApplication}"
Name: "{group}\{cm:DocumentationGroupDirectory}\{cm:ProgramOnTheWeb,{#MyAppName}}"; Filename: "{#MyAppURL}"
Name: "{group}\{cm:DocumentationGroupDirectory}\{cm:LicenseInformation}"; Filename: "{#AppSupportDirectory}\license.rtf"
Name: "{group}\{cm:DocumentationGroupDirectory}\{cm:ProgramHelp}"; Filename: "{#AppMainDirectory}\dreamsdk.chm"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"; WorkingDir: "{app}"; IconFilename: "{#AppSupportDirectory}\uninst.ico"; Comment: "{cm:UninstallPackage}"
Name: "{commondesktop}\{#FullAppMainName}"; Filename: "{#AppMainExeName}"; WorkingDir: "{#AppMainDirectory}"; Comment: "{cm:ExecuteMainApplication}"; Tasks: desktopicon
Name: "{commonappdata}\Microsoft\Internet Explorer\Quick Launch\{#FullAppMainName}"; Filename: "{#AppMainExeName}"; Comment: "{cm:ExecuteMainApplication}"; Tasks: quicklaunchicon

[Run]
Filename: "{#AppManagerExeName}"; WorkingDir: "{#AppMainDirectory}"; Flags: nowait postinstall skipifsilent; Description: "{cm:LaunchProgram,{#StringChange(FullAppManagerName, '&', '&&')}}"
Filename: "{#AppMainExeName}"; WorkingDir: "{#AppMainDirectory}"; Flags: nowait postinstall skipifsilent unchecked; Description: "{cm:LaunchProgram,{#StringChange(FullAppMainName, '&', '&&')}}"

[CustomMessages]
AddToPathEnvironmentVariable=Add {#MyAppName} to PATH variable
ExecuteMainApplication=Start a new {#FullAppMainName} session
ExecuteManagerApplication=Configure and manage your {#MyAppName} installation
DocumentationGroupDirectory=Documentation
InstallationDirectoryContainSpaces=Sorry, target installation directory cannot contain spaces. Choose a different one.
PrerequisiteMissing=Sorry, but prerequisites are not fully met, some components are missing from your computer: %s%nPlease install all of these components, then check they are available on your PATH environment variable and finally restart the installation.
PrerequisiteMissingPython=Python 2.7.x
PrerequisiteMissingGit=Git
PrerequisiteMissingSubversion=Subversion (SVN)
UnableToFinalizeSetup=Unable to finalize the {#MyAppName} setup!%nThe {#FullAppManagerName} application cannot be started.%nPlease notify {#MyAppPublisher} to fix this issue, visit {#MyAppURL} for more information.
UninstallPackage=Remove {#MyAppName} from your computer
InactiveInternetConnection=The {#MyAppName} setup process need to be connected to Internet, as some critical components are downloaded at the installation's end. Please check your Internet connection and click the Retry button or click the Cancel button to exit the installer.
LogCheckingConnection=Checking connection to the server
LogInternetConnectionAvailable=Connected to the server; status: %s %s
LogInternetConnectionNotAvailable=Error connecting to the server: %s
LogInternetConnectionNotAvailableAbortSilent=Connection to the server is not available, aborting silent installation
LogInternetConnectionRetry=Retrying
LogInternetConnectionAbort=Aborting
LogAddPathVariableSuccess=The [%s] added to PATH: [%s]
LogAddPathVariableFailed=Error while adding the [%s] to PATH: [%s]
LogRemovePathVariableSuccess=The [%s] removed from PATH: [%s]
LogRemovePathVariableFailed=Error while removing the [%s] from PATH: [%s]
LicenseInformation={#MyAppName} Licenses Information
ProgramHelp={#MyAppName} Help

[Registry]
Root: "HKLM"; Subkey: "System\CurrentControlSet\Control\Session Manager\Environment"; ValueType: string; ValueName: "DREAMSDK_HOME"; ValueData: "{app}"; Flags: preservestringtype uninsdeletevalue

[Code]
function InitializeSetup: Boolean;
begin
  Result := CheckPrerequisites;
  if not Result then        
    MsgBox(GeneratePrerequisiteMessage, mbError, MB_OK);
  Result := Result and CheckInternetConnection;      
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

  // Patch fstab and setup KallistiOS.
  if (CurPageID = wpInfoAfter) then
    FinalizeSetup;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if (CurStep = ssPostInstall) and IsTaskSelected('envpath') then
    EnvAddPath(ExpandConstant('{#AppMainDirectory}'));
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if (CurUninstallStep = usPostUninstall) then
    EnvRemovePath(ExpandConstant('{#AppMainDirectory}'));
end;
