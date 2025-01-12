; =============================================================================
; DreamSDK Setup - Inno Setup Script
; =============================================================================

#include "inc/const.iss"
#include "config.iss"

#define MyAppName "DreamSDK"

#if InstallerMode == DEBUG && SourceMode == DEBUG && DebugUninstallHandlingMode == UNINSTALL_IGNORED
; This fake GUID is used for testing the DreamSDK Setup package
#define MyAppID "{DF847892-5D85-4FFA-8603-E717DEADBEEF}"
#define MyAppName MyAppName + "-DEBUG"
#else
; Real production GUID
#define MyAppID "{DF847892-5D85-4FFA-8603-E71750D81602}"
#endif
#define MyAppPublisher "The " + MyAppName + " Team"
#define MyAppURL "https://www.dreamsdk.org/"

; Copyright
#define CurrentYear GetDateTimeString('yyyy', '', '')
#define MyAppCopyright "© Copyleft 2018-" + CurrentYear

; Version
#define VersionNumberRevision GetDateTimeString('yymm', '', '')

#define AppVersion "R" + VersionNumberMajor
#define FullVersionNumber VersionNumberMajor + "." + VersionNumberMinor + "." + VersionNumberBuild + "." + VersionNumberRevision

#define PackageVersion FullVersionNumber
#define ProductVersion FullVersionNumber

#if InstallerMode == DEBUG
#define MyAppVersion AppVersion + "-dev"
#else
#define MyAppVersion AppVersion
#endif

; Application names
#define MyAppNameHelp MyAppName + " Help"
#define AppMainName "Shell"
#define AppManagerName "Manager" 

#define FullAppMainName MyAppName + " " + AppMainName
#define FullAppManagerName MyAppName + " " + AppManagerName

#define OutputBaseFileName "setup"

#define BuildDateTime GetDateTimeString('yyyy/mm/dd @ hh:nn:ss', '-', ':');

#define IdeCodeBlocksName "Code::Blocks"
#define IdeCodeBlocksSupportedVersions "17.12 or 20.03"

#define IdeComponentsListName "ide"

#define WindowsTerminalName "Windows Terminal"

// ============================================================================
// INCLUDES
// ============================================================================

#include "inc/utils/utils.iss"
#include "inc/utils/winver.iss"
#include "inc/utils/components.iss"
#include "inc/utils/ui.iss"
#include "inc/utils/environ.iss"
#include "inc/utils/version.iss"

#include "inc/global.iss"

#include "inc/paths/sources.iss"
#include "inc/paths/targets.iss"

#include "inc/helpers/git.iss"
#include "inc/helpers/junction.iss"
#include "inc/helpers/inet.iss"
#include "inc/helpers/preq.iss"
#include "inc/helpers/psvince.iss"
#include "inc/helpers/renbckp.iss"
#include "inc/helpers/wt.iss"

#include "inc/pages/foundation.iss"
#include "inc/pages/kos.iss"
#include "inc/pages/ruby.iss"
#include "inc/pages/ide.iss"
#include "inc/pages/gdb.iss"
#include "inc/pages/toolchains.iss"

#include "inc/helpers.iss"
#include "inc/main.iss"

// ============================================================================
// MAIN
// ============================================================================

