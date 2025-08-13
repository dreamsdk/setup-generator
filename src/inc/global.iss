[Code]
type
  TEnvironmentFoundationKind = (
    efkUndefined,
    efkMinGWMSYS,
    efkMinGW64MSYS2
  );
  
  TShellKind = (
    skUndefined,
    skWindows,
    skMinTTY
  );

  TToolchainPackage = record
    ComponentsListItemIndex: Integer;
    Name: String;
    Description: String;
    IsWindows64: Boolean;
  end;
  TToolchainPackageArray = array of TToolchainPackage;
  
  TGdbPackage = record
    ComponentsListItemIndex: Integer;
    Name: String;
    Version: String;
    IsWindows64: Boolean;
    IsPythonRuntimeInstalled: Boolean;
  end;
  TGdbPackageArray = array of TGdbPackage;

var
  Foundation: TEnvironmentFoundationKind;
  PreviousFoundation: TEnvironmentFoundationKind;

  UninstallMode,
  WizardDirValueInitialized: Boolean;  
  
  // Toolchains
  Toolchain32Packages: TToolchainPackageArray;
  Toolchain64Packages: TToolchainPackageArray;
  SelectedToolchainPackage: Integer;
  
  // GDB
  Gdb32Packages: TGdbPackageArray;
  Gdb32Version: String;
  Gdb64Packages: TGdbPackageArray;
  Gdb64Version: String;
  SelectedGdbPackage: Integer;

  // Shell
  Shell: TShellKind;

//=============================================================================
// UNINSTALL MODE
//=============================================================================

function IsUninstallMode(): Boolean;
begin
  Result := UninstallMode;
end;

procedure SetUninstallMode(SelectedMode: Boolean);
begin
  UninstallMode := SelectedMode;
end;

//=============================================================================
// WIZARD DIR VALUE INITIALIZED
//=============================================================================

function IsWizardDirValueInitialized: Boolean;
begin
  Result := WizardDirValueInitialized;
end;

procedure SetWizardDirValueInitialized(ValueInitialized: Boolean);
begin
  WizardDirValueInitialized := ValueInitialized;
end;

//=============================================================================
// FOUNDATION
//=============================================================================

function IsFoundationPossibleMinGW64: Boolean;
begin
  Result := IsWindows10OrGreater;
end;

function IsFoundationMinGW64: Boolean;
begin
  Result := IsFoundationPossibleMinGW64 and (Foundation = efkMinGW64MSYS2);
end;

function IsFoundationMinGW: Boolean;
begin
  Result := (Foundation = efkMinGWMSYS) or (not IsFoundationPossibleMinGW64);
end;

function IsFoundationChanged: Boolean;
begin
  Result := (PreviousFoundation <> efkUndefined)
    and (PreviousFoundation <> Foundation); 
end;

procedure SetFoundation(SelectedFoundation: TEnvironmentFoundationKind);
begin  
  PreviousFoundation := Foundation;
  Foundation := SelectedFoundation;

  Log(Format('Initialized Foundation: IsFoundationMinGW64=%d, IsFoundationMinGW=%d', [
    IsFoundationMinGW64,
    IsFoundationMinGW
  ]));
end;

procedure ValidateFoundation();
begin
  // Don't consider that we changed foundation anymore
  PreviousFoundation := Foundation;
  
  Log(Format('ValidateFoundation: %d', [
    Foundation
  ]));
end;

//=============================================================================
// TOOLCHAINS
//=============================================================================

procedure InitializeToolchain32Packages(const ItemsCount: Integer);
var
  i: Integer;

begin
  SetArrayLength(Toolchain32Packages, ItemsCount);
  for i := Low(Toolchain32Packages) to High(Toolchain32Packages) do
  begin
    Toolchain32Packages[i].Name := sEmptyStr;
    Toolchain32Packages[i].IsWindows64 := False;
    Toolchain32Packages[i].ComponentsListItemIndex := -1;
  end;
end;

procedure InitializeToolchain64Packages(const ItemsCount: Integer);
var
  i: Integer;

begin
  SetArrayLength(Toolchain64Packages, ItemsCount);
  for i := Low(Toolchain64Packages) to High(Toolchain64Packages) do
  begin
    Toolchain64Packages[i].Name := sEmptyStr;
    Toolchain64Packages[i].IsWindows64 := True;
    Toolchain64Packages[i].ComponentsListItemIndex := -1;
  end;
end;

function GetToolchainPackagesList(var ToolchainPackages: TToolchainPackageArray): Boolean;
begin
  Result := True;
  ToolchainPackages := Toolchain32Packages;
  if IsFoundationMinGW64 then
    ToolchainPackages := Toolchain64Packages;
end;

function IsSelectedToolchain(): Boolean;
var
  ToolchainPackages: TToolchainPackageArray;
   
begin
  Result := False;
  if GetToolchainPackagesList(ToolchainPackages) then
    Result := (SelectedToolchainPackage >= Low(ToolchainPackages)) and
      (SelectedToolchainPackage <= High(ToolchainPackages));
end;

function GetSelectedToolchain(): Integer;
begin
  Result := -1;
  if IsSelectedToolchain then
    Result := SelectedToolchainPackage;
end;

