[Files]

; Install helpers
Source: "..\rsrc\helpers\{#PSVinceLibraryFileName}"; DestDir: "{code:GetApplicationSupportPath}"; Flags: ignoreversion noencryption nocompression

; Temporary files used for the installation
Source: "..\.helpers\*"; Flags: dontcopy noencryption nocompression
Source: "..\rsrc\pages\*.bmp"; Flags: dontcopy noencryption nocompression

; Some additional resources
Source: "..\rsrc\text\license.rtf"; DestDir: "{code:GetApplicationSupportPath}"; Flags: ignoreversion
Source: "..\rsrc\uninst\uninst.ico"; DestDir: "{code:GetApplicationSupportPath}"; Flags: ignoreversion

; MinGW/MSYS Base
Source: "{#SourceDirectoryMinGW}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base; Excludes: "msys\1.0\etc\profile,msys\1.0\etc\fstab,msys\1.0\etc\fstab.sample,msys\1.0\home\*"; Check: IsFoundationMinGW
Source: "{#SourceDirectoryMSYS}\*"; DestDir: "{code:GetMsysInstallationPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base; Check: IsFoundationMinGW
Source: "{#SourceDirectoryAppSystemObjectsMSYS}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base; Check: IsFoundationMinGW
Source: "{#SourceDirectoryAppSystemObjectsConfiguration}\*"; DestDir: "{code:GetMsysInstallationPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base; Check: IsFoundationMinGW

; MinGW-w64/MSYS2 Base
Source: "{#SourceDirectoryMinGW64}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base; Check: IsFoundationMinGW64
Source: "{#SourceDirectoryAppSystemObjectsMSYS2}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base; Check: IsFoundationMinGW64

; Utilities
Source: "{#SourceDirectorySystemUtilities}\*"; DestDir: "{code:GetMsysInstallationPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base
                                                      
; DreamSDK
Source: "{#SourceDirectoryAppBinaries}\*"; DestDir: "{code:GetApplicationMainPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base
Source: "{#SourcePackagesBinary}\*"; DestDir: "{code:GetApplicationPackagesPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base
Source: "{#SourcePackagesSource}\*"; DestDir: "{code:GetApplicationPackagesPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base

; Toolchains
Source: "{#SourceDirectoryToolchainStable}\*"; DestDir: "{code:GetApplicationToolchainBasePath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsToolchainsStable
Source: "{#SourceDirectoryToolchainOldStable}\*"; DestDir: "{code:GetApplicationToolchainBasePath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsToolchainsOldStable
Source: "{#SourceDirectoryToolchainLegacy}\*"; DestDir: "{code:GetApplicationToolchainBasePath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsToolchainsLegacy

; GDB
Source: "{#SourceDirectoryGdb}\*"; DestDir: "{code:GetApplicationToolchainSuperHPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsGdbPythonNone
Source: "{#SourceDirectoryGdbPython27}\*"; DestDir: "{code:GetApplicationToolchainSuperHPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsGdbPython27
Source: "{#SourceDirectoryGdbPython33}\*"; DestDir: "{code:GetApplicationToolchainSuperHPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsGdbPython33
Source: "{#SourceDirectoryGdbPython34}\*"; DestDir: "{code:GetApplicationToolchainSuperHPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsGdbPython34
Source: "{#SourceDirectoryGdbPython35}\*"; DestDir: "{code:GetApplicationToolchainSuperHPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsGdbPython35
Source: "{#SourceDirectoryGdbPython36}\*"; DestDir: "{code:GetApplicationToolchainSuperHPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsGdbPython36
Source: "{#SourceDirectoryGdbPython37}\*"; DestDir: "{code:GetApplicationToolchainSuperHPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsGdbPython37
Source: "{#SourceDirectoryGdbPython38}\*"; DestDir: "{code:GetApplicationToolchainSuperHPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsGdbPython38
Source: "{#SourceDirectoryGdbPython39}\*"; DestDir: "{code:GetApplicationToolchainSuperHPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsGdbPython39
Source: "{#SourceDirectoryGdbPython310}\*"; DestDir: "{code:GetApplicationToolchainSuperHPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsGdbPython310
Source: "{#SourceDirectoryGdbPython311}\*"; DestDir: "{code:GetApplicationToolchainSuperHPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsGdbPython311
Source: "{#SourceDirectoryGdbPython312}\*"; DestDir: "{code:GetApplicationToolchainSuperHPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsGdbPython312

; Addons
Source: "{#SourceDirectoryAddons}\elevate\*"; DestDir: "{code:GetApplicationAddonsPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: addons\elevate
Source: "{#SourceDirectoryAddons}\pvr2png\*"; DestDir: "{code:GetApplicationAddonsPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: addons\pvr2png
Source: "{#SourceDirectoryAddons}\txfutils\*"; DestDir: "{code:GetApplicationAddonsPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: addons\txfutils
Source: "{#SourceDirectoryAddons}\txfutils-txflib\*"; DestDir: "{code:GetApplicationAddonsPath}\txflib"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: addons\txfutils\txflib
Source: "{#SourceDirectoryAddons}\vmutool\*"; DestDir: "{code:GetApplicationAddonsPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: addons\vmutool

; KallistiOS Embedded
Source: "{#SourceDirectoryEmbeddedKallisti}\*"; DestDir: "{code:GetApplicationToolchainBasePath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsKallistiEmbedded
Source: "{#SourceDirectoryEmbeddedRuby}\mruby\*"; DestDir: "{code:GetApplicationOptBasePath}\mruby"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsKallistiEmbedded
Source: "{#SourceDirectoryEmbeddedRuby}\samples\*"; DestDir: "{code:GetApplicationToolchainBasePath}\ruby"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsKallistiEmbedded

; GUI Tools
Source: "{#SourceDirectoryTools}\bdreams\*"; DestDir: "{code:GetApplicationToolsPath}\bdreams"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: tools\bdreams
Source: "{#SourceDirectoryTools}\checker\*"; DestDir: "{code:GetApplicationToolsPath}\checker"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: tools\checker
Source: "{#SourceDirectoryTools}\ipwriter\*"; DestDir: "{code:GetApplicationToolsPath}\ipwriter"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: tools\ipwriter
Source: "{#SourceDirectoryTools}\ipwriter-iplogos\*"; DestDir: "{code:GetApplicationToolsPath}\ipwriter\iplogos"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: tools\ipwriter\iplogos
Source: "{#SourceDirectoryTools}\mrwriter\*"; DestDir: "{code:GetApplicationToolsPath}\mrwriter"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: tools\mrwriter
Source: "{#SourceDirectoryTools}\buildsbi\*"; DestDir: "{code:GetApplicationToolsPath}\buildsbi"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: tools\buildsbi
Source: "{#SourceDirectoryTools}\sbinducr\*"; DestDir: "{code:GetApplicationToolsPath}\sbinducr"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: tools\sbinducr
Source: "{#SourceDirectoryTools}\vmutool\*"; DestDir: "{code:GetApplicationToolsPath}\vmutool"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: tools\vmutool
