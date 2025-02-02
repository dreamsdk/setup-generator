; =============================================================================
;  ____                         _____  ____   _____
; |    .  ___  ___  ___  _____ |   __||    . |  |  |
; |  |  ||  _|| -_|| .'||     ||__   ||  |  ||    -|
; |____/ |_|  |___||__,||_|_|_||_____||____/ |__|__|
;
; =============================================================================
; DreamSDK Setup - Toolchains Configuration
; =============================================================================
;
; THIS FILE HAS BEEN GENERATED. PLEASE DON'T UPDATE IT.
;

#define ToolchainsCount 3

#define SourceDirectoryToolchain_Stable SourceDirectoryBase + "\toolchain-stable"
#define SourceDirectoryToolchain_1420 SourceDirectoryBase + "\toolchain-oldstable"
#define SourceDirectoryToolchain_950winxp SourceDirectoryBase + "\toolchain-legacy"

[CustomMessages]
ToolchainsName_Stable=Stable
ToolchainsDesc_Stable=Stable toolchain is based on GCC 13.2.0 with Newlib 4.3.0.20230120. It's the current toolchain officially supported.
ToolchainsName_1420=14.2.0
ToolchainsDesc_1420=14.2.0 toolchain is indeed based on GCC 14.2.0 with Newlib 4.x. This is the most modern toolchain.
ToolchainsName_950winxp=9.5.0-winxp
ToolchainsDesc_950winxp=This legacy toolchain is based on GCC 9.5.0 with Newlib 4.3.0.20230120. This was the previous, officially supported toolchains for the past decade.

[Code]
procedure InitializeRecordArray();
begin
  SetArrayLength(ToolchainPackages, {#ToolchainsCount});

  // Stable
  ToolchainPackages[0].Name := ExpandConstant('{cm:ToolchainsName_Stable}');
  ToolchainPackages[0].Description := ExpandConstant('{cm:ToolchainsDesc_Stable}');
  ToolchainPackages[0].IsModernWindowsOnly := True;

  // 14.2.0
  ToolchainPackages[1].Name := ExpandConstant('{cm:ToolchainsName_1420}');
  ToolchainPackages[1].Description := ExpandConstant('{cm:ToolchainsDesc_1420}');
  ToolchainPackages[1].IsModernWindowsOnly := True;

  // 9.5.0-winxp
  ToolchainPackages[2].Name := ExpandConstant('{cm:ToolchainsName_950winxp}');
  ToolchainPackages[2].Description := ExpandConstant('{cm:ToolchainsDesc_950winxp}');
  ToolchainPackages[2].IsModernWindowsOnly := False;
end;

[Files]
Source: "{#SourceDirectoryToolchain_Stable}\*"; DestDir: "{code:GetApplicationToolchainBasePath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\toolchains\stable
Source: "{#SourceDirectoryToolchain_1420}\*"; DestDir: "{code:GetApplicationToolchainBasePath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\toolchains\1420
Source: "{#SourceDirectoryToolchain_950winxp}\*"; DestDir: "{code:GetApplicationToolchainBasePath}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main\toolchains\950winxp

[Components]
Name: "main\toolchains\stable"; Description: "{cm:ToolchainsName_Stable}"; Flags: exclusive fixed
Name: "main\toolchains\1420"; Description: "{cm:ToolchainsName_1420}"; Flags: exclusive fixed
Name: "main\toolchains\950winxp"; Description: "{cm:ToolchainsName_950winxp}"; Flags: exclusive fixed
