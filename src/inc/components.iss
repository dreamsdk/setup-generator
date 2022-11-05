[Code]

var
  ComponentsListName: TArrayOfString;

// Get how many components are selected
// Thanks to: https://stackoverflow.com/a/44324787/3726096
function GetSelectedComponentsCount: Integer;
var
  S: TStringList;
begin
  S := TStringList.Create;
  try
    S.CommaText := WizardSelectedComponents(False);
    Result := S.Count;
  finally
    S.Free;
  end;
end;

function GetComponentsListCount: Integer;
begin
  Result := WizardForm.ComponentsList.Items.Count;
end;

function GetComponentsListDisabledItemsCount: Integer;
var
  i: Integer;

begin
  Result := 0;
  for i := 0 to GetComponentsListCount - 1 do
  begin
    if not WizardForm.ComponentsList.ItemEnabled[i] then
      Inc(Result);
  end;
  Log(Format('Disabled ComponentsList Count: %d', [Result]));
end;

// Rebuild ComponentsList names
// Thanks to: https://stackoverflow.com/a/29301192/3726096
procedure InitializeComponentsListNames;
var
  i: Integer;
  CheckBack: array of Boolean;

begin
  // Check if already loaded: if yes, exit
  if GetArrayLength(ComponentsListName) > 0 then
    Exit;

  SetArrayLength(CheckBack, GetComponentsListCount);

  for i := 0 to GetComponentsListCount - 1 do
  begin
    // Saves state in CheckBack
    CheckBack[i] := WizardForm.ComponentsList.Checked[i];

    // Only checks non checked components
    if (not CheckBack[i]) then
      WizardForm.ComponentsList.Checked[i] := True;
  end;

  // Saves components names in ComponentsName array
  ComponentsListName := Split(WizardSelectedComponents(False), ',');

  // Unchecks components that was uncheck previouly.
  // If we try to check a checked component it may crash the Inno program (tested)
  for i := 0 to GetComponentsListCount - 1 do
  begin
    if (not CheckBack[i]) then
      WizardForm.ComponentsList.Checked[i] := False;
  end;

  // LOG components name.
  Log('ComponentsList Names:');
  for i := 0 to GetArrayLength(ComponentsListName) - 1 do
  begin
    Log(Format('  - %s', [ComponentsListName[i]]));
  end;
end;

// Returns component name by index
function GetComponentName(Index: Integer): String;
begin
  Result := sEmptyStr;
  if (Index >= 0) and (Index < GetArrayLength(ComponentsListName)) then
    Result := ComponentsListName[Index];
end;

// Returns Index component by Name. 
// -1 if ComponentName doesn't exist.
function GetIndexComponent(ComponentName: String): Integer;
var
  i: Integer;

begin
  Result := -1;
  for i := 0 to GetArrayLength(ComponentsListName) - 1 do
  begin
    if (ComponentName = ComponentsListName[i]) then
    begin
      Result := i;
      Break;
    end;
  end;
end;

// Used to count of many Components we have for that root level 
function GetComponentRootLevelItemsCount(ComponentRootLevelName: String): Integer;
var
  i: Integer;
  ComponentName: String;

begin
  Result := 0;

  for i := 0 to GetComponentsListCount - 1 do
  begin
    ComponentName := GetComponentName(i);    
    if (ComponentName = ComponentRootLevelName) or (Left('\', ComponentName) = ComponentRootLevelName) then
      Inc(Result);
  end;

  Log(Format('GetComponentRootLevelItemsCount for \"%s\": %d item(s) found', [
    ComponentRootLevelName,
    Result
  ]));
end;
