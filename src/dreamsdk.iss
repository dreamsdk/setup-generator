; DreamSDK Inno Setup Script

; Installer versions#define MyAppVersion "R3-dev"
#define PackageVersion "3.0.0.2001"
#define ProductVersion "3.0.0.2001"

; Code::Blocks version
#define IdeCodeBlocksVersion "17.12"
; Copyright
#define MyAppCopyright "© Copyleft 2018-2020"

; Source directories
#define SourceDirectoryBase "D:\sources_dev"

#define SourceDirectoryMinGW SourceDirectoryBase + "\mingw-base"  
#define SourceDirectoryAddons SourceDirectoryBase + "\addons"
#define SourceDirectoryToolchainArm SourceDirectoryBase + "\gcc-arm-eabi"
#define SourceDirectoryToolchainSh SourceDirectoryBase + "\gcc-sh-elf"

#define SourceDirectoryGdb SourceDirectoryBase + "\gdb-sh-elf"
#define SourceDirectoryGdbPython27 SourceDirectoryBase + "\gdb-sh-elf-python-2.7"
#define SourceDirectoryGdbPython34 SourceDirectoryBase + "\gdb-sh-elf-python-3.4"
#define SourceDirectoryGdbPython35 SourceDirectoryBase + "\gdb-sh-elf-python-3.5"
#define SourceDirectoryGdbPython36 SourceDirectoryBase + "\gdb-sh-elf-python-3.6"
#define SourceDirectoryGdbPython37 SourceDirectoryBase + "\gdb-sh-elf-python-3.7"
#define SourceDirectoryGdbPython38 SourceDirectoryBase + "\gdb-sh-elf-python-3.8"

; Don't modify anything beyond this point

#define MyAppID "{DF847892-5D85-4FFA-8603-E71750D81602}"
#define MyAppName "DreamSDK"
#define MyAppPublisher "The DreamSDK Team"
#define MyAppURL "https://www.dreamsdk.org/"

#define TestConnectionURL "http://www.dreamcast.fr/"

#define MyAppNameHelp MyAppName + " Help"
#define AppMainName "Shell"
#define AppManagerName "Manager" 

#define FullAppMainName MyAppName + " " + AppMainName
#define FullAppManagerName MyAppName + " " + AppManagerName

#define AppToolchainBase "{app}\msys\1.0\opt\toolchains\dc"
#define AppMainDirectory "{app}\msys\1.0\opt\dreamsdk"
#define AppMainExeName AppMainDirectory + "\dreamsdk.exe"
#define AppManagerExeName AppMainDirectory + "\dreamsdk-manager.exe"
#define AppHelpFile AppMainDirectory + "\dreamsdk.chm"
#define AppSupportDirectory "{app}\support"
#define AppSupportIntegrationDirectory AppSupportDirectory + "\ide"
#define AppAddonsDirectory AppMainDirectory + "\addons\"

#define OutputBaseFileName MyAppName + '-' + MyAppVersion + '-' + "Setup"

#define BuildDateTime GetDateTimeString('yyyy/mm/dd @ hh:nn:ss', '-', ':');

#define IdeCodeBlocksName "Code::Blocks"
#define IdeCodeBlocksVerName IdeCodeBlocksName + " " + IdeCodeBlocksVersion

#define PSVinceLibraryFileName "psvince.dll"
#define PSVinceLibrary AppSupportDirectory + "\" + PSVinceLibraryFileName

#include "inc/utils.iss"
#include "inc/helpers.iss"
#include "inc/environ.iss"
#include "inc/ide.iss"
#include "inc/version.iss"
#include "inc/gdb.iss"

