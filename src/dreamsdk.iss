; ==============================================================================
; DreamSDK Setup - Inno Setup Script
; ==============================================================================

#include "inc/const.iss"
#include "config.iss"

; Source directories
#if SourceMode == RELEASE
#define SourceDirectoryBase "..\.sources"
#else
#define SourceDirectoryBase "..\.sources-dev"
#endif

#define SourceDirectoryMinGW SourceDirectoryBase + "\mingw-base"
#define SourceDirectoryMSYS SourceDirectoryBase + "\msys-base"
#define SourceDirectoryAddons SourceDirectoryBase + "\addons-cmd"
#define SourceDirectoryTools SourceDirectoryBase + "\addons-gui"
#define SourceDirectoryAppBinaries SourceDirectoryBase + "\dreamsdk-binaries"
#define SourceDirectoryAppSystemObjects SourceDirectoryBase + "\system-objects"
#define SourceDirectoryAppSystemObjectsConfiguration SourceDirectoryBase + "\system-objects-configuration"
; Toolchains
#define SourceDirectoryToolchainLegacy SourceDirectoryBase + "\toolchain-legacy"
#define SourceDirectoryToolchainOldStable SourceDirectoryBase + "\toolchain-oldstable"
#define SourceDirectoryToolchainStable SourceDirectoryBase + "\toolchain-stable"

; GDB
#define SourceDirectoryGdb SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-no-python"
#define SourceDirectoryGdbPython27 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-2.7"
#define SourceDirectoryGdbPython33 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.3"
#define SourceDirectoryGdbPython34 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.4"
#define SourceDirectoryGdbPython35 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.5"
#define SourceDirectoryGdbPython36 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.6"
#define SourceDirectoryGdbPython37 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.7"
#define SourceDirectoryGdbPython38 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.8"
#define SourceDirectoryGdbPython39 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.9"
#define SourceDirectoryGdbPython310 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.10"
#define SourceDirectoryGdbPython311 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.11"
#define SourceDirectoryGdbPython312 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.12"

; Embedded libraries
#define SourceDirectoryEmbedded SourceDirectoryBase + "\lib-embedded"
#define SourceDirectoryEmbeddedKallisti SourceDirectoryEmbedded + "\lib"
#define SourceDirectoryEmbeddedRuby SourceDirectoryEmbedded + "\ruby"

; Packages
#define SourcePackagesBinary SourceDirectoryBase + "\binary-packages"
#define SourcePackagesSource SourceDirectoryBase + "\source-packages"

; You don't have to modify anything beyond this point

#define MyAppID "{DF847892-5D85-4FFA-8603-E71750D81602}"
#define MyAppName "DreamSDK"
#define MyAppPublisher "The DreamSDK Team"
#define MyAppURL "https://www.dreamsdk.org/"

; Used by the installer for checking if Internet is available
; This should be HTTP only
#define TestConnectionURL "http://dreamsdk.org/.update/version.txt"

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

; Paths
#define AppMsysBase "{app}\msys\1.0"
#define AppOptBase AppMsysBase + "\opt"
#define AppToolchainBase AppOptBase + "\toolchains\dc"
#define AppToolchainSuperHDirectory AppToolchainBase + "\sh-elf"
#define AppMainDirectory AppOptBase + "\dreamsdk"
#define AppHelpersDirectory AppMainDirectory + "\helpers"
#define AppMainExeName AppMainDirectory + "\dreamsdk-shell.exe"
#define AppManagerExeName AppMainDirectory + "\dreamsdk-manager.exe"
#define AppHelpFile AppMainDirectory + "\dreamsdk.chm"
#define AppGettingStartedFile AppMainDirectory + "\getstart.rtf"
#define AppSupportDirectory "{app}\support"
#define AppAddonsDirectory AppMainDirectory + "\addons"
#define AppToolsDirectory AppMainDirectory + "\tools"
#define AppPackagesDirectory AppMainDirectory + "\packages"
#define AppShortcutsDirectory AppSupportDirectory + "\shortcuts"

#define OutputBaseFileName "setup"

#define BuildDateTime GetDateTimeString('yyyy/mm/dd @ hh:nn:ss', '-', ':');

#define IdeCodeBlocksName "Code::Blocks"
#define IdeCodeBlocksSupportedVersions "17.12 or 20.03"

#define IdeComponentsListName "ide"

#define WindowsTerminalName "Windows Terminal"

