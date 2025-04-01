[Code]
type
  TWindowsTerminalIntegrationOperation = (wtiInstall, wtiUninstall, wtiStatus);

const  
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
    Format('"%s" %s --home-dir "%s"', [
      ExpandConstant(WT_CONFIG_FILE),
      UtilitySwitch,
      ExpandConstant('{code:GetApplicationRootPath}')
    ]),
    False
  );
            
  Result := not IsInString('Error: ', Buffer);
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
