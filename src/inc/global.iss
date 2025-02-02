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

var  
  Foundation: TEnvironmentFoundationKind;
  UninstallMode,
  WizardDirValueInitialized: Boolean;
  ToolchainPackages: array of TToolchainPackage;
  SelectedToolchainPackage: Integer;

//=============================================================================
// FUNCTIONS
//=============================================================================

function IsUninstallMode: Boolean;
begin
  Result := UninstallMode;
end;

procedure SetUninstallMode(SelectedMode: Boolean);
begin
  UninstallMode := SelectedMode;
end;

function IsWizardDirValueInitialized: Boolean;
begin
  Result := WizardDirValueInitialized;
end;

procedure SetWizardDirValueInitialized(ValueInitialized: Boolean);
begin
  WizardDirValueInitialized := ValueInitialized;
end;

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

procedure SetFoundation(SelectedFoundation: TEnvironmentFoundationKind);
begin
  Foundation := SelectedFoundation;
  Log(Format('Initialized Foundation: IsFoundationMinGW64=%d, IsFoundationMinGW=%d', [
    IsFoundationMinGW64,
    IsFoundationMinGW                 
  ]));
end;

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
