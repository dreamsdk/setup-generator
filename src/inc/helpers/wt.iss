[Code]
type
  TWindowsTerminalIntegrationOperation = (wtiInstall, wtiUninstall, wtiStatus);

const
  WT_HELPER_FILE = 'wtcheck.exe';    
  WT_CONFIG_FILE = '{code:GetApplicationHelpersPath}\wtconfig.exe';

function RunWindowsTerminalConfigTool(
  const Operation: TWindowsTerminalIntegrationOperation;
  var Buffer: String): Boolean;
var
  UtilitySwitch: string;

begin
  UtilitySwitch := 'uninstall';
  if Operation = wtiInstall then
    UtilitySwitch := 'install'
  else if Operation = wtiStatus then
    UtilitySwitch := 'status';

  Buffer := RunCommand(
    Format('"%s" %s', [
      ExpandConstant(WT_CONFIG_FILE),
      UtilitySwitch
    ]),
    False
  );
            
  Result := not IsInString('Error: ', Buffer);
end;

function IsWindowsTerminalInstalled: Boolean;
var
  WindowsTerminalHelperFileName: String;
  Buffer: String;

begin
  if IsUninstallMode then
    Result := RunWindowsTerminalConfigTool(wtiStatus, Buffer)
  else
  begin
    WindowsTerminalHelperFileName := ExpandConstant('{tmp}\' + WT_HELPER_FILE);
    if not FileExists(WindowsTerminalHelperFileName) then
      ExtractTemporaryFile(WT_HELPER_FILE);
    Buffer := RunCommand(WindowsTerminalHelperFileName, True);
    Result := not IsInString('Error: ', Buffer); 
  end;
end;

procedure InstallWindowsTerminalIntegration;
var
  Buffer: String;
  IsSuccess: Boolean;

begin      
  IsSuccess := RunWindowsTerminalConfigTool(wtiInstall, Buffer);
  if not IsSuccess then
    MsgBox(Format(CustomMessage('WindowsTerminalIntegrationInstallationFailed'), [Buffer]), mbCriticalError, MB_OK);
end;

procedure UninstallWindowsTerminalIntegration;
var
  Buffer: String;
  IsSuccess: Boolean;

begin  
  if IsWindowsTerminalInstalled then
  begin
    IsSuccess := RunWindowsTerminalConfigTool(wtiUninstall, Buffer);
    if not IsSuccess then
      MsgBox(Format(CustomMessage('WindowsTerminalIntegrationUninstallationFailed'), [Buffer]), mbCriticalError, MB_OK); 
  end;
end;
