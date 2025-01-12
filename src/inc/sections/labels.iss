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
ComponentMain=Base program files (required)
ComponentBase=MinGW/MSYS and Win32 toolchain (required)
ComponentToolchains=Super-H and AICA toolchains (required)
ComponentKOS=KallistiOS, KallistiOS Ports and Dreamcast Tool (required)
ComponentIDE=Support for Integrated Development Environment (IDE)
ComponentIDE_CodeBlocks={#IdeCodeBlocksName}
ComponentAdditionalTools=Additional command line tools
ComponentAdditionalTools_elevate=Elevate � Command-line UAC elevation utility (elevate)
ComponentAdditionalTools_pvr2png=PVR to PNG � PowerVR image to PNG converter (pvr2png)
ComponentAdditionalTools_txfutils=TXF Utilities � Textured font format tools (showtxf, ttf2txf)
ComponentAdditionalTools_txfutils_txflib=Additional ready-to-use TXF fonts files
ComponentAdditionalTools_vmutool=VMU Tool PC � Visual Memory data manager (vmutool)
ComponentUtilities=Additional graphical tools
ComponentUtilities_bdreams=BootDreams � Selfboot image generator frontend
ComponentUtilities_buildsbi=SBI Builder � Selfboot Inducer package generator
ComponentUtilities_checker=1ST_READ.BIN Checker � Binary program state checker
ComponentUtilities_ipwriter=IP.BIN Writer � Initial Program manipulation tool
ComponentUtilities_ipwriter_iplogos=Additional ready-to-use Initial Program logos
ComponentUtilities_mrwriter=MR Writer � Initial Program picture format management tool
ComponentUtilities_sbinducr=Selfboot Inducer � DreamInducer disc generator
ComponentUtilities_vmutool=VMU Tool PC � Visual Memory data manager (GUI)

; Foundation
FoundationTitlePage=Foundation Configuration
FoundationSubtitlePage=Which foundation do you want to use?
LabelFoundationIntroduction=Customize your foundation...
LabelFoundationDescription=Here you can choose a great thing
FoundationMinGW=MinGW/MSYS
LabelFoundationDescriptionMinGW=The legacy option
FoundationMinGW64=MinGW-w64/MSYS2 (highly recommanded)
LabelFoundationDescriptionMinGW64=The modern option
FoundationUseMinGWConfirmation=Are you sure to continue?

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