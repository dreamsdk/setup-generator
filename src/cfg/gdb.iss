; =============================================================================
;  ____                         _____  ____   _____
; |    .  ___  ___  ___  _____ |   __||    . |  |  |
; |  |  ||  _|| -_|| .'||     ||__   ||  |  ||    -|
; |____/ |_|  |___||__,||_|_|_||_____||____/ |__|__|
;
; =============================================================================
; DreamSDK Setup - GDB Configuration
; =============================================================================
;
; THIS FILE HAS BEEN GENERATED. PLEASE DON'T UPDATE IT.
;

; x86 (32-bit)
#define Gdb32Count 13

#define SourceDirectoryGdb32 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-no-python"
#define SourceDirectoryGdb32Python27 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-2.7"
#define SourceDirectoryGdb32Python33 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.3"
#define SourceDirectoryGdb32Python34 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.4"
#define SourceDirectoryGdb32Python35 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.5"
#define SourceDirectoryGdb32Python36 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.6"
#define SourceDirectoryGdb32Python37 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.7"
#define SourceDirectoryGdb32Python38 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.8"
#define SourceDirectoryGdb32Python39 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.9"
#define SourceDirectoryGdb32Python310 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.10"
#define SourceDirectoryGdb32Python311 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.11"
#define SourceDirectoryGdb32Python312 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.12"
#define SourceDirectoryGdb32Python313 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.13"

; x64 (64-bit)
#define Gdb64Count 5

#define SourceDirectoryGdb64 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-no-python"
#define SourceDirectoryGdb64Python310 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.10"
#define SourceDirectoryGdb64Python311 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.11"
#define SourceDirectoryGdb64Python312 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.12"
#define SourceDirectoryGdb64Python313 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.13"

[CustomMessages]
GdbPython_None=Don't enable Python extensions for GNU Debugger (GDB)
GdbPython_27=Python 2.7
GdbPython_33=Python 3.3
GdbPython_34=Python 3.4
GdbPython_35=Python 3.5
GdbPython_36=Python 3.6
GdbPython_37=Python 3.7
GdbPython_38=Python 3.8
GdbPython_39=Python 3.9
GdbPython_310=Python 3.10
GdbPython_311=Python 3.11
GdbPython_312=Python 3.12
GdbPython_313=Python 3.13

