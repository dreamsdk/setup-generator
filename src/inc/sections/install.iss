[Registry]
Root: "HKLM"; Subkey: "System\CurrentControlSet\Control\Session Manager\Environment"; ValueType: string; ValueName: "{#MyAppEnvironmentVariable}"; ValueData: "{app}"; Flags: preservestringtype uninsdeletevalue

[Dirs]
Name: "{code:GetApplicationShortcutsPath}\{cm:DocumentationGroupDirectory}"; MinVersion: 0,6.2
Name: "{code:GetApplicationShortcutsPath}\{cm:UsefulLinksGroupDirectory}"; MinVersion: 0,6.2
Name: "{code:GetApplicationShortcutsPath}\{cm:ToolsGroupDirectory}"; MinVersion: 0,6.2

[Files]
; Install helpers
Source: "..\rsrc\helpers\{#PSVinceLibraryFileName}"; DestDir: "{code:GetApplicationSupportPath}"; Flags: ignoreversion noencryption nocompression
Source: "..\.helpers\{#HelperLibraryFileName}"; DestDir: "{code:GetApplicationSupportPath}"; Flags: ignoreversion noencryption nocompression

; Temporary files used for the installation
Source: "..\rsrc\pages\*.bmp"; Flags: dontcopy noencryption nocompression

; Some additional resources
Source: "..\rsrc\text\license.rtf"; DestDir: "{code:GetApplicationSupportPath}"; Flags: ignoreversion
Source: "..\rsrc\uninst\uninst.ico"; DestDir: "{code:GetApplicationSupportPath}"; Flags: ignoreversion

; MinGW/MSYS Base
Source: "{#SourceDirectoryMinGW}\*"; DestDir: "{code:GetApplicationRootPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base\mingw; Excludes: "msys\1.0\etc\profile,msys\1.0\etc\fstab,msys\1.0\etc\fstab.sample,msys\1.0\home\*"
Source: "{#SourceDirectoryMSYS}\*"; DestDir: "{code:GetMsysUserBasePath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base\mingw
Source: "{#SourceDirectoryAppSystemObjectsMSYS}\*"; DestDir: "{code:GetApplicationRootPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base\mingw
Source: "{#SourceDirectoryAppSystemObjectsConfiguration}\*"; DestDir: "{code:GetMsysInstallationPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base\mingw

; MinGW-w64/MSYS2 Base
Source: "{#SourceDirectoryMinGW64}\*"; DestDir: "{code:GetApplicationRootPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base\mingw64; Excludes: "clang32,clang64,clangarm64,dev\mqueue,dev\shm,etc\pacman.d\gnupg,etc\hosts,etc\mtab,etc\networks,etc\protocols,etc\services,home\*,mingw32,ucrt64,autorebase.bat,clang32.exe,clang32.ico,clang32.ini,clang64.exe,clang64.ico,clang64.ini,clangarm64.exe,clangarm64.ico,clangarm64.ini,mingw32.exe,mingw32.ico,mingw32.ini,mingw64.exe,mingw64.ico,mingw64.ini,msys2.exe,msys2.ico,msys2.ini,msys2_shell.cmd,test.log,ucrt64.exe,ucrt64.ico,ucrt64.ini"
Source: "{#SourceDirectoryMSYS2}\*"; DestDir: "{code:GetMsysUserBasePath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base\mingw64
Source: "{#SourceDirectoryAppSystemObjectsMSYS2}\*"; DestDir: "{code:GetApplicationRootPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base\mingw64

; Common
Source: "{#SourceDirectoryAppCommonObjects}\*"; DestDir: "{code:GetMsysInstallationPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base
Source: "{#SourceDirectorySystemUtilities}\*"; DestDir: "{code:GetMsysUserBasePath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base
                                                      
; DreamSDK
Source: "{#SourceDirectoryAppBinaries}\*"; DestDir: "{code:GetApplicationMainPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base
Source: "{#SourcePackagesBinary}\*"; DestDir: "{code:GetApplicationPackagesPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base
Source: "{#SourcePackagesSource}\*"; DestDir: "{code:GetApplicationPackagesPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\base

; Addons
Source: "{#SourceDirectoryAddons}\elevate\*"; DestDir: "{code:GetApplicationAddonsPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: addons\elevate
Source: "{#SourceDirectoryAddons}\pvr2png\*"; DestDir: "{code:GetApplicationAddonsPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: addons\pvr2png
Source: "{#SourceDirectoryAddons}\txfutils\*"; DestDir: "{code:GetApplicationAddonsPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: addons\txfutils
Source: "{#SourceDirectoryAddons}\txfutils-txflib\*"; DestDir: "{code:GetApplicationAddonsPath}\txflib"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: addons\txfutils\txflib
Source: "{#SourceDirectoryAddons}\vmutool\*"; DestDir: "{code:GetApplicationAddonsPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: addons\vmutool

; KallistiOS Embedded
Source: "{#SourceDirectoryEmbeddedKallisti}\*"; DestDir: "{code:GetApplicationToolchainBasePath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsKallistiEmbedded

; GUI Tools
Source: "{#SourceDirectoryTools}\bdreams\*"; DestDir: "{code:GetApplicationToolsPath}\bdreams"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: tools\bdreams
Source: "{#SourceDirectoryTools}\checker\*"; DestDir: "{code:GetApplicationToolsPath}\checker"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: tools\checker
Source: "{#SourceDirectoryTools}\ipwriter\*"; DestDir: "{code:GetApplicationToolsPath}\ipwriter"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: tools\ipwriter
Source: "{#SourceDirectoryTools}\ipwriter-iplogos\*"; DestDir: "{code:GetApplicationToolsPath}\ipwriter\iplogos"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: tools\ipwriter\iplogos
Source: "{#SourceDirectoryTools}\mrwriter\*"; DestDir: "{code:GetApplicationToolsPath}\mrwriter"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: tools\mrwriter
Source: "{#SourceDirectoryTools}\buildsbi\*"; DestDir: "{code:GetApplicationToolsPath}\buildsbi"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: tools\buildsbi
Source: "{#SourceDirectoryTools}\sbinducr\*"; DestDir: "{code:GetApplicationToolsPath}\sbinducr"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: tools\sbinducr
Source: "{#SourceDirectoryTools}\vmutool\*"; DestDir: "{code:GetApplicationToolsPath}\vmutool"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: tools\vmutool