[Setup]
AppId={{#MyAppID}
AppName={#MyAppName}
AppVersion={#PackageVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}#help
AppSupportURL={#MyAppURL}help/
AppUpdatesURL={#MyAppURL}
DefaultDirName={sd}\{#MyAppName}                                       
DefaultGroupName={#MyAppName}
OutputDir=..\bin
OutputBaseFilename={#OutputBaseFileName}
SolidCompression=False
DisableWelcomePage=False
UninstallDisplayIcon={code:GetApplicationSupportPath}\uninst.ico
UninstallFilesDir={code:GetApplicationSupportPath}
ChangesEnvironment=True
WizardSmallImageFile=..\rsrc\dreamsdk-48.bmp
WizardImageFile=..\rsrc\banner\banner.bmp
SetupIconFile=..\rsrc\package\setup.ico
AppCopyright={#MyAppCopyright}
UninstallDisplayName={#MyAppName} {#MyAppVersion}
VersionInfoVersion={#PackageVersion}
VersionInfoCompany={#MyAppPublisher}
VersionInfoCopyright={#MyAppCopyright}
VersionInfoProductName={#MyAppName}
VersionInfoProductTextVersion={#MyAppVersion}
#if InstallerMode == RELEASE
VersionInfoDescription={#MyAppName} Setup
#else
VersionInfoDescription={#MyAppName} Setup (DEBUG)
#endif
VersionInfoProductVersion={#ProductVersion}
AppComments={#BuildDateTime}
AppReadmeFile={code:GetApplicationSupportPath}\license.rtf
AllowUNCPath=False

; Enable Disk Spanning
DiskSpanning=True
SlicesPerDisk=1
DiskSliceSize=134217728

#if CompressionMode == COMPRESSION_ENABLED
; Release mode
Compression=lzma2/ultra64
#else
; Debug mode
Compression=none
#endif

#if DigitalSignatureMode == SIGNATURE_ENABLED
; Digital Signature
SignTool=SignTool $f
SignedUninstaller=yes
#endif

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"; LicenseFile: "..\rsrc\text\license.rtf"; InfoBeforeFile: "..\rsrc\text\before.rtf"; InfoAfterFile: "..\rsrc\text\after.rtf"

[Tasks]
Name: "envpath"; Description: "{cm:AddToPathEnvironmentVariable}"
Name: "wtconfig"; Description: "{cm:IntegrateWithWindowsTerminal}"; Check: IsWindowsTerminalInstalled 
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1

[Types]
Name: "fullwithoutide"; Description: "{cm:TypeFullInstallationWithoutIDE}"
Name: "full"; Description: "{cm:TypeFullInstallation}"
Name: "compact"; Description: "{cm:TypeCompactInstallation}"
Name: "custom"; Description: "{cm:TypeCustomInstallation}"; Flags: iscustom

[Components]
; Main
Name: "main"; Description: "{cm:ComponentMain}"; Types: full compact custom fullwithoutide; Flags: fixed
Name: "main\base"; Description: "{cm:ComponentBase}"; Types: full compact custom fullwithoutide; Flags: fixed
Name: "main\toolchains"; Description: "{cm:ComponentToolchains}"; Types: full compact custom fullwithoutide; Flags: fixed
Name: "main\kos"; Description: "{cm:ComponentKOS}"; Types: full compact custom fullwithoutide; Flags: fixed

; IDE
Name: "{#IdeComponentsListName}"; Description: "{cm:ComponentIDE}"; Types: full
Name: "{#IdeComponentsListName}\codeblocks"; Description: "{cm:ComponentIDE_CodeBlocks}"; ExtraDiskSpaceRequired: 52428800; Types: full

; Addons
Name: "addons"; Description: "{cm:ComponentAdditionalTools}"; Types: full fullwithoutide
Name: "addons\elevate"; Description: "{cm:ComponentAdditionalTools_elevate}"; Types: full fullwithoutide
Name: "addons\pvr2png"; Description: "{cm:ComponentAdditionalTools_pvr2png}"; Types: full fullwithoutide
Name: "addons\txfutils"; Description: "{cm:ComponentAdditionalTools_txfutils}"; Types: full fullwithoutide
Name: "addons\txfutils\txflib"; Description: "{cm:ComponentAdditionalTools_txfutils_txflib}"; Types: full fullwithoutide
Name: "addons\vmutool"; Description: "{cm:ComponentAdditionalTools_vmutool}"; Types: full fullwithoutide

; Tools
Name: "tools"; Description: "{cm:ComponentUtilities}"; Types: full fullwithoutide
Name: "tools\checker"; Description: "{cm:ComponentUtilities_checker}"; Types: full fullwithoutide
Name: "tools\bdreams"; Description: "{cm:ComponentUtilities_bdreams}"; Types: full fullwithoutide
Name: "tools\ipwriter"; Description: "{cm:ComponentUtilities_ipwriter}"; Types: full fullwithoutide
Name: "tools\ipwriter\iplogos"; Description: "{cm:ComponentUtilities_ipwriter_iplogos}"; Types: full fullwithoutide
Name: "tools\mrwriter"; Description: "{cm:ComponentUtilities_mrwriter}"; Types: full fullwithoutide
Name: "tools\buildsbi"; Description: "{cm:ComponentUtilities_buildsbi}"; Types: full fullwithoutide
Name: "tools\sbinducr"; Description: "{cm:ComponentUtilities_sbinducr}"; Types: full fullwithoutide
Name: "tools\vmutool"; Description: "{cm:ComponentUtilities_vmutool}"; Types: full fullwithoutide

[Run]
Filename: "{code:GetApplicationComponentGettingStartedFilePath}"; WorkingDir: "{code:GetApplicationMainPath}"; Flags: nowait postinstall skipifsilent shellexec; Description: "{cm:LaunchGettingStarted}"
Filename: "{code:GetApplicationComponentManagerFilePath}"; Parameters: "--home-dir ""{app}"""; WorkingDir: "{code:GetApplicationMainPath}"; Flags: nowait postinstall skipifsilent unchecked; Description: "{cm:LaunchProgram,{#StringChange(FullAppManagerName, '&', '&&')}}"
Filename: "{code:GetApplicationComponentHelpFilePath}"; WorkingDir: "{code:GetApplicationMainPath}"; Flags: nowait postinstall skipifsilent unchecked shellexec; Description: "{cm:LaunchProgram,{#StringChange(MyAppNameHelp, '&', '&&')}}"

[Registry]
Root: "HKLM"; Subkey: "System\CurrentControlSet\Control\Session Manager\Environment"; ValueType: string; ValueName: "DREAMSDK_HOME"; ValueData: "{app}"; Flags: preservestringtype uninsdeletevalue

[UninstallDelete]
Type: dirifempty; Name: "{code:GetApplicationSupportPath}\ide\codeblocks"
Type: dirifempty; Name: "{code:GetApplicationSupportPath}\ide"
Type: dirifempty; Name: "{code:GetApplicationSupportPath}"

[Dirs]
Name: "{code:GetApplicationShortcutsPath}\{cm:DocumentationGroupDirectory}"; MinVersion: 0,6.2
Name: "{code:GetApplicationShortcutsPath}\{cm:UsefulLinksGroupDirectory}"; MinVersion: 0,6.2
Name: "{code:GetApplicationShortcutsPath}\{cm:ToolsGroupDirectory}"; MinVersion: 0,6.2

#include "inc/sections/files.iss"
#include "inc/sections/shortcuts.iss"
#include "inc/sections/labels.iss"