[Code]
procedure InitializeArrayGdb();
begin
  // x86 (32-bit)
  InitializeGdb32Packages({#Gdb32Count});

  // None
  Gdb32Packages[0].Name := ExpandConstant('{cm:GdbPython_None}');
  Gdb32Packages[0].Version := '';

  // Python 2.7
  Gdb32Packages[1].Name := ExpandConstant('{cm:GdbPython_27}');
  Gdb32Packages[1].Version := '2.7';

  // Python 3.3
  Gdb32Packages[2].Name := ExpandConstant('{cm:GdbPython_33}');
  Gdb32Packages[2].Version := '3.3';

  // Python 3.4
  Gdb32Packages[3].Name := ExpandConstant('{cm:GdbPython_34}');
  Gdb32Packages[3].Version := '3.4';

  // Python 3.5
  Gdb32Packages[4].Name := ExpandConstant('{cm:GdbPython_35}');
  Gdb32Packages[4].Version := '3.5';

  // Python 3.6
  Gdb32Packages[5].Name := ExpandConstant('{cm:GdbPython_36}');
  Gdb32Packages[5].Version := '3.6';

  // Python 3.7
  Gdb32Packages[6].Name := ExpandConstant('{cm:GdbPython_37}');
  Gdb32Packages[6].Version := '3.7';

  // Python 3.8
  Gdb32Packages[7].Name := ExpandConstant('{cm:GdbPython_38}');
  Gdb32Packages[7].Version := '3.8';

  // Python 3.9
  Gdb32Packages[8].Name := ExpandConstant('{cm:GdbPython_39}');
  Gdb32Packages[8].Version := '3.9';

  // Python 3.10
  Gdb32Packages[9].Name := ExpandConstant('{cm:GdbPython_310}');
  Gdb32Packages[9].Version := '3.10';

  // Python 3.11
  Gdb32Packages[10].Name := ExpandConstant('{cm:GdbPython_311}');
  Gdb32Packages[10].Version := '3.11';

  // Python 3.12
  Gdb32Packages[11].Name := ExpandConstant('{cm:GdbPython_312}');
  Gdb32Packages[11].Version := '3.12';

  // Python 3.13
  Gdb32Packages[12].Name := ExpandConstant('{cm:GdbPython_313}');
  Gdb32Packages[12].Version := '3.13';

  // x64 (64-bit)
  InitializeGdb64Packages({#Gdb64Count});

  // None
  Gdb64Packages[0].Name := ExpandConstant('{cm:GdbPython_None}');
  Gdb64Packages[0].Version := '';
      
  // Python 3.10
  Gdb64Packages[1].Name := ExpandConstant('{cm:GdbPython_310}');
  Gdb64Packages[1].Version := '3.10';

  // Python 3.11
  Gdb64Packages[2].Name := ExpandConstant('{cm:GdbPython_311}');
  Gdb64Packages[2].Version := '3.11';

  // Python 3.12
  Gdb64Packages[3].Name := ExpandConstant('{cm:GdbPython_312}');
  Gdb64Packages[3].Version := '3.12';
  
  // Python 3.13
  Gdb64Packages[4].Name := ExpandConstant('{cm:GdbPython_313}');  
  Gdb64Packages[4].Version := '3.13';
end;

[Files]
; x86 (32-bit)
Source: "{#SourceDirectoryGdb32}\*"; DestDir: "{code:GetApplicationToolchainSuperHPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: "main\gdb\32\pythondisabled"
Source: "{#SourceDirectoryGdb32Python27}\*"; DestDir: "{code:GetApplicationToolchainSuperHPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: "main\gdb\32\python27"
Source: "{#SourceDirectoryGdb32Python33}\*"; DestDir: "{code:GetApplicationToolchainSuperHPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: "main\gdb\32\python33"
Source: "{#SourceDirectoryGdb32Python34}\*"; DestDir: "{code:GetApplicationToolchainSuperHPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: "main\gdb\32\python34"
Source: "{#SourceDirectoryGdb32Python35}\*"; DestDir: "{code:GetApplicationToolchainSuperHPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: "main\gdb\32\python35"
Source: "{#SourceDirectoryGdb32Python36}\*"; DestDir: "{code:GetApplicationToolchainSuperHPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: "main\gdb\32\python36"
Source: "{#SourceDirectoryGdb32Python37}\*"; DestDir: "{code:GetApplicationToolchainSuperHPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: "main\gdb\32\python37"
Source: "{#SourceDirectoryGdb32Python38}\*"; DestDir: "{code:GetApplicationToolchainSuperHPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: "main\gdb\32\python38"
Source: "{#SourceDirectoryGdb32Python39}\*"; DestDir: "{code:GetApplicationToolchainSuperHPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: "main\gdb\32\python39"
Source: "{#SourceDirectoryGdb32Python310}\*"; DestDir: "{code:GetApplicationToolchainSuperHPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: "main\gdb\32\python310"
Source: "{#SourceDirectoryGdb32Python311}\*"; DestDir: "{code:GetApplicationToolchainSuperHPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: "main\gdb\32\python311"
Source: "{#SourceDirectoryGdb32Python312}\*"; DestDir: "{code:GetApplicationToolchainSuperHPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: "main\gdb\32\python312"
Source: "{#SourceDirectoryGdb32Python313}\*"; DestDir: "{code:GetApplicationToolchainSuperHPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: "main\gdb\32\python313"

; x64 (64-bit)
Source: "{#SourceDirectoryGdb64}\*"; DestDir: "{code:GetApplicationToolchainSuperHPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: "main\gdb\64\pythondisabled"
Source: "{#SourceDirectoryGdb64Python310}\*"; DestDir: "{code:GetApplicationToolchainSuperHPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: "main\gdb\64\python310"
Source: "{#SourceDirectoryGdb64Python311}\*"; DestDir: "{code:GetApplicationToolchainSuperHPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: "main\gdb\64\python311"
Source: "{#SourceDirectoryGdb64Python312}\*"; DestDir: "{code:GetApplicationToolchainSuperHPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: "main\gdb\64\python312"
Source: "{#SourceDirectoryGdb64Python313}\*"; DestDir: "{code:GetApplicationToolchainSuperHPath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: "main\gdb\64\python313"

[Components]
; x86 (32-bit)
Name: "main\gdb\32"; Description: "{cm:ComponentGdb32}"; Flags: fixed
Name: "main\gdb\32\pythondisabled"; Description: "{cm:GdbPython_None}"; Flags: exclusive fixed
Name: "main\gdb\32\python27"; Description: "{cm:GdbPython_27}"; Flags: exclusive fixed
Name: "main\gdb\32\python33"; Description: "{cm:GdbPython_33}"; Flags: exclusive fixed
Name: "main\gdb\32\python34"; Description: "{cm:GdbPython_34}"; Flags: exclusive fixed
Name: "main\gdb\32\python35"; Description: "{cm:GdbPython_35}"; Flags: exclusive fixed
Name: "main\gdb\32\python36"; Description: "{cm:GdbPython_36}"; Flags: exclusive fixed
Name: "main\gdb\32\python37"; Description: "{cm:GdbPython_37}"; Flags: exclusive fixed
Name: "main\gdb\32\python38"; Description: "{cm:GdbPython_38}"; Flags: exclusive fixed
Name: "main\gdb\32\python39"; Description: "{cm:GdbPython_39}"; Flags: exclusive fixed
Name: "main\gdb\32\python310"; Description: "{cm:GdbPython_310}"; Flags: exclusive fixed
Name: "main\gdb\32\python311"; Description: "{cm:GdbPython_311}"; Flags: exclusive fixed
Name: "main\gdb\32\python312"; Description: "{cm:GdbPython_312}"; Flags: exclusive fixed
Name: "main\gdb\32\python313"; Description: "{cm:GdbPython_313}"; Flags: exclusive fixed

; x64 (64-bit)
Name: "main\gdb\64"; Description: "{cm:ComponentGdb64}"; Flags: fixed
Name: "main\gdb\64\pythondisabled"; Description: "{cm:GdbPython_None}"; Flags: exclusive fixed
Name: "main\gdb\64\python310"; Description: "{cm:GdbPython_310}"; Flags: exclusive fixed
Name: "main\gdb\64\python311"; Description: "{cm:GdbPython_311}"; Flags: exclusive fixed
Name: "main\gdb\64\python312"; Description: "{cm:GdbPython_312}"; Flags: exclusive fixed
Name: "main\gdb\64\python313"; Description: "{cm:GdbPython_313}"; Flags: exclusive fixed
