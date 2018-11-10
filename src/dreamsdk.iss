; DreamSDK Inno Setup Script

#define MyAppName "DreamSDK"
#define MyAppVersion "R1"
#define MyAppPublisher "The DreamSDK Team"
#define MyAppURL "http://dreamsdk.sizious.com/"

#define AppMainName "Shell"
#define AppManagerName "Manager" 

#define FullAppMainName MyAppName + " " + AppMainName
#define FullAppManagerName MyAppName + " " + AppManagerName

#define AppMainDirectory "{app}\msys\1.0\opt\dreamsdk\"
#define AppMainExeName AppMainDirectory + "\dreamsdk.exe"
#define AppManagerExeName AppMainDirectory + "\dreamsdk-manager.exe"

#define OutputBaseFileName MyAppName + '-' + MyAppVersion + '-' + "Setup"
#define SourceDirectory "C:\dcsdk\"

#include "utils.iss"
#include "helpers.iss"
#include "environ.iss"

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
Compression=none
SolidCompression=True
DisableWelcomePage=False
UninstallDisplayIcon={app}\dreamsdk.exe
UninstallFilesDir={app}\uninst
ChangesEnvironment=True

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "envpath"; Description: "{cm:AddToPathEnvironmentVariable}" 
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1

[Files]
Source: "{#SourceDirectory}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{#AppMainExeName}"; WorkingDir: "{#AppMainDirectory}"; Comment: "{cm:ExecuteMainApplication}"
Name: "{group}\{#AppManagerName}"; Filename: "{#AppManagerExeName}"; WorkingDir: "{#AppMainDirectory}"; Comment: "{cm:ExecuteManagerApplication}"
Name: "{group}\{cm:DocumentationGroupDirectory}\{cm:ProgramOnTheWeb,{#MyAppName}}"; Filename: "{#MyAppURL}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"; WorkingDir: "{app}"; Comment: "{cm:UninstallPackage}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{#AppMainExeName}"; WorkingDir: "{#AppMainDirectory}"; Comment: "{cm:ExecuteMainApplication}"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{#AppMainExeName}"; Comment: "{cm:ExecuteMainApplication}"; Tasks: quicklaunchicon

[Run]
Filename: "{#AppMainExeName}"; WorkingDir: "{#AppMainDirectory}"; Flags: nowait postinstall skipifsilent; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"

[CustomMessages]
AddToPathEnvironmentVariable=Add {#MyAppName} to PATH variable (recommended)
ExecuteMainApplication=Start a new {#FullAppMainName} session.
ExecuteManagerApplication=Configure and manage your {#MyAppName} installation.
DocumentationGroupDirectory=Documentation
InstallationDirectoryContainSpaces=Sorry, target installation directory cannot contain spaces. Choose a different one.
PrerequisiteMissing=Sorry, but prerequisites are not fully met, some components are missing from your computer: %s%nPlease install all of these components, then check they are available on your PATH environment variable and finally restart the installation.
PrerequisiteMissingPython=Python 2.7.x
PrerequisiteMissingGit=Git
PrerequisiteMissingSubversion=Subversion (SVN)
UnableToFinalizeSetup=Unable to finalize the {#MyAppName} setup!%nThe {#FullAppManagerName} application cannot be started.%nPlease notify {#MyAppPublisher} to fix this issue, visit {#MyAppURL} for more information.
UninstallPackage=Remove {#MyAppName} from your computer.

[Code]
function InitializeSetup: Boolean;
begin
  Result := CheckPrerequisites;
  if not Result then        
    MsgBox(GeneratePrerequisiteMessage, mbError, MB_OK);
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
  if (CurPageID = wpFinished) then
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
