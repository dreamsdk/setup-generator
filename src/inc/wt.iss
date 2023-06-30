[Code]
type
  TWindowsTerminalIntegrationOperation = (wtiInstall, wtiUninstall);

const    
  WT_CONFIG_FILE = '{app}\msys\1.0\opt\dreamsdk\helpers\wtconfig.exe';

function RunWindowsTerminalConfigTool(
  const Operation: TWindowsTerminalIntegrationOperation;
  var Buffer: String): Boolean;
var
  UtilitySwitch: string;

begin
  UtilitySwitch := 'uninstall';
  if Operation = wtiInstall then
    UtilitySwitch := 'install';

  Buffer := RunCommand(
    Format('"%s" %s', [
      ExpandConstant(WT_CONFIG_FILE),
      UtilitySwitch
    ]),
    False
  );
            
  Result := IsInString('done successfully', Buffer);
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
  IsSuccess := RunWindowsTerminalConfigTool(wtiUninstall, Buffer);
  if not IsSuccess then
    MsgBox(Format(CustomMessage('WindowsTerminalIntegrationUninstallationFailed'), [Buffer]), mbCriticalError, MB_OK); 
end;
