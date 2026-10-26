[Code]
// Visual Studio Code and its forks: the same extension (.vsix) is installed in
// each selected editor, for all the users. Each editor has its own component
// ("ide\<id>"), and its identifier is the one used in the helper library (see
// VSCODE_EDITORS in the VSCTools unit).

const
  VSCODE_EXTENSION_FILE = '{code:GetApplicationPackagesPath}\ide\vscode\dreamsdk.vsix';
  VSCODE_CONFIGURATION_FILE = '{code:GetMsysInstallationPath}\etc\dreamsdk\ide.conf';

var
  VisualStudioCodeEditorIds,
  VisualStudioCodeEditorNames: TArrayOfString;
  VisualStudioCodeEditorDetected: array of Boolean;
  VisualStudioCodeDetectionDone: Boolean;

procedure InitializeVisualStudioCodeEditors();
begin
  if GetArrayLength(VisualStudioCodeEditorIds) > 0 then
    Exit;
  VisualStudioCodeEditorIds := ['vscode', 'vscodium'];
  VisualStudioCodeEditorNames := ['{#IdeVisualStudioCodeName}', '{#IdeVSCodiumName}'];
end;

function GetVisualStudioCodeComponentName(const EditorIndex: Integer): String;
begin
  Result := '{#IdeComponentsListName}\' + VisualStudioCodeEditorIds[EditorIndex];
end;

// The editors require Windows 10+: an editor component is only usable if the
// editor is detected (the result is cached, as it takes a while)
function IsVisualStudioCodeEditorAvailable(const EditorIndex: Integer): Boolean;
var
  i: Integer;

begin
  InitializeVisualStudioCodeEditors();
  if not VisualStudioCodeDetectionDone then
  begin
    SetArrayLength(VisualStudioCodeEditorDetected, GetArrayLength(VisualStudioCodeEditorIds));
    for i := 0 to GetArrayLength(VisualStudioCodeEditorIds) - 1 do
    begin
      VisualStudioCodeEditorDetected[i] := IsWindows10OrGreater()
        and (VSCodeDetectCli(VisualStudioCodeEditorIds[i]) <> '');
      Log(Format('IsVisualStudioCodeEditorAvailable: %s=%s (version: "%s")', [
        VisualStudioCodeEditorIds[i], BoolToStr(VisualStudioCodeEditorDetected[i]),
        VSCodeDetectVersion(VisualStudioCodeEditorIds[i])]));
    end;
    VisualStudioCodeDetectionDone := True;
  end;
  Result := VisualStudioCodeEditorDetected[EditorIndex];
end;

function IsVisualStudioCodeEditorIntegrationEnabled(const EditorIndex: Integer): Boolean;
begin
  Result := IsComponentSelected(GetVisualStudioCodeComponentName(EditorIndex))
    and IsVisualStudioCodeEditorAvailable(EditorIndex);
end;

// Disable the components of the editors that aren't available. The components
// can't be removed from the list (with MinVersion or Check), as the components
// names are retrieved from their index in the list (see ComponentsListName).
// This should be called before ComponentsListInitialize(False).
procedure SetVisualStudioCodeComponentState();
var
  i,
  ComponentIndex: Integer;

begin
  InitializeVisualStudioCodeEditors();
  for i := 0 to GetArrayLength(VisualStudioCodeEditorIds) - 1 do
    if not IsVisualStudioCodeEditorAvailable(i) then
    begin
      ComponentIndex := GetIndexComponent(GetVisualStudioCodeComponentName(i));
      Log(Format('SetVisualStudioCodeComponentState: disabling %s (component #%d)', [
        VisualStudioCodeEditorIds[i], ComponentIndex]));
      if ComponentIndex <> -1 then
      begin
        WizardForm.ComponentsList.Checked[ComponentIndex] := False;
        WizardForm.ComponentsList.ItemEnabled[ComponentIndex] := False;
      end;
    end;
  WizardForm.ComponentsList.Invalidate();
end;

procedure InstallVisualStudioCodeIntegration();
var
  i: Integer;
  ExtensionFileName: String;

begin
  InitializeVisualStudioCodeEditors();
  ExtensionFileName := ExpandConstant(VSCODE_EXTENSION_FILE);
  for i := 0 to GetArrayLength(VisualStudioCodeEditorIds) - 1 do
    if IsVisualStudioCodeEditorIntegrationEnabled(i) then
    begin
      Log(Format('InstallVisualStudioCodeIntegration: %s, "%s"', [
        VisualStudioCodeEditorIds[i], ExtensionFileName]));
      if not VSCodeInstallExtension(VisualStudioCodeEditorIds[i], ExtensionFileName) then
        MsgBox(FmtMessage(CustomMessage('VisualStudioCodeIntegrationSetupFailed'), [
          VisualStudioCodeEditorNames[i], VSCodeGetLastError()]), mbCriticalError, MB_OK);
    end;

  // Save the users having the extension (for all the editors, even if not
  // selected), as DreamSDK Manager can't read the other profiles when not
  // elevated
  for i := 0 to GetArrayLength(VisualStudioCodeEditorIds) - 1 do
    VSCodeRefreshInstalledUsers(VisualStudioCodeEditorIds[i],
      ExpandConstant(VSCODE_CONFIGURATION_FILE));
end;

// Remove the extension from all the editors and all the profiles. This is
// always done, as the extension may have been installed later with DreamSDK
// Manager, and this works even if the editor was uninstalled before DreamSDK.
procedure UninstallVisualStudioCodeIntegration();
var
  i: Integer;

begin
  InitializeVisualStudioCodeEditors();
  for i := 0 to GetArrayLength(VisualStudioCodeEditorIds) - 1 do
  begin
    Log(Format('UninstallVisualStudioCodeIntegration: %s', [VisualStudioCodeEditorIds[i]]));
    if not VSCodeRemoveExtension(VisualStudioCodeEditorIds[i]) then
      MsgBox(FmtMessage(CustomMessage('VisualStudioCodeIntegrationRemoveFailed'), [
        VisualStudioCodeEditorNames[i], VSCodeGetLastError()]), mbCriticalError, MB_OK);
  end;
end;
