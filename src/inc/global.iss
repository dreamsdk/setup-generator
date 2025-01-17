[Code]
type
  TEnvironmentFoundationKind = (
    efkUndefined,
    efkMinGWMSYS,
    efkMinGW64MSYS2
  );  

var
  Foundation: TEnvironmentFoundationKind;
  UninstallMode,
  WizardDirValueInitialized: Boolean;

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
