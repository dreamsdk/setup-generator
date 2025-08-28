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
LinkDreamcastWiki=Dreamcast Wiki

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
ComponentKeywordRequired= (required)
ComponentMain=Base program files
ComponentBase=Foundation and Win32 toolchain
ComponentBase32=MinGW/MSYS
ComponentBase64=MinGW-w64/MSYS2
ComponentToolchain=Toolchain profile for SuperH
ComponentToolchain32=Toolchain profile for SuperH - MinGW/MSYS
ComponentToolchain64=Toolchain profile for SuperH - MinGW-w64/MSYS2
ComponentGdb=GNU Debugger (GDB) for SuperH
ComponentGdb32=GNU Debugger (GDB) for SuperH - MinGW/MSYS
ComponentGdb64=GNU Debugger (GDB) for SuperH - MinGW-w64/MSYS2
ComponentKallisti=KallistiOS, KallistiOS Ports and Dreamcast Tool
ComponentKallistiOnline=Online (use Git repositories)
ComponentKallistiOffline=Offline (use embedded packages)
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
ComponentShell=Terminal/Shell
ComponentShellWindows=Windows Prompt/Windows Terminal
ComponentShellMinTTY=Mintty

; Foundation
FoundationTitlePage=Foundation Configuration
FoundationSubtitlePage=Which foundation do you want to use?
LabelFoundationIntroduction=Customize the base environment you want to use.
LabelFoundationDescription=Here you can choose which environment you will use. The foundation provides the core environment (such as GNU Bash), host toolchain (GCC for Windows), and additional utilities. This can't be changed later, so please choose wisely.
FoundationMinGW=MinGW/MSYS
LabelFoundationDescriptionMinGW=The legacy option. This environment is compatible with Windows XP and later, but unfortunately, it's quite outdated (e.g., GCC for Windows is still 9.x). Included packages are no longer updated.
FoundationMinGW64=MinGW-w64/MSYS2 (highly recommanded)
LabelFoundationDescriptionMinGW64=The modern option, compatible with Windows 10 and later. It's recommended to use this option whenever possible.
FoundationUseMinGWConfirmation=WARNING: MinGW/MSYS is obsolete. This cannot be changed later. Are you sure you want to continue?
FoundationMigrationUserFilesNeeded=A previous MinGW/MSYS-based installation has been detected. Please note that old files in "msys" (the previous root directory) are not migrated automatically.

; Toolchains
ToolchainsTitlePage=Toolchain Configuration
ToolchainsSubtitlePage=Which toolchain profile do you want to use?
LabelToolchainsIntroduction=Customize your toolchain installation.
LabelToolchainsDescription=Toolchains are used to build Sega Dreamcast programs. Please choose your preferred toolchain profile now. You may change this later in {#FullAppManagerName}.
LabelToolchainsSelection=Toolchain Profile:

; GNU Debugger for Super H
GdbTitlePage=GNU Debugger (GDB) Configuration
GdbSubtitlePage=Do you want to enable Python extensions of GDB for SuperH?
LabelGdbIntroduction=Customize your installation of GNU Debugger (GDB) %s.
LabelGdbDescription=You may enable now Python extensions for GDB %s%s. Please choose your preferred profile now. You may change this later in {#FullAppManagerName}.
LabelGdbDescription32BitOnly=, but only Python 32-bit is supported
LabelGdbSelection=GNU Debugger (GDB) Profile:
GdbPythonRuntimeNotFound=This GDB is binded with 32-bit Python %s, which was not found on your system.
GdbConfirmUnsupportedPythonUsage=The 32-bit Python %s binary was not found on your system, which is required for the selected build. Continue anyway? You may change that later in {#FullAppManagerName}.

; Shell / Terminal
ShellTitlePage=Terminal Configuration
ShellSubtitlePage=Which shell terminal do you want to use?
LabelShellIntroduction=Customize your preferred terminal application.
LabelShellDescription={#MyAppName} is primarily used via a terminal. Please choose your preferred terminal app now; this does not affect functionality. You can change this setting later in {#FullAppManagerName} at any time.
ShellWindows=Windows %s
ShellWindows_Prompt=Prompt
ShellWindows_Terminal=Terminal
LabelShellDescriptionWindows=Use the native, integrated Windows %s application.%s
LabelShellDescriptionWindows_Terminal= With Windows Terminal, you can configure more comprehensive integration using the {#MyAppName} Tasks step, including opening a new {#MyAppName} tab directly from Windows Terminal.
ShellMinTTY=Mintty
LabelShellDescriptionMinTTY=Use Mintty, the default MSYS terminal. Mintty offers a more flexible user interface and closer adherence to Unix standards compared to the standard Windows terminal application.

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
