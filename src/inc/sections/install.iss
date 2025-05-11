[Registry]
Root: "HKLM"; Subkey: "System\CurrentControlSet\Control\Session Manager\Environment"; ValueType: string; ValueName: "{#MyAppEnvironmentVariable}"; ValueData: "{app}"; Flags: preservestringtype uninsdeletevalue

[Dirs]
Name: "{code:GetApplicationShortcutsPath}\{cm:DocumentationGroupDirectory}"; MinVersion: 0,6.2
Name: "{code:GetApplicationShortcutsPath}\{cm:UsefulLinksGroupDirectory}"; MinVersion: 0,6.2
Name: "{code:GetApplicationShortcutsPath}\{cm:ToolsGroupDirectory}"; MinVersion: 0,6.2

[Files]
; Temporary files used for the installation
Source: "..\rsrc\pages\*.bmp"; Flags: dontcopy noencryption nocompression

; Additional Resources
Source: "..\rsrc\text\license.rtf"; DestDir: "{code:GetApplicationSupportPath}"; Flags: ignoreversion
Source: "..\rsrc\uninst\uninst.ico"; DestDir: "{code:GetApplicationSupportPath}"; Flags: ignoreversion

; MinGW/MSYS Base
Source: "{#SourceDirectoryMinGW}\*"; DestDir: "{code:GetApplicationRootPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base\mingw; Excludes: "msys\1.0\etc\profile,msys\1.0\etc\fstab,msys\1.0\etc\fstab.sample,msys\1.0\home\*"
Source: "{#SourceDirectoryMSYS}\*"; DestDir: "{code:GetMsysUserBasePath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base\mingw
Source: "{#SourceDirectoryAppSystemObjectsMSYS}\*"; DestDir: "{code:GetApplicationRootPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base\mingw
Source: "{#SourceDirectoryAppSystemObjectsConfiguration}\*"; DestDir: "{code:GetMsysInstallationPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base\mingw

; MinGW-w64/MSYS2 Base
Source: "{#SourceDirectoryMinGW64}\*"; DestDir: "{code:GetApplicationRootPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base\mingw64; Excludes: "dev\mqueue,dev\shm,etc\pacman.d\gnupg,etc\hosts,etc\mtab,etc\networks,etc\protocols,etc\services,home\*"
Source: "{#SourceDirectoryMSYS2}\*"; DestDir: "{code:GetMsysUserBasePath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base\mingw64
Source: "{#SourceDirectoryAppSystemObjectsMSYS2}\*"; DestDir: "{code:GetApplicationRootPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base\mingw64

; Addons: Command-line
Source: "{#SourceDirectoryAddons}\elevate\*"; DestDir: "{code:GetApplicationAddonsPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: addons\elevate
Source: "{#SourceDirectoryAddons}\pvr2png\*"; DestDir: "{code:GetApplicationAddonsPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: addons\pvr2png
Source: "{#SourceDirectoryAddons}\txfutils\*"; DestDir: "{code:GetApplicationAddonsPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: addons\txfutils
Source: "{#SourceDirectoryAddons}\txfutils-txflib\*"; DestDir: "{code:GetApplicationAddonsPath}\txflib"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: addons\txfutils\txflib
Source: "{#SourceDirectoryAddons}\vmutool\*"; DestDir: "{code:GetApplicationAddonsPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: addons\vmutool

; Addons: GUI
Source: "{#SourceDirectoryTools}\bdreams\*"; DestDir: "{code:GetApplicationToolsPath}\bdreams"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: tools\bdreams
Source: "{#SourceDirectoryTools}\checker\*"; DestDir: "{code:GetApplicationToolsPath}\checker"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: tools\checker
Source: "{#SourceDirectoryTools}\ipwriter\*"; DestDir: "{code:GetApplicationToolsPath}\ipwriter"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: tools\ipwriter
Source: "{#SourceDirectoryTools}\ipwriter-iplogos\*"; DestDir: "{code:GetApplicationToolsPath}\ipwriter\iplogos"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: tools\ipwriter\iplogos
Source: "{#SourceDirectoryTools}\mrwriter\*"; DestDir: "{code:GetApplicationToolsPath}\mrwriter"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: tools\mrwriter
Source: "{#SourceDirectoryTools}\buildsbi\*"; DestDir: "{code:GetApplicationToolsPath}\buildsbi"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: tools\buildsbi
Source: "{#SourceDirectoryTools}\sbinducr\*"; DestDir: "{code:GetApplicationToolsPath}\sbinducr"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: tools\sbinducr
Source: "{#SourceDirectoryTools}\vmutool\*"; DestDir: "{code:GetApplicationToolsPath}\vmutool"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: tools\vmutool

; DreamSDK Common
Source: "{#SourceDirectoryAppCommonObjects}\*"; DestDir: "{code:GetMsysInstallationPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base
Source: "{#SourceDirectorySystemUtilities}\*"; DestDir: "{code:GetMsysUserBasePath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base
                                                      
; DreamSDK Binaries: x86
Source: "{#SourceDirectoryAppBinaries}\*"; DestDir: "{code:GetApplicationMainPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base\mingw
Source: "{#SourcePackagesBinary}\*"; DestDir: "{code:GetApplicationPackagesPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base\mingw

; DreamSDK Binaries: x64
Source: "{#SourceDirectoryAppBinaries64}\*"; DestDir: "{code:GetApplicationMainPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base\mingw64
Source: "{#SourcePackagesBinary64}\*"; DestDir: "{code:GetApplicationPackagesPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base\mingw64

; Source Packages
Source: "{#SourcePackagesSource}\*"; DestDir: "{code:GetApplicationPackagesPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base

; Embedded Libraries
Source: "{#SourceDirectoryEmbeddedKallisti}\*"; DestDir: "{code:GetApplicationToolchainBasePath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsKallistiEmbedded
