[Code]
type
  TEnvironmentFoundationKind = (
    efkUndefined,
    efkMinGWMSYS,
    efkMinGW64MSYS2
  );  

type
  TToolchainPackage = record
    Name: String;
    Description: String;
    IsModernWindowsOnly: Boolean;
    ComponentsListItemIndex: Integer;
  end;
  TToolchainPackageArray = array of TToolchainPackage;
  
  TGdbPackage = record
    Name: String;
    Version: String;
    IsPythonRuntimeInstalled: Boolean;
    ComponentsListItemIndex: Integer;
  end;
  TGdbPackageArray = array of TGdbPackage;

var
  Foundation: TEnvironmentFoundationKind;
  PreviousFoundation: TEnvironmentFoundationKind;

  UninstallMode,
  WizardDirValueInitialized: Boolean;  
  
  // Toolchains
  ToolchainPackages: TToolchainPackageArray;
  SelectedToolchainPackage: Integer;
  
  // GDB
  Gdb32Packages: TGdbPackageArray;
  Gdb64Packages: TGdbPackageArray;
  SelectedGdbPackage: Integer;

//=============================================================================
// UNINSTALL MODE
//=============================================================================

function IsUninstallMode: Boolean;
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
  Result := (PreviousFoundation <> Foundation); 
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

//=============================================================================
// TOOLCHAINS
//=============================================================================

function IsSelectedToolchain(): Boolean;
begin
  Result := (SelectedToolchainPackage >= Low(ToolchainPackages)) and
    (SelectedToolchainPackage <= High(ToolchainPackages));
end;

function GetSelectedToolchain(): Integer;
begin
  Result := -1;
  if IsSelectedToolchain then
    Result := SelectedToolchainPackage;
end;

function SetSelectedToolchain(ToolchainProfileIndex: Integer): Boolean;
var
  SelectedToolchainName: String;

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

//=============================================================================
// GDB
//=============================================================================

procedure InitializeGdb32Packages(const ItemsCount: Integer);
var
  i: Integer;

begin
  SetArrayLength(Gdb32Packages, ItemsCount);
  for i := Low(Gdb32Packages) to High(Gdb32Packages) do
  begin
    Gdb32Packages[i].Name := sEmptyStr;
    Gdb32Packages[i].ComponentsListItemIndex := -1;
  end;
end;

procedure InitializeGdb64Packages(const ItemsCount: Integer);
var
  i: Integer;

begin
  SetArrayLength(Gdb64Packages, ItemsCount);
  for i := Low(Gdb64Packages) to High(Gdb64Packages) do
  begin
    Gdb64Packages[i].Name := sEmptyStr;
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