function GetSelectedToolchainPackage(
  var SelectedToolchainPackage: TToolchainPackage): Boolean;
var
  ToolchainPackages: TToolchainPackageArray;
  ItemIndex: Integer;

begin
  ItemIndex := GetSelectedToolchain();
  Result := (ItemIndex <> -1);
  if Result then
  begin
    GetToolchainPackagesList(ToolchainPackages); 
    SelectedToolchainPackage := ToolchainPackages[ItemIndex];
  end;
end;

function SetSelectedToolchain(ToolchainProfileIndex: Integer): Boolean;
var
  ToolchainPackages: TToolchainPackageArray;
  SelectedToolchainName: String;  
   
begin
  Result := GetToolchainPackagesList(ToolchainPackages);
  if Result then
  begin
    SelectedToolchainName := '(Undefined)';
    SelectedToolchainPackage := ToolchainProfileIndex;
    Result := IsSelectedToolchain;

    // Check with IsSelectedToolchain
    if Result then
      // Index is valid, we can retrieve the profile name
      SelectedToolchainName := ToolchainPackages[ToolchainProfileIndex].Name  
    else  
      // Reset index, has we can't select the correct item
      SelectedToolchainPackage := -1;  

    Log(Format('SelectedToolchain: "%s" (index=%d)', [
      SelectedToolchainName, 
      ToolchainProfileIndex
    ]));
  end;
end;

//=============================================================================
// GDB
//=============================================================================

procedure InitializeGdb32Packages(const ItemsCount: Integer;
  const GdbVersion: String);
var
  i: Integer;

begin
  Gdb32Version := GdbVersion;
  SetArrayLength(Gdb32Packages, ItemsCount);
  for i := Low(Gdb32Packages) to High(Gdb32Packages) do
  begin
    Gdb32Packages[i].Name := sEmptyStr;
    Gdb32Packages[i].IsWindows64 := False;
    Gdb32Packages[i].ComponentsListItemIndex := -1;
  end;
end;

procedure InitializeGdb64Packages(const ItemsCount: Integer;
  const GdbVersion: String);
var
  i: Integer;

begin
  Gdb64Version := GdbVersion;
  SetArrayLength(Gdb64Packages, ItemsCount);
  for i := Low(Gdb64Packages) to High(Gdb64Packages) do
  begin
    Gdb64Packages[i].Name := sEmptyStr;
    Gdb64Packages[i].IsWindows64 := True;
    Gdb64Packages[i].ComponentsListItemIndex := -1;
  end;
end;

function GetGdbPackagesList(var GdbPackages: TGdbPackageArray): Boolean;
begin
  Result := True;
  GdbPackages := Gdb32Packages;
  if IsFoundationMinGW64 then
    GdbPackages := Gdb64Packages;
end;

function GetGdbSelectedVersion: String;
begin
  Result := Gdb32Version;
  if IsFoundationMinGW64 then 
    Result := Gdb64Version;
  Result := Trim(Result); 
end;

function IsSelectedGdb(): Boolean;
var
  GdbPackages: TGdbPackageArray;
  
begin
  Result := False;
  if GetGdbPackagesList(GdbPackages) then
    Result := (SelectedGdbPackage >= Low(GdbPackages)) and
      (SelectedGdbPackage <= High(GdbPackages));
end;

function GetSelectedGdb(): Integer;
begin
  Result := -1;
  if IsSelectedGdb then
    Result := SelectedGdbPackage;
end;

function GetSelectedGdbPackage(var SelectedGdbPackage: TGdbPackage): Boolean;
var
  GdbPackages: TGdbPackageArray;
  ItemIndex: Integer;

begin
  ItemIndex := GetSelectedGdb();
  Result := (ItemIndex <> -1);
  if Result then
  begin
    GetGdbPackagesList(GdbPackages); 
    SelectedGdbPackage := GdbPackages[ItemIndex];
  end;
end;

function SetSelectedGdb(GdbPackageIndex: Integer): Boolean;
var
  GdbPackages: TGdbPackageArray;
  SelectedGdbName: String;
  
begin
  Result := GetGdbPackagesList(GdbPackages);
  if Result then
  begin
    SelectedGdbName := '(Undefined)';
    SelectedGdbPackage := GdbPackageIndex;
    Result := IsSelectedGdb;

    // Check with IsSelectedGdb
    if Result then
      // Index is valid, we can retrieve the profile name
      SelectedGdbName := GdbPackages[GdbPackageIndex].Name  
    else  
      // Reset index, has we can't select the correct item
      SelectedGdbPackage := -1;  

    Log(Format('SelectedGdb [%s]: "%s" (index=%d)', [
      BoolToStrCustom(IsFoundationMinGW64, 'x64', 'x86'),
      SelectedGdbName, 
      GdbPackageIndex
    ]));
  end;
end;

//=============================================================================
// Shell/Terminal
//=============================================================================

function IsShellMinTTY: Boolean;
begin
  Result := (Shell = skMinTTY);
end;

procedure SetShell(SelectedShell: TShellKind);
begin
  Shell := SelectedShell;

  Log(Format('SelectedShell: %s', [
    BoolToStrCustom(IsShellMinTTY, 'MinTTY', 'Windows Command Prompt/Windows Terminal')
  ]));
end;