; Includes
#include "inc/psvince.iss"
#include "inc/utils.iss"
#include "inc/components.iss"
#include "inc/preq.iss"
#include "inc/ui.iss"
#include "inc/environ.iss"
#include "inc/ide.iss"
#include "inc/version.iss"
#include "inc/kos.iss"
#include "inc/ruby.iss"
#include "inc/gdb.iss"#include "inc/helpers.iss"
#include "inc/winver.iss"
#include "inc/toolchains.iss"
#include "inc/wt.iss"

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
UninstallDisplayIcon={#AppSupportDirectory}\uninst.ico
UninstallFilesDir={#AppSupportDirectory}
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
AppReadmeFile={#AppSupportDirectory}\license.rtf
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

[Files]
; Install helpers
Source: "..\rsrc\helpers\{#PSVinceLibraryFileName}"; DestDir: "{#AppSupportDirectory}"; Flags: ignoreversion noencryption nocompression

; Temporary files used for the installation
Source: "..\.helpers\*"; Flags: dontcopy noencryption nocompression
Source: "..\rsrc\pages\*.bmp"; Flags: dontcopy noencryption nocompression

; Some additional resources
Source: "..\rsrc\text\license.rtf"; DestDir: "{#AppSupportDirectory}"; Flags: ignoreversion
Source: "..\rsrc\uninst\uninst.ico"; DestDir: "{#AppSupportDirectory}"; Flags: ignoreversion

; MinGW Base
Source: "{#SourceDirectoryMinGW}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base; Excludes: "msys\1.0\etc\profile,msys\1.0\etc\fstab,msys\1.0\etc\fstab.sample,msys\1.0\home\*"

; MSYS Base
Source: "{#SourceDirectoryMSYS}\*"; DestDir: "{#AppMsysBase}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base

; Toolchains
Source: "{#SourceDirectoryToolchainStable}\*"; DestDir: "{#AppToolchainBase}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsToolchainsStable
Source: "{#SourceDirectoryToolchainOldStable}\*"; DestDir: "{#AppToolchainBase}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsToolchainsOldStable
Source: "{#SourceDirectoryToolchainLegacy}\*"; DestDir: "{#AppToolchainBase}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsToolchainsLegacy

; GDB
Source: "{#SourceDirectoryGdb}\*"; DestDir: "{#AppToolchainSuperHDirectory}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsGdbPythonNone
Source: "{#SourceDirectoryGdbPython27}\*"; DestDir: "{#AppToolchainSuperHDirectory}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsGdbPython27
Source: "{#SourceDirectoryGdbPython33}\*"; DestDir: "{#AppToolchainSuperHDirectory}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsGdbPython33
Source: "{#SourceDirectoryGdbPython34}\*"; DestDir: "{#AppToolchainSuperHDirectory}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsGdbPython34
Source: "{#SourceDirectoryGdbPython35}\*"; DestDir: "{#AppToolchainSuperHDirectory}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsGdbPython35
Source: "{#SourceDirectoryGdbPython36}\*"; DestDir: "{#AppToolchainSuperHDirectory}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsGdbPython36
Source: "{#SourceDirectoryGdbPython37}\*"; DestDir: "{#AppToolchainSuperHDirectory}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsGdbPython37
Source: "{#SourceDirectoryGdbPython38}\*"; DestDir: "{#AppToolchainSuperHDirectory}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsGdbPython38
Source: "{#SourceDirectoryGdbPython39}\*"; DestDir: "{#AppToolchainSuperHDirectory}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsGdbPython39
Source: "{#SourceDirectoryGdbPython310}\*"; DestDir: "{#AppToolchainSuperHDirectory}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsGdbPython310
Source: "{#SourceDirectoryGdbPython311}\*"; DestDir: "{#AppToolchainSuperHDirectory}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsGdbPython311
Source: "{#SourceDirectoryGdbPython312}\*"; DestDir: "{#AppToolchainSuperHDirectory}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsGdbPython312

; DreamSDK
Source: "{#SourceDirectoryAppSystemObjects}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base
Source: "{#SourceDirectoryAppSystemObjectsConfiguration}\*"; DestDir: "{#AppMsysBase}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base
Source: "{#SourceDirectoryAppBinaries}\*"; DestDir: "{#AppMainDirectory}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base
Source: "{#SourcePackagesBinary}\*"; DestDir: "{#AppPackagesDirectory}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base
Source: "{#SourcePackagesSource}\*"; DestDir: "{#AppPackagesDirectory}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base

; Addons
Source: "{#SourceDirectoryAddons}\elevate\*"; DestDir: "{#AppAddonsDirectory}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: addons\elevate
Source: "{#SourceDirectoryAddons}\pvr2png\*"; DestDir: "{#AppAddonsDirectory}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: addons\pvr2png
Source: "{#SourceDirectoryAddons}\txfutils\*"; DestDir: "{#AppAddonsDirectory}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: addons\txfutils
Source: "{#SourceDirectoryAddons}\txfutils-txflib\*"; DestDir: "{#AppAddonsDirectory}\txflib"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: addons\txfutils\txflib
Source: "{#SourceDirectoryAddons}\vmutool\*"; DestDir: "{#AppAddonsDirectory}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: addons\vmutool

; KallistiOS Embedded
Source: "{#SourceDirectoryEmbeddedKallisti}\*"; DestDir: "{#AppToolchainBase}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsKallistiEmbedded
Source: "{#SourceDirectoryEmbeddedRuby}\mruby\*"; DestDir: "{#AppOptBase}\mruby"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsKallistiEmbedded
Source: "{#SourceDirectoryEmbeddedRuby}\samples\*"; DestDir: "{#AppToolchainBase}\ruby"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsKallistiEmbedded

; GUI Tools
Source: "{#SourceDirectoryTools}\bdreams\*"; DestDir: "{#AppToolsDirectory}\bdreams"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: tools\bdreams
Source: "{#SourceDirectoryTools}\checker\*"; DestDir: "{#AppToolsDirectory}\checker"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: tools\checker
Source: "{#SourceDirectoryTools}\ipwriter\*"; DestDir: "{#AppToolsDirectory}\ipwriter"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: tools\ipwriter
Source: "{#SourceDirectoryTools}\ipwriter-iplogos\*"; DestDir: "{#AppToolsDirectory}\ipwriter\iplogos"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: tools\ipwriter\iplogos
Source: "{#SourceDirectoryTools}\mrwriter\*"; DestDir: "{#AppToolsDirectory}\mrwriter"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: tools\mrwriter
Source: "{#SourceDirectoryTools}\buildsbi\*"; DestDir: "{#AppToolsDirectory}\buildsbi"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: tools\buildsbi
Source: "{#SourceDirectoryTools}\sbinducr\*"; DestDir: "{#AppToolsDirectory}\sbinducr"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: tools\sbinducr
Source: "{#SourceDirectoryTools}\vmutool\*"; DestDir: "{#AppToolsDirectory}\vmutool"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: tools\vmutool

[Icons]
; Main shortcuts
Name: "{group}\{#FullAppMainName}"; Filename: "{#AppMainExeName}"; WorkingDir: "{#AppMainDirectory}"; Comment: "{cm:ExecuteMainApplication}"
Name: "{group}\{#FullAppManagerName}"; Filename: "{#AppManagerExeName}"; WorkingDir: "{#AppMainDirectory}"; Comment: "{cm:ExecuteManagerApplication}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"; WorkingDir: "{app}"; IconFilename: "{#AppSupportDirectory}\uninst.ico"; IconIndex: 0; Comment: "{cm:UninstallPackage}"

; Installation directory main shortcuts
Name: "{app}\{#FullAppMainName}"; Filename: "{#AppMainExeName}"; WorkingDir: "{#AppMainDirectory}"; Comment: "{cm:ExecuteMainApplication}"
Name: "{app}\{#FullAppManagerName}"; Filename: "{#AppManagerExeName}"; WorkingDir: "{#AppMainDirectory}"; Comment: "{cm:ExecuteManagerApplication}"
Name: "{app}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"; WorkingDir: "{app}"; IconFilename: "{#AppSupportDirectory}\uninst.ico"; Comment: "{cm:UninstallPackage}"

; Additional shortcuts (based on tasks)
Name: "{commondesktop}\{#FullAppMainName}"; Filename: "{#AppMainExeName}"; WorkingDir: "{#AppMainDirectory}"; Comment: "{cm:ExecuteMainApplication}"; Tasks: desktopicon
Name: "{commonappdata}\Microsoft\Internet Explorer\Quick Launch\{#FullAppMainName}"; Filename: "{#AppMainExeName}"; Comment: "{cm:ExecuteMainApplication}"; Tasks: quicklaunchicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#FullAppMainName}"; Filename: "{#AppMainExeName}"; Comment: "{cm:ExecuteMainApplication}"; Tasks: quicklaunchicon

;
; Post-Windows 8 shortcuts
;

; Documentation
Name: "{group}\{cm:DocumentationGroupDirectory}"; Filename: "{#AppShortcutsDirectory}\{cm:DocumentationGroupDirectory}"; Flags: preventpinning excludefromshowinnewinstall; MinVersion: 0,6.2
Name: "{#AppShortcutsDirectory}\{cm:DocumentationGroupDirectory}\{cm:GettingStarted}"; Filename: "{#AppGettingStartedFile}"; MinVersion: 0,6.2
Name: "{#AppShortcutsDirectory}\{cm:DocumentationGroupDirectory}\{cm:LicenseInformation}"; Filename: "{#AppSupportDirectory}\license.rtf"; MinVersion: 0,6.2
Name: "{#AppShortcutsDirectory}\{cm:DocumentationGroupDirectory}\{cm:ProgramHelp}"; Filename: "{#AppHelpFile}"; MinVersion: 0,6.2
Name: "{#AppShortcutsDirectory}\{cm:DocumentationGroupDirectory}\{cm:KallistiOfficialDocumentation}"; Filename: "http://gamedev.allusion.net/docs/kos-2.0.0/"; MinVersion: 0,6.2
Name: "{#AppShortcutsDirectory}\{cm:DocumentationGroupDirectory}\{cm:SegaDreamcastWikiDocumentation}"; Filename: "https://dreamcast.wiki"; MinVersion: 0,6.2

; Useful Links
Name: "{group}\{cm:UsefulLinksGroupDirectory}"; Filename: "{#AppShortcutsDirectory}\{cm:UsefulLinksGroupDirectory}"; Flags: preventpinning excludefromshowinnewinstall; MinVersion: 0,6.2
Name: "{#AppShortcutsDirectory}\{cm:UsefulLinksGroupDirectory}\{cm:LinkAwesomeDreamcast}"; Filename: "https://github.com/dreamcastdevs/awesome-dreamcast"; MinVersion: 0,6.2
Name: "{#AppShortcutsDirectory}\{cm:UsefulLinksGroupDirectory}\{cm:LinkCodeBlocks}"; Filename: "http://www.codeblocks.org"; MinVersion: 0,6.2
Name: "{#AppShortcutsDirectory}\{cm:UsefulLinksGroupDirectory}\{cm:LinkDCEmulation}"; Filename: "https://dcemulation.org"; MinVersion: 0,6.2
Name: "{#AppShortcutsDirectory}\{cm:UsefulLinksGroupDirectory}\{cm:LinkDCEmulationProgrammingDiscussion}"; Filename: "https://dcemulation.org/phpBB/viewforum.php?f=29"; MinVersion: 0,6.2
Name: "{#AppShortcutsDirectory}\{cm:UsefulLinksGroupDirectory}\{cm:LinkAppGitHub}"; Filename: "https://github.com/dreamsdk"; MinVersion: 0,6.2
Name: "{#AppShortcutsDirectory}\{cm:UsefulLinksGroupDirectory}\{cm:ProgramOnTheWeb,{#MyAppName}}"; Filename: "{#MyAppURL}"; MinVersion: 0,6.2
Name: "{#AppShortcutsDirectory}\{cm:UsefulLinksGroupDirectory}\{cm:LinkMarcusDreamcast}"; Filename: "http://mc.pp.se/dc"; MinVersion: 0,6.2
Name: "{#AppShortcutsDirectory}\{cm:UsefulLinksGroupDirectory}\{cm:LinkSegaDreamcastGitHub}"; Filename: "https://github.com/sega-dreamcast"; MinVersion: 0,6.2
Name: "{#AppShortcutsDirectory}\{cm:UsefulLinksGroupDirectory}\{cm:LinkSimulantDiscordChannel}"; Filename: "https://discord.gg/TRx94EV"; MinVersion: 0,6.2
Name: "{#AppShortcutsDirectory}\{cm:UsefulLinksGroupDirectory}\{cm:LinkSiZiOUS}"; Filename: "http://www.sizious.com"; MinVersion: 0,6.2

; Tools
Name: "{group}\{cm:ToolsGroupDirectory}"; Filename: "{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}"; Flags: preventpinning excludefromshowinnewinstall; MinVersion: 0,6.2

; Tools: 1ST_READ.BIN Checker
Name: "{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}\{cm:LinkChecker}"; Filename: "{#AppToolsDirectory}\checker\checker.exe"; WorkingDir: "{#AppToolsDirectory}\checker"; Comment: "{cm:ComponentUtilities_checker}"; MinVersion: 0,6.2; Components: tools\checker
Name: "{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkCheckerReadme}"; Filename: "{#AppToolsDirectory}\checker\readme.txt"; WorkingDir: "{#AppToolsDirectory}\checker"; MinVersion: 0,6.2; Components: tools\checker

; Tool: BootDreams
Name: "{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}\{cm:LinkBootDreams}"; Filename: "{#AppToolsDirectory}\bdreams\BootDreams.exe"; WorkingDir: "{#AppToolsDirectory}\bdreams"; Comment: "{cm:ComponentUtilities_bdreams}"; MinVersion: 0,6.2; Components: tools\bdreams
Name: "{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkBootDreamsHelp}"; Filename: "{#AppToolsDirectory}\bdreams\BootDreams.chm"; WorkingDir: "{#AppToolsDirectory}\bdreams"; MinVersion: 0,6.2; Components: tools\bdreams

; Tool: IP.BIN Writer
Name: "{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}\{cm:LinkIpWriter}"; Filename: "{#AppToolsDirectory}\ipwriter\ipwriter.exe"; WorkingDir: "{#AppToolsDirectory}\ipwriter"; Comment: "{cm:ComponentUtilities_ipwriter}"; MinVersion: 0,6.2; Components: tools\ipwriter
Name: "{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkIpWriterHelp}"; Filename: "{#AppToolsDirectory}\ipwriter\ipwriter.chm"; WorkingDir: "{#AppToolsDirectory}\ipwriter"; MinVersion: 0,6.2; Components: tools\ipwriter

; Tool: MR Writer
Name: "{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}\{cm:LinkMRWriter}"; Filename: "{#AppToolsDirectory}\mrwriter\mrwriter.exe"; WorkingDir: "{#AppToolsDirectory}\mrwriter"; Comment: "{cm:ComponentUtilities_mrwriter}"; MinVersion: 0,6.2; Components: tools\mrwriter
Name: "{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkMRWriterReadme}"; Filename: "{#AppToolsDirectory}\mrwriter\readme.txt"; WorkingDir: "{#AppToolsDirectory}\mrwriter"; MinVersion: 0,6.2; Components: tools\mrwriter

; Tool: SBI Builder
Name: "{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}\{cm:LinkSbiBuilder}"; Filename: "{#AppToolsDirectory}\buildsbi\buildsbi.exe"; WorkingDir: "{#AppToolsDirectory}\buildsbi"; Comment: "{cm:ComponentUtilities_buildsbi}"; MinVersion: 0,6.2; Components: tools\buildsbi
Name: "{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkSbiBuilderChanges}"; Filename: "{#AppToolsDirectory}\buildsbi\docs\changes.txt"; WorkingDir: "{#AppToolsDirectory}\buildsbi"; MinVersion: 0,6.2; Components: tools\buildsbi
Name: "{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkSbiBuilderReadme}"; Filename: "{#AppToolsDirectory}\buildsbi\docs\readme.txt"; WorkingDir: "{#AppToolsDirectory}\buildsbi"; MinVersion: 0,6.2; Components: tools\buildsbi

; Tool: Selfboot Inducer
Name: "{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}\{cm:LinkSelfbootInducer}"; Filename: "{#AppToolsDirectory}\sbinducr\sbinducr.exe"; WorkingDir: "{#AppToolsDirectory}\sbinducr"; Comment: "{cm:ComponentUtilities_sbinducr}"; MinVersion: 0,6.2; Components: tools\sbinducr
Name: "{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkSelfbootInducerReadme}"; Filename: "{#AppToolsDirectory}\sbinducr\docs\readme.txt"; WorkingDir: "{#AppToolsDirectory}\sbinducr"; MinVersion: 0,6.2; Components: tools\sbinducr
Name: "{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkSelfbootInducerChanges}"; Filename: "{#AppToolsDirectory}\sbinducr\docs\whatsnew.txt"; WorkingDir: "{#AppToolsDirectory}\sbinducr"; MinVersion: 0,6.2; Components: tools\sbinducr

; Tool: VMU Tool PC
Name: "{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}\{cm:LinkVmuTool}"; Filename: "{#AppToolsDirectory}\vmutool\vmutool.exe"; WorkingDir: "{#AppToolsDirectory}\vmutool"; Comment: "{cm:ComponentUtilities_vmutool}"; MinVersion: 0,6.2; Components: tools\vmutool
Name: "{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkVmuToolHelp}"; Filename: "{#AppToolsDirectory}\vmutool\help\vmutool.chm"; WorkingDir: "{#AppToolsDirectory}\vmutool"; MinVersion: 0,6.2; Components: tools\vmutool
Name: "{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkVmuToolReadme}"; Filename: "{#AppToolsDirectory}\vmutool\help\readme.rtf"; WorkingDir: "{#AppToolsDirectory}\vmutool"; MinVersion: 0,6.2; Components: tools\vmutool

;
; Pre-Windows 8 shortcuts below
;

; Documentation
Name: "{group}\{cm:DocumentationGroupDirectory}\{cm:GettingStarted}"; Filename: "{#AppGettingStartedFile}"; OnlyBelowVersion: 0,6.2
Name: "{group}\{cm:DocumentationGroupDirectory}\{cm:LicenseInformation}"; Filename: "{#AppSupportDirectory}\license.rtf"; OnlyBelowVersion: 0,6.2
Name: "{group}\{cm:DocumentationGroupDirectory}\{cm:ProgramHelp}"; Filename: "{#AppHelpFile}"; OnlyBelowVersion: 0,6.2
Name: "{group}\{cm:DocumentationGroupDirectory}\{cm:KallistiOfficialDocumentation}"; Filename: "http://gamedev.allusion.net/docs/kos-2.0.0/"; OnlyBelowVersion: 0,6.2
Name: "{group}\{cm:DocumentationGroupDirectory}\{cm:SegaDreamcastWikiDocumentation}"; Filename: "https://dreamcast.wiki"; OnlyBelowVersion: 0,6.2

; Useful Links
Name: "{group}\{cm:UsefulLinksGroupDirectory}\{cm:LinkAwesomeDreamcast}"; Filename: "https://github.com/dreamcastdevs/awesome-dreamcast"; OnlyBelowVersion: 0,6.2
Name: "{group}\{cm:UsefulLinksGroupDirectory}\{cm:LinkCodeBlocks}"; Filename: "http://www.codeblocks.org"; OnlyBelowVersion: 0,6.2
Name: "{group}\{cm:UsefulLinksGroupDirectory}\{cm:LinkDCEmulation}"; Filename: "https://dcemulation.org"; OnlyBelowVersion: 0,6.2
Name: "{group}\{cm:UsefulLinksGroupDirectory}\{cm:LinkDCEmulationProgrammingDiscussion}"; Filename: "https://dcemulation.org/phpBB/viewforum.php?f=29"; OnlyBelowVersion: 0,6.2
Name: "{group}\{cm:UsefulLinksGroupDirectory}\{cm:LinkAppGitHub}"; Filename: "https://github.com/dreamsdk"; OnlyBelowVersion: 0,6.2
Name: "{group}\{cm:UsefulLinksGroupDirectory}\{cm:ProgramOnTheWeb,{#MyAppName}}"; Filename: "{#MyAppURL}"; OnlyBelowVersion: 0,6.2
Name: "{group}\{cm:UsefulLinksGroupDirectory}\{cm:LinkMarcusDreamcast}"; Filename: "http://mc.pp.se/dc"; OnlyBelowVersion: 0,6.2
Name: "{group}\{cm:UsefulLinksGroupDirectory}\{cm:LinkSegaDreamcastGitHub}"; Filename: "https://github.com/sega-dreamcast"; OnlyBelowVersion: 0,6.2
Name: "{group}\{cm:UsefulLinksGroupDirectory}\{cm:LinkSimulantDiscordChannel}"; Filename: "https://discord.gg/TRx94EV"; OnlyBelowVersion: 0,6.2
Name: "{group}\{cm:UsefulLinksGroupDirectory}\{cm:LinkSiZiOUS}"; Filename: "http://www.sizious.com"; OnlyBelowVersion: 0,6.2

;
; Tools
;

; Tools: 1ST_READ.BIN Checker
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:LinkChecker}"; Filename: "{#AppToolsDirectory}\checker\checker.exe"; WorkingDir: "{#AppToolsDirectory}\checker"; Comment: "{cm:ComponentUtilities_checker}"; OnlyBelowVersion: 0,6.2; Components: tools\checker
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkCheckerReadme}"; Filename: "{#AppToolsDirectory}\checker\readme.txt"; WorkingDir: "{#AppToolsDirectory}\checker"; OnlyBelowVersion: 0,6.2; Components: tools\checker

; Tool: BootDreams
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:LinkBootDreams}"; Filename: "{#AppToolsDirectory}\bdreams\BootDreams.exe"; WorkingDir: "{#AppToolsDirectory}\bdreams"; Comment: "{cm:ComponentUtilities_bdreams}"; OnlyBelowVersion: 0,6.2; Components: tools\bdreams
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkBootDreamsHelp}"; Filename: "{#AppToolsDirectory}\bdreams\BootDreams.chm"; WorkingDir: "{#AppToolsDirectory}\bdreams"; OnlyBelowVersion: 0,6.2; Components: tools\bdreams

; Tool: IP.BIN Writer
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:LinkIpWriter}"; Filename: "{#AppToolsDirectory}\ipwriter\ipwriter.exe"; WorkingDir: "{#AppToolsDirectory}\ipwriter"; Comment: "{cm:ComponentUtilities_ipwriter}"; OnlyBelowVersion: 0,6.2; Components: tools\ipwriter
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkIpWriterHelp}"; Filename: "{#AppToolsDirectory}\ipwriter\ipwriter.chm"; WorkingDir: "{#AppToolsDirectory}\ipwriter"; OnlyBelowVersion: 0,6.2; Components: tools\ipwriter

; Tool: MR Writer
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:LinkMRWriter}"; Filename: "{#AppToolsDirectory}\mrwriter\mrwriter.exe"; WorkingDir: "{#AppToolsDirectory}\mrwriter"; Comment: "{cm:ComponentUtilities_mrwriter}"; OnlyBelowVersion: 0,6.2; Components: tools\mrwriter
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkMRWriterReadme}"; Filename: "{#AppToolsDirectory}\mrwriter\readme.txt"; WorkingDir: "{#AppToolsDirectory}\mrwriter"; OnlyBelowVersion: 0,6.2; Components: tools\mrwriter

; Tool: SBI Builder
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:LinkSbiBuilder}"; Filename: "{#AppToolsDirectory}\buildsbi\buildsbi.exe"; WorkingDir: "{#AppToolsDirectory}\buildsbi"; Comment: "{cm:ComponentUtilities_buildsbi}"; OnlyBelowVersion: 0,6.2; Components: tools\buildsbi
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkSbiBuilderChanges}"; Filename: "{#AppToolsDirectory}\buildsbi\docs\changes.txt"; WorkingDir: "{#AppToolsDirectory}\buildsbi"; OnlyBelowVersion: 0,6.2; Components: tools\buildsbi
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkSbiBuilderReadme}"; Filename: "{#AppToolsDirectory}\buildsbi\docs\readme.txt"; WorkingDir: "{#AppToolsDirectory}\buildsbi"; OnlyBelowVersion: 0,6.2; Components: tools\buildsbi

; Tool: Selfboot Inducer
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:LinkSelfbootInducer}"; Filename: "{#AppToolsDirectory}\sbinducr\sbinducr.exe"; WorkingDir: "{#AppToolsDirectory}\sbinducr"; Comment: "{cm:ComponentUtilities_sbinducr}"; OnlyBelowVersion: 0,6.2; Components: tools\sbinducr
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkSelfbootInducerReadme}"; Filename: "{#AppToolsDirectory}\sbinducr\docs\readme.txt"; WorkingDir: "{#AppToolsDirectory}\sbinducr"; OnlyBelowVersion: 0,6.2; Components: tools\sbinducr
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkSelfbootInducerChanges}"; Filename: "{#AppToolsDirectory}\sbinducr\docs\whatsnew.txt"; WorkingDir: "{#AppToolsDirectory}\sbinducr"; OnlyBelowVersion: 0,6.2; Components: tools\sbinducr

; Tool: VMU Tool PC
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:LinkVmuTool}"; Filename: "{#AppToolsDirectory}\vmutool\vmutool.exe"; WorkingDir: "{#AppToolsDirectory}\vmutool"; Comment: "{cm:ComponentUtilities_vmutool}"; OnlyBelowVersion: 0,6.2; Components: tools\vmutool
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkVmuToolHelp}"; Filename: "{#AppToolsDirectory}\vmutool\help\vmutool.chm"; WorkingDir: "{#AppToolsDirectory}\vmutool"; OnlyBelowVersion: 0,6.2; Components: tools\vmutool
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkVmuToolReadme}"; Filename: "{#AppToolsDirectory}\vmutool\help\readme.rtf"; WorkingDir: "{#AppToolsDirectory}\vmutool"; OnlyBelowVersion: 0,6.2; Components: tools\vmutool

[Run]
Filename: "{#AppGettingStartedFile}"; WorkingDir: "{#AppMainDirectory}"; Flags: nowait postinstall skipifsilent shellexec; Description: "{cm:LaunchGettingStarted}"
Filename: "{#AppManagerExeName}"; Parameters: "--home-dir ""{app}"""; WorkingDir: "{#AppMainDirectory}"; Flags: nowait postinstall skipifsilent unchecked; Description: "{cm:LaunchProgram,{#StringChange(FullAppManagerName, '&', '&&')}}"
Filename: "{#AppHelpFile}"; WorkingDir: "{#AppMainDirectory}"; Flags: nowait postinstall skipifsilent unchecked shellexec; Description: "{cm:LaunchProgram,{#StringChange(MyAppNameHelp, '&', '&&')}}"

[CustomMessages]
; Shortcut icons
ProgramHelp={#MyAppNameHelp}
LicenseInformation={#MyAppName} License Information
ExecuteMainApplication=Start a new {#FullAppMainName} session
ExecuteManagerApplication=Configure and manage your {#MyAppName} installation
UninstallPackage=Remove {#MyAppName} from your computer

; Documentation
DocumentationGroupDirectory=Documentation
GettingStarted=Getting Started
KallistiOfficialDocumentation=KallistiOS Official Documentation
SegaDreamcastWikiDocumentation=Sega Dreamcast Wiki

; Useful links
UsefulLinksGroupDirectory=Useful Links
LinkAwesomeDreamcast=Awesome Dreamcast
LinkCodeBlocks=CodeBlocks
LinkDCEmulation=DCEmulation
LinkDCEmulationProgrammingDiscussion=DCEmulation - Programming Discussion
LinkAppGitHub={#MyAppName} GitHub
LinkMarcusDreamcast=Marcus Comstedt (zeldin) - Dreamcast Programming
LinkSegaDreamcastGitHub=Sega Dreamcast GitHub
LinkSimulantDiscordChannel=Simulant Engine - Discord Channel
LinkSiZiOUS=SiZiOUS Serial Koder

; Tools
ToolsGroupDirectory=Tools
ToolsDocumentationGroupDirectory=Tools Documentation
LinkBootDreams=BootDreams
LinkSbiBuilder=SBI Builder
LinkChecker=1ST_READ.BIN Checker
LinkIpWriter=IP.BIN Writer
LinkMRWriter=MR Writer
LinkSelfbootInducer=Selfboot Inducer
LinkVmuTool=VMU Tool PC

; Tools documentation
LinkBootDreamsHelp=BootDreams - Help
LinkSbiBuilderChanges=SBI Builder - Changes
LinkSbiBuilderReadme=SBI Builder - Read Me
LinkCheckerReadme=1ST_READ.BIN Checker - Read Me
LinkIpWriterHelp=IP.BIN Writer - Help
LinkMRWriterReadme=MR Writer - Read Me
LinkSelfbootInducerReadme=Selfboot Inducer - Read Me
LinkSelfbootInducerChanges=Selfboot Inducer - Changes
LinkVmuToolHelp=VMU Tool PC - Help
LinkVmuToolReadme=VMU Tool PC - Read Me

; Generic buttons
ButtonBrowse=Browse...
ButtonRefresh=Refresh

; Prerequisites
PrerequisiteMissing=%s %s missing.
PrerequisiteMissingLink=and
PrerequisiteMissingVerbSingle=is
PrerequisiteMissingVerbMultiple=are
PrerequisiteMissingHintMandatory=Please install %s, check %s availability in PATH system-wide environment variable then try again.
PrerequisiteMissingHintOptional=For better experience, install %s and check %s availability in PATH system-wide environment variable. Continue anyway?
PrerequisiteMissingHintLink1Single=it
PrerequisiteMissingHintLink1Multiple=them
PrerequisiteMissingHintLink2Single=its
PrerequisiteMissingHintLink2Multiple=their
PrerequisiteMissingPython=Python
PrerequisiteMissingGit=Git
PrerequisiteMissingSubversion=Subversion Client (SVN)
PrerequisiteMissingRuby=Ruby

; Startup messages
PreviousVersionUninstall={#MyAppName} %s is already installed. This version will be uninstalled. Continue?
PreviousVersionUninstallFailed=Failed to uninstall {#MyAppName} %s (Error 0x%.8x). You should restart your computer and run Setup again. Continue anyway?
VersionAlreadyInstalled={#MyAppName} %s is already installed. If you want to reinstall it, it need to be uninstalled first. Continue anyway?
NewerVersionAlreadyInstalled={#MyAppName} %s is already installed, which is newer that the version provided in this package (%s). Setup will exit now.
PreviousVersionUninstallUnableToGetCommand=Failed to uninstall {#MyAppName} %s. The uninstall command was not retrieved from the registry! Continue anyway?

; Destination Directory
InstallationDirectoryContainSpaces=Sorry, target installation directory cannot contain spaces. Choose a different one.

; Components: Types
TypeFullInstallationWithoutIDE=Full installation without IDE integration
TypeFullInstallation=Full installation
TypeCompactInstallation=Compact installation
TypeCustomInstallation=Custom installation

; Components: List
ComponentMain=Base program files (required)
ComponentBase=MinGW/MSYS and Win32 toolchain (required)
ComponentToolchains=Super-H and AICA toolchains (required)
ComponentKOS=KallistiOS, KallistiOS Ports and Dreamcast Tool (required)
ComponentIDE=Support for Integrated Development Environment (IDE)
ComponentIDE_CodeBlocks={#IdeCodeBlocksName}
ComponentAdditionalTools=Additional command line tools
ComponentAdditionalTools_elevate=Elevate – Command-line UAC elevation utility (elevate)
ComponentAdditionalTools_pvr2png=PVR to PNG – PowerVR image to PNG converter (pvr2png)
ComponentAdditionalTools_txfutils=TXF Utilities – Textured font format tools (showtxf, ttf2txf)
ComponentAdditionalTools_txfutils_txflib=Additional ready-to-use TXF fonts files
ComponentAdditionalTools_vmutool=VMU Tool PC – Visual Memory data manager (vmutool)
ComponentUtilities=Additional graphical tools
ComponentUtilities_bdreams=BootDreams – Selfboot image generator frontend
ComponentUtilities_buildsbi=SBI Builder – Selfboot Inducer package generator
ComponentUtilities_checker=1ST_READ.BIN Checker – Binary program state checker
ComponentUtilities_ipwriter=IP.BIN Writer – Initial Program manipulation tool
ComponentUtilities_ipwriter_iplogos=Additional ready-to-use Initial Program logos
ComponentUtilities_mrwriter=MR Writer – Initial Program picture format management tool
ComponentUtilities_sbinducr=Selfboot Inducer – DreamInducer disc generator
ComponentUtilities_vmutool=VMU Tool PC – Visual Memory data manager (GUI)

; Toolchains
ToolchainsTitlePage=Toolchains Configuration
ToolchainsSubtitlePage=Which toolchains version do you want to use?
LabelToolchainsIntroduction=Customize your toolchains installation.
LabelToolchainsDescription=Toolchains are used for producing Sega Dreamcast programs. You may choose your prefered version now. You can change this later in {#FullAppManagerName}.
ToolchainsStable=Stable
ToolchainsStableDisabled= (unsupported on your OS)
LabelToolchainsDescriptionStable=Stable toolchains are based on GCC {#ToolchainsStableVersionSuperH} with Newlib {#ToolchainsStableVersionNewlib} for SuperH and GCC {#ToolchainsStableVersionAICA} for AICA. It's the current toolchains officially supported.
ToolchainsLegacy=Legacy
ToolchainsLegacyConfirmation=Legacy toolchains are pretty old, are you sure to continue? You can change that later in {#FullAppManagerName}.
LabelToolchainsDescriptionLegacy=Legacy toolchains are based on GCC {#ToolchainsLegacyVersion} with Newlib {#ToolchainsLegacyVersionNewlib}. This was the previous, officially supported toolchains for the past decade.
ToolchainsOldStable=Old Stable
LabelToolchainsDescriptionOldStable=Old stable toolchains are based on GCC {#ToolchainsOldStableVersionSuperH} with Newlib {#ToolchainsOldStableVersionNewlib} for SuperH and GCC {#ToolchainsOldStableVersionAICA} for AICA. It's the previous stable toolchains.

; GNU Debugger for Super H
GdbTitlePage=GNU Debugger (GDB) Configuration
GdbSubtitlePage=Do you want to enable Python extensions of GDB for SuperH?
LabelGdbIntroduction=Customize your GNU Debugger (GDB) {#GdbVersion} for SuperH installation.
LabelGdbDescription=You may enable now Python extensions for GDB {#GdbVersion}, but only Python 32-bits is supported. If the options below are disabled then install a 32-bits Python runtime on your computer and run Setup again. You can change this later in {#FullAppManagerName}. 
GdbPythonNone=Don't enable Python extensions for GNU Debugger (GDB)
GdbPython27=Python 2.7
GdbPython33=Python 3.3
GdbPython34=Python 3.4
GdbPython35=Python 3.5
GdbPython36=Python 3.6
GdbPython37=Python 3.7
GdbPython38=Python 3.8
GdbPython39=Python 3.9
GdbPython310=Python 3.10
GdbPython311=Python 3.11
GdbPython312=Python 3.12

; Ruby
RubyTitlePage=Ruby Configuration
RubySubtitlePage=Do you want to enable Ruby support for the Sega Dreamcast?
LabelRubyIntroduction=You may use RubyInstaller for Windows to set up Ruby on your computer.
LabelRubyDescription=Ruby may be used for Sega Dreamcast programming, but this is experimental. This feature uses mruby, the lightweight Ruby implementation which may be embedded in C/C++ programs. Sample projects are provided, you may use them as templates.
RubyEnabled=Enable Ruby (experimental)
LabelRubyDescriptionEnabled=Enable Ruby support for the Sega Dreamcast. This is experimental. Ruby projects are not supported in {#IdeCodeBlocksName}.
RubyDisabled=Don't enable Ruby
LabelRubyDescriptionDisabled=Don't enable Ruby support for the Sega Dreamcast. You may activate it later in {#FullAppManagerName} if you change your mind.
RubyEnableConfirmation=Ruby support for the Sega Dreamcast is experimental. Are you sure to continue?

; KallistiOS
KallistiEmbeddedTitlePage=Sega Dreamcast Libraries Configuration
KallistiEmbeddedSubtitlePage=From where do you want to retrieve the libraries?
LabelKallistiEmbeddedIntroduction=Configure from where do you want to retrieve the required components.
LabelKallistiEmbeddedDescription={#MyAppName} needs KallistiOS (kos), KallistiOS Ports (kos-ports) and Dreamcast Tool (dcload-serial, dcload-ip) in order to work properly. These components are libraries used for the Sega Dreamcast development, in addition of the provided toolchains.
KallistiEmbeddedOnline=Use online repositories (highly recommended)
InactiveInternetConnection=To use the online repositories, the {#MyAppName} Setup need to be connected to Internet. Please check your connection and try again.
KallistiEmbeddedOffline=Use offline repositories
KallistiEmbeddedOfflineConfirmation=Are you really sure to use offline repositories included in that {#MyAppName} Setup?
LabelKallistiEmbeddedDescriptionOnline=This option will allow you to stay up-to-date by using the online repositories. This requires an Internet connection and Git. For better experience, Python and Subversion Client (SVN) are recommended, but not mandatory.
LabelKallistiEmbeddedDescriptionOffline={#MyAppName} includes offline versions of the required Sega Dreamcast component libraries. Use this option only if you don't have an active Internet connection or you don't want to use the up-to-date online repositories.

; Code::Blocks IDE
CodeBlocksTitlePage={#IdeCodeBlocksName} Plug-in Integration
CodeBlocksSubtitlePage=Where are located the {#IdeCodeBlocksName} files?
LabelCodeBlocksIntroduction={#IdeCodeBlocksName} must be installed before {#MyAppName} to enable the integration.%nCurrently, only {#IdeCodeBlocksSupportedVersions} binaries versions are supported.
LabelCodeBlocksInstallationDirectory=Select the {#IdeCodeBlocksName} installation directory:
LabelCodeBlocksConfigurationFiles={#MyAppName} will be enabled in {#IdeCodeBlocksName} for all the users listed below. If an user is missing from that list, you can run {#IdeCodeBlocksName} one time with that user or you may click on the Initialize button.
LabelCodeBlocksDetectedVersion=Detected {#IdeCodeBlocksName} version: %s
ButtonCodeBlocksInitialize=Initialize...
CodeBlocksInstallationDirectoryNotExists=The specified {#IdeCodeBlocksName} installation directory doesn't exists. Please install {#IdeCodeBlocksName} and run it at least once.
CodeBlocksInstallationUsersUnavailable=No profiles where found for {#IdeCodeBlocksName}. Please run {#IdeCodeBlocksName} at least once for each profile where you want to use {#MyAppName}, or you may click on the Initialize button.
CodeBlocksBinaryFileNameNotExists=There is no {#IdeCodeBlocksName} SDK dynamic library in the specified directory. Are you sure that you have installed {#IdeCodeBlocksName} in that directory?
CodeBlocksBinaryHashDifferent=The installed {#IdeCodeBlocksName} version need to be {#IdeCodeBlocksSupportedVersions}. There is no guarantee that it will work with your current installed version. Continue anyway?
CodeBlocksIntegrationSetupFailed=Error when patching {#IdeCodeBlocksName}!%n%n%s
CodeBlocksIntegrationRemoveFailed=Error when restoring {#IdeCodeBlocksName}!%n%n%s
CodeBlocksRunning={#IdeCodeBlocksName} is running, please close it to continue.
CodeBlocksInitializeConfirmation=This will create the required files to enable {#IdeCodeBlocksName} integration for all the users on this computer. Continue?

; Windows Terminal
WindowsTerminalIntegrationInstallationFailed=Error when installing {#WindowsTerminalName}!%n%n%s
WindowsTerminalIntegrationUninstallationFailed=Error when uninstalling {#WindowsTerminalName}!%n%n%s

; Additional tasks
AddToPathEnvironmentVariable=Add {#MyAppName} to the PATH system environment variable
IntegrateWithWindowsTerminal=Add {#MyAppName} to {#WindowsTerminalName}

; End messages
UnableToFinalizeSetup=Unable to finalize the {#MyAppName} Setup!%nThe {#FullAppManagerName} application cannot be started.%nPlease notify {#MyAppPublisher} to fix this issue, visit {#MyAppURL} for more information.
LaunchGettingStarted=Open the Getting Started guide

[Registry]
Root: "HKLM"; Subkey: "System\CurrentControlSet\Control\Session Manager\Environment"; ValueType: string; ValueName: "DREAMSDK_HOME"; ValueData: "{app}"; Flags: preservestringtype uninsdeletevalue

[UninstallDelete]
Type: dirifempty; Name: "{#AppSupportDirectory}\ide\codeblocks"
Type: dirifempty; Name: "{#AppSupportDirectory}\ide"
Type: dirifempty; Name: "{#AppSupportDirectory}"

[InstallDelete]
Type: filesandordirs; Name: "{#AppToolchainBase}\*"
Type: filesandordirs; Name: "{#AppOptBase}\mruby\*"

[Dirs]
Name: "{#AppShortcutsDirectory}\{cm:DocumentationGroupDirectory}"; MinVersion: 0,6.2
Name: "{#AppShortcutsDirectory}\{cm:UsefulLinksGroupDirectory}"; MinVersion: 0,6.2
Name: "{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}"; MinVersion: 0,6.2

[Code]
const
  // This should match the [Types] section of this file.
  TYPES_COMBO_ITEMINDEX_FULL_INSTALLATION_WITHOUT_IDE = 0;
  TYPES_COMBO_ITEMINDEX_FULL_INSTALLATION = 1;
  TYPES_COMBO_ITEMINDEX_COMPACT_INSTALLATION = 2;
  TYPES_COMBO_ITEMINDEX_CUSTOM_INSTALLATION = 3;

  CODEBLOCKS_EXE_NAME = 'codeblocks.exe';

var
  BrowseForFolderExFakePageID,
  IntegratedDevelopmentEnvironmentSettingsPageID, 
  GdbPageID,
  KallistiEmbeddedPageID,
  RubyPageID,
  ToolchainsPageID: Integer;

  ComponentsListDisabledItemsCount,
  ComponentsListItemsCountWithoutIde: Integer;  

procedure ComponentsListCheckChanges;
var
  SelectedComponentsCount,
  ComponentsCount: Integer;  

begin
  SelectedComponentsCount := GetSelectedComponentsCount;
  ComponentsCount := GetComponentsListCount;

  Log(Format('Components List Status: %d selected of %d', [SelectedComponentsCount, ComponentsCount]));
  
  if (SelectedComponentsCount = ComponentsCount) then
    WizardForm.TypesCombo.ItemIndex := TYPES_COMBO_ITEMINDEX_FULL_INSTALLATION
  else if (SelectedComponentsCount = ComponentsListDisabledItemsCount) then
    WizardForm.TypesCombo.ItemIndex := TYPES_COMBO_ITEMINDEX_COMPACT_INSTALLATION
  else if not IsComponentSelected('{#IdeComponentsListName}') and (SelectedComponentsCount = ComponentsListItemsCountWithoutIde) then
    WizardForm.TypesCombo.ItemIndex := TYPES_COMBO_ITEMINDEX_FULL_INSTALLATION_WITHOUT_IDE
  else
    WizardForm.TypesCombo.ItemIndex := TYPES_COMBO_ITEMINDEX_CUSTOM_INSTALLATION;
end;

procedure ComponentsListClickCheck(Sender: TObject);
begin
  ComponentsListCheckChanges;
end;

procedure HandleComponentsListTypesCombo;
begin
  // Thanks to: https://stackoverflow.com/a/36989894/3726096
  WizardForm.ComponentsList.OnClickCheck := @ComponentsListClickCheck;
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
  Result := IsProcessRunning(CODEBLOCKS_EXE_NAME);
  if Result then
  begin
    MsgBox(CustomMessage('CodeBlocksRunning'), mbError, MB_OK);
    Exit;    
  end;   
end;

function InitializeSetup: Boolean;
begin
  Result := True;
  SetUninstallMode(False);

  // Check modules running
  if IsModulesRunning then
  begin
    Result := False;
    Exit;
  end;

#if InstallerMode == RELEASE
  // This test should be the latest!
  // Check if an old version is installed
  Result := Result
    and HandlePreviousVersion('{#MyAppID}', '{#PackageVersion}');
#else
  Result := True;
#endif
end;

procedure FinalizeSetup;
begin
  SetPackageVersion;
  PatchMountPoint;
  SetupApplication;
  CreateJunctions;
  AddGitSafeDirectories;
end;

function InitializeUninstall: Boolean;
begin
  Result := True;
  SetUninstallMode(True);

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
  
  // Select Directory Page
  if (CurPageID = wpSelectDir) then
  begin
    // Avoid spaces in the Installation Path  
    Result := (Pos(' ', WizardDirValue) = 0);
    if not Result then
    begin
      MsgBox(CustomMessage('InstallationDirectoryContainSpaces'), mbError, MB_OK);
      Exit;
    end;
  end;

  // Toolchains Page
  if (CurPageID = ToolchainsPageID) then
  begin
    if IsToolchainsLegacy then
    begin
      // Sure to use legacy toolchain?
      Result := ConfirmLegacyToolchainsUsage;
      if not Result then
        Exit;
    end;
  end;

  // Ruby Page
  if (CurPageID = RubyPageID) then
  begin
    if IsRubyEnabled then
    begin
      // Check Ruby prerequisites
      Result := CheckRubyPrerequisites;
      if not Result then
        Exit;

      // Sure to continue?
      Result := ConfirmRubyUsage;
      if not Result then
        Exit;
    end;  
  end;
  
  // KallistiOS Page
  if (CurPageID = KallistiEmbeddedPageID) then
  begin
    // Checking if the user is SURE to use the embedded KOS
    if IsKallistiEmbedded then
    begin
      { Offline }     

      // Check mandatory prerequisites
      Result := CheckOfflinePrerequisitesMandatory;
      if not Result then
        Exit;

      // Check optional prerequisites
      Result := CheckOfflinePrerequisitesOptional;
      if not Result then      
        Exit;
        
      // Sure to continue?
      Result := ConfirmKallistiEmbeddedUsage;
      if not Result then
        Exit;             
    end
    else
    begin
      { Online }
      
      // Check Internet connection
      Result := CheckInternetConnection;
      if not Result then 
        Exit;

      // Check mandatory prerequisites
      Result := CheckOnlinePrerequisitesMandatory;
      if not Result then
        Exit;

      // Check optional prerequisites
      Result := CheckOnlinePrerequisitesOptional;
      if not Result then      
        Exit;
    end;
  end;

  // Code::Blocks Page
  if (CurPageID = IntegratedDevelopmentEnvironmentSettingsPageID) then
  begin
    // Checking if the Code::Blocks Integration page is well filled
    Result := IsCodeBlocksIntegrationEnabled and IsCodeBlocksIntegrationReady;
  end;

  // Finalizing the installation.
  if (CurPageID = wpInfoAfter) then
  begin
    WizardForm.NextButton.Enabled := False;

    // Install Code::Blocks Integration if requested.
    if IsCodeBlocksIntegrationEnabled then
      InstallCodeBlocksIntegration;

    // Patch fstab and setup KallistiOS.
    FinalizeSetup;

    WizardForm.NextButton.Enabled := True;
  end;
end;

function ShouldSkipPage(PageID: Integer): Boolean;
begin 
  Result := False;

  // Always skip BrowseForFolderExFakePage...
  if (PageID = BrowseForFolderExFakePageID) then
    Result := True;
    
  // Display IDE Page only if needed
  if (PageID = IntegratedDevelopmentEnvironmentSettingsPageID) then
  begin
    Result := not IsCodeBlocksIntegrationEnabled;
    Log(Format('Should Skip Page IDE: %d', [Result]));
  end;
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID = wpSelectComponents then
  begin
    // Retrieve components name from the ComponentsList
    InitializeComponentsListNames;

    // Get all disabled items from the ComponentsList
    ComponentsListDisabledItemsCount := GetComponentsListDisabledItemsCount;

    // Get the IDE items from the ComponentsList
    ComponentsListItemsCountWithoutIde := 
      GetComponentsListCount - GetComponentRootLevelItemsCount('{#IdeComponentsListName}');
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if (CurStep = ssPostInstall) then
  begin
    if IsTaskSelected('envpath') then
      EnvAddPath(ExpandConstant('{#AppMainDirectory}'));
    if IsTaskSelected('wtconfig') then
      InstallWindowsTerminalIntegration;
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if (CurUninstallStep = usUninstall) then
  begin
    RemoveJunctions;
    UninstallCodeBlocksIntegration;
    UninstallWindowsTerminalIntegration;
  end;	
  if (CurUninstallStep = usPostUninstall) then
    EnvRemovePath(ExpandConstant('{#AppMainDirectory}'));
end;

procedure InitializeWizard;
begin
  BrowseForFolderExFakePageID := CreateBrowseForFolderExFakePage;  
  KallistiEmbeddedPageID := CreateKallistiEmbeddedPage;  
  RubyPageID := CreateRubyPage;
  GdbPageID := CreateGdbPage;
  ToolchainsPageID := CreateToolchainsPage;
  IntegratedDevelopmentEnvironmentSettingsPageID := CreateIntegratedDevelopmentEnvironmentPage;
  HandleComponentsListTypesCombo;
end;
