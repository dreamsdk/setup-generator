; =============================================================================
;  ____                         _____  ____   _____
; |    .  ___  ___  ___  _____ |   __||    . |  |  |
; |  |  ||  _|| -_|| .'||     ||__   ||  |  ||    -|
; |____/ |_|  |___||__,||_|_|_||_____||____/ |__|__|
;
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

; Environment variable
#if InstallerMode == DEBUG && EnvironmentHomeVariableMode == DEBUG
#define MyAppEnvironmentVariable "DREAMSDK_HOME_DEBUG"
#else
#define MyAppEnvironmentVariable "DREAMSDK_HOME"
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
#include "inc/utils/registry.iss"
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

// ============================================================================
// MAIN
// ============================================================================

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"; LicenseFile: "..\rsrc\text\license.rtf"; InfoBeforeFile: "..\rsrc\text\before.rtf"; InfoAfterFile: "..\rsrc\text\after.rtf"

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

// ============================================================================
// SECTIONS
// ============================================================================

#include "inc/sections/labels.iss"

#include "inc/sections/install.iss"
#include "inc/sections/components.iss"
#include "inc/sections/tasks.iss"
#include "inc/sections/shortcuts.iss"

#include "inc/sections/uninstall.iss"

// ============================================================================
// MAIN
// ============================================================================

#include "inc/main.iss"