[Setup]
AppId={{#MyAppID}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}#help
AppSupportURL={#MyAppURL}help/
AppUpdatesURL={#MyAppURL}
DefaultDirName={sd}\{#MyAppName}
DefaultGroupName={#MyAppName}
OutputDir=..\bin
OutputBaseFilename={#OutputBaseFileName}
;Compression=lzma2/ultra64
Compression=none
SolidCompression=False
DisableWelcomePage=False
UninstallDisplayIcon={#AppSupportDirectory}\uninst.ico
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
AppComments={#BuildDateTime}
AppReadmeFile={#AppSupportDirectory}\license.rtf

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"; LicenseFile: "..\rsrc\text\license.rtf"; InfoAfterFile: "..\rsrc\text\after.rtf"

[Tasks]
Name: "envpath"; Description: "{cm:AddToPathEnvironmentVariable}" 
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1

[Components]
Name: "main"; Description: "{cm:ComponentMain}"; Types: full compact custom; Flags: fixed
Name: "kos"; Description: "{cm:ComponentKOS}"; ExtraDiskSpaceRequired: 209715200; Types: full compact custom; Flags: fixed
Name: "ide"; Description: "{cm:ComponentIDE}"; Types: full
Name: "ide\codeblocks"; Description: "{cm:ComponentIDE_CodeBlocks}"; ExtraDiskSpaceRequired: 52428800; Types: full 
Name: "addons"; Description: "{cm:ComponentAdditionalTools}"; Types: full
Name: "addons\elevate"; Description: "{cm:ComponentAdditionalTools_elevate}"; ExtraDiskSpaceRequired: 7539; Types: full
Name: "addons\img4dc"; Description: "{cm:ComponentAdditionalTools_img4dc}"; Types: full
Name: "addons\img4dc\cdi4dc"; Description: "{cm:ComponentAdditionalTools_img4dc_cdi4dc}"; ExtraDiskSpaceRequired: 45056; Types: full
Name: "addons\img4dc\mds4dc"; Description: "{cm:ComponentAdditionalTools_img4dc_mds4dc}"; ExtraDiskSpaceRequired: 57344; Types: full
Name: "addons\ipcreate"; Description: "{cm:ComponentAdditionalTools_ipcreate}"; ExtraDiskSpaceRequired: 675840; Types: full
Name: "addons\ipcreate\iplogos"; Description: "{cm:ComponentAdditionalTools_ipcreate_iplogos}"; ExtraDiskSpaceRequired: 53240; Types: full
Name: "addons\mkisofs"; Description: "{cm:ComponentAdditionalTools_mkisofs}"; ExtraDiskSpaceRequired: 131072; Types: full
Name: "addons\pvr2png"; Description: "{cm:ComponentAdditionalTools_pvr2png}"; ExtraDiskSpaceRequired: 143360; Types: full
Name: "addons\txfutils"; Description: "{cm:ComponentAdditionalTools_txfutils}"; ExtraDiskSpaceRequired: 811008; Types: full
Name: "addons\txfutils\txflib"; Description: "{cm:ComponentAdditionalTools_txfutils_txflib}"; ExtraDiskSpaceRequired: 2334720; Types: full
Name: "addons\vmutool"; Description: "{cm:ComponentAdditionalTools_vmutool}"; ExtraDiskSpaceRequired: 45056; Types: full

[Files]
; Temporary files used for the installation
Source: "..\rsrc\helpers\{#PSVinceLibraryFileName}"; DestDir: "{#AppSupportDirectory}"; Flags: ignoreversion noencryption nocompression
Source: "..\rsrc\helpers\whereis.bat"; Flags: dontcopy noencryption nocompression
Source: "..\rsrc\helpers\pecheck.exe"; Flags: dontcopy noencryption nocompression
Source: "..\rsrc\ide\codeblocks.bmp"; Flags: dontcopy noencryption nocompression
Source: "..\rsrc\gdb\python.bmp"; Flags: dontcopy noencryption nocompression

; Some additional resources
Source: "..\rsrc\text\license.rtf"; DestDir: "{#AppSupportDirectory}"; Flags: ignoreversion
Source: "..\rsrc\uninst\uninst.ico"; DestDir: "{#AppSupportDirectory}"; Flags: ignoreversion

; MinGW Base
Source: "{#SourceDirectoryMinGW}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; Toolchains
Source: "{#SourceDirectoryToolchainArm}\*"; DestDir: "{#AppToolchainBase}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#SourceDirectoryToolchainSh}\*"; DestDir: "{#AppToolchainBase}"; Flags: ignoreversion recursesubdirs createallsubdirs

; GDB
Source: "{#SourceDirectoryGdb}\*"; DestDir: "{#AppToolchainBase}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsGdbPythonNone
Source: "{#SourceDirectoryGdbPython27}\*"; DestDir: "{#AppToolchainBase}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsGdbPython27
Source: "{#SourceDirectoryGdbPython34}\*"; DestDir: "{#AppToolchainBase}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsGdbPython34
Source: "{#SourceDirectoryGdbPython35}\*"; DestDir: "{#AppToolchainBase}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsGdbPython35
Source: "{#SourceDirectoryGdbPython36}\*"; DestDir: "{#AppToolchainBase}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsGdbPython36
Source: "{#SourceDirectoryGdbPython37}\*"; DestDir: "{#AppToolchainBase}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsGdbPython37
Source: "{#SourceDirectoryGdbPython38}\*"; DestDir: "{#AppToolchainBase}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsGdbPython38

; Addons
Source: "{#SourceDirectoryAddons}\elevate\*"; DestDir: "{#AppAddonsDirectory}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: addons\elevate
Source: "{#SourceDirectoryAddons}\img4dc\cdi4dc\*"; DestDir: "{#AppAddonsDirectory}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: addons\img4dc\cdi4dc
Source: "{#SourceDirectoryAddons}\img4dc\mds4dc\*"; DestDir: "{#AppAddonsDirectory}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: addons\img4dc\mds4dc
Source: "{#SourceDirectoryAddons}\ipcreate\*"; DestDir: "{#AppAddonsDirectory}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: addons\ipcreate
Source: "{#SourceDirectoryAddons}\mkisofs\*"; DestDir: "{#AppAddonsDirectory}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: addons\mkisofs
Source: "{#SourceDirectoryAddons}\pvr2png\*"; DestDir: "{#AppAddonsDirectory}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: addons\pvr2png
Source: "{#SourceDirectoryAddons}\txfutils\*"; DestDir: "{#AppAddonsDirectory}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: addons\txfutils
Source: "{#SourceDirectoryAddons}\vmutool\*"; DestDir: "{#AppAddonsDirectory}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: addons\vmutool

[Icons]
Name: "{group}\{#FullAppMainName}"; Filename: "{#AppMainExeName}"; WorkingDir: "{#AppMainDirectory}"; Comment: "{cm:ExecuteMainApplication}"
Name: "{group}\{#FullAppManagerName}"; Filename: "{#AppManagerExeName}"; WorkingDir: "{#AppMainDirectory}"; Comment: "{cm:ExecuteManagerApplication}"
Name: "{group}\{cm:DocumentationGroupDirectory}\{cm:ProgramOnTheWeb,{#MyAppName}}"; Filename: "{#MyAppURL}"
Name: "{group}\{cm:DocumentationGroupDirectory}\{cm:LicenseInformation}"; Filename: "{#AppSupportDirectory}\license.rtf"
Name: "{group}\{cm:DocumentationGroupDirectory}\{cm:ProgramHelp}"; Filename: "{#AppHelpFile}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"; WorkingDir: "{app}"; IconFilename: "{#AppSupportDirectory}\uninst.ico"; Comment: "{cm:UninstallPackage}"
Name: "{commondesktop}\{#FullAppMainName}"; Filename: "{#AppMainExeName}"; WorkingDir: "{#AppMainDirectory}"; Comment: "{cm:ExecuteMainApplication}"; Tasks: desktopicon
Name: "{commonappdata}\Microsoft\Internet Explorer\Quick Launch\{#FullAppMainName}"; Filename: "{#AppMainExeName}"; Comment: "{cm:ExecuteMainApplication}"; Tasks: quicklaunchicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#FullAppMainName}"; Filename: "{#AppMainExeName}"; Comment: "{cm:ExecuteMainApplication}"; Tasks: quicklaunchicon

[Run]
Filename: "{#AppManagerExeName}"; Parameters: "--first-run --directory ""{app}"""; WorkingDir: "{#AppMainDirectory}"; Flags: nowait postinstall skipifsilent; Description: "{cm:LaunchProgram,{#StringChange(FullAppManagerName, '&', '&&')}}"
Filename: "{#AppHelpFile}"; WorkingDir: "{#AppMainDirectory}"; Flags: nowait postinstall skipifsilent unchecked shellexec; Description: "{cm:LaunchProgram,{#StringChange(MyAppNameHelp, '&', '&&')}}"
;Filename: "{#AppMainExeName}"; WorkingDir: "{#AppMainDirectory}"; Flags: nowait postinstall skipifsilent unchecked; Description: "{cm:LaunchProgram,{#StringChange(FullAppMainName, '&', '&&')}}"

[CustomMessages]
AddToPathEnvironmentVariable=Add {#MyAppName} to PATH variable
ExecuteMainApplication=Start a new {#FullAppMainName} session
ExecuteManagerApplication=Configure and manage your {#MyAppName} installation
DocumentationGroupDirectory=Documentation
InstallationDirectoryContainSpaces=Sorry, target installation directory cannot contain spaces. Choose a different one.
PrerequisiteMissing=Sorry, but prerequisites are not fully met, some components are missing from your computer: %s%n%nPlease install all of these components, then check they are available on your PATH environment variable and finally restart the installation.
PrerequisiteOptionalMissing=You are missing some optional prerequisites: %s%n%nFor better experience, it would be nice to have them installed, even if it isn't mandatory. Continue anyway?
PrerequisiteMissingPython=Python
PrerequisiteMissingGit=Git
PrerequisiteMissingSubversion=Subversion Client (SVN)
UnableToFinalizeSetup=Unable to finalize the {#MyAppName} Setup!%nThe {#FullAppManagerName} application cannot be started.%nPlease notify {#MyAppPublisher} to fix this issue, visit {#MyAppURL} for more information.
UninstallPackage=Remove {#MyAppName} from your computer
InactiveInternetConnection=The {#MyAppName} Setup need to be connected to Internet, as some critical components are downloaded at the installation's end. Please check your Internet connection and click the Retry button or click the Cancel button to exit the installer.
LicenseInformation={#MyAppName} License Information
ProgramHelp={#MyAppNameHelp}
ComponentMain=Program files (required)
ComponentKOS=KallistiOS, KallistiOS Ports and Dreamcast Tool (required)
ComponentIDE=Integrated Development Environment (IDE)
ComponentIDE_CodeBlocks={#IdeCodeBlocksVerName}
ComponentAdditionalTools=Additional command line tools
ComponentAdditionalTools_elevate=Elevate – Command-Line UAC Elevation Utility (elevate)
ComponentAdditionalTools_img4dc=IMG4DC – Dreamcast Selfboot Toolkit
ComponentAdditionalTools_img4dc_cdi4dc=CDI4DC – Padus DiscJuggler image generator (cdi4dc)
ComponentAdditionalTools_img4dc_mds4dc=MDS4DC – Alcohol 120% image generator (mds4dc, lbacalc)
ComponentAdditionalTools_ipcreate=IP.BIN Creator – Initial Program generator (ipcreate)
ComponentAdditionalTools_ipcreate_iplogos=Additional ready-to-use IP logos
ComponentAdditionalTools_mkisofs=Make ISO File System – ISO9660 image generator (mkisofs)
ComponentAdditionalTools_pvr2png=PVR to PNG – PowerVR image to PNG converter (pvr2png)
ComponentAdditionalTools_txfutils=TXF Utilities – Textured font format tools (showtxf, ttf2txf)
ComponentAdditionalTools_txfutils_txflib=Additional ready-to-use TXF fonts files
ComponentAdditionalTools_vmutool=VMU Tool PC – Visual Memory data handler (vmutool)
CodeBlocksTitlePage={#IdeCodeBlocksVerName} Integration
CodeBlocksSubtitlePage=Where are located the {#IdeCodeBlocksName} files?
LabelCodeBlocksIntroduction={#IdeCodeBlocksName} must be installed before {#MyAppName} to enable the integration.
ButtonBrowse=Browse...
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
LabelGdbIntroduction=Do you want to enable Python extensions of GDB for SuperH?
GdbTitlePage=GNU Debugger Configuration
GdbSubtitlePage=Customize your GNU Debugger for SuperH installation.
LabelGdbDescription=Only Python 32-bits is supported. If Python options are disabled, please install a 32-bits Python runtime (it can be installed with Python 64-bits) then run Setup again.

[Registry]
Root: "HKLM"; Subkey: "System\CurrentControlSet\Control\Session Manager\Environment"; ValueType: string; ValueName: "DREAMSDK_HOME"; ValueData: "{app}"; Flags: preservestringtype uninsdeletevalue

[UninstallDelete]
Type: filesandordirs; Name: "{app}\msys\1.0\opt\toolchains\dc\*"

[InstallDelete]
Type: filesandordirs; Name: "{app}\msys\1.0\opt\toolchains\dc\*"

[Code]
const
  CODEBLOCKS_EXE_NAME = 'codeblocks.exe';

var
  IsUninstallMode: Boolean;
  IntegratedDevelopmentEnvironmentSettingsPageID: Integer;
  BrowseForFolderExFakePageID: Integer;
  GdbPageID: Integer;

function IsModuleLoaded(modulename: AnsiString): Boolean;
external 'IsModuleLoaded@files:{#PSVinceLibraryFileName} stdcall';

function IsModuleLoadedU(modulename: String):  Boolean;
external 'IsModuleLoaded@{#PSVinceLibrary} stdcall uninstallonly';

procedure InitializeWizard;
begin
  BrowseForFolderExFakePageID := CreateBrowseForFolderExFakePage;
  IntegratedDevelopmentEnvironmentSettingsPageID := CreateIntegratedDevelopmentEnvironmentPage;
  GdbPageID := CreateGdbPage;
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

  // Check optional prerequisites
  if Result and (not CheckOptionalPrerequisites) then
  begin
    Result := Result 
      and (MsgBox(GenerateOptionalPrerequisiteMessage, mbConfirmation, MB_YESNO) = IDYES);
  end;
  
  // This test should be the latest!
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

