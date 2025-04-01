[Tasks]
Name: "envpath"; Description: "{cm:AddToPathEnvironmentVariable}"
Name: "wtconfig"; Description: "{cm:IntegrateWithWindowsTerminal}"; Check: IsWindowsTerminalInstalled 
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1

[Run]
Filename: "{code:GetApplicationComponentGettingStartedFilePath}"; WorkingDir: "{code:GetApplicationMainPath}"; Flags: nowait postinstall skipifsilent shellexec; Description: "{cm:LaunchGettingStarted}"
Filename: "{code:GetApplicationComponentManagerFilePath}"; Parameters: "--home-dir ""{code:GetApplicationRootPath}"""; WorkingDir: "{code:GetApplicationMainPath}"; Flags: nowait postinstall skipifsilent unchecked; Description: "{cm:LaunchProgram,{#StringChange(FullAppManagerName, '&', '&&')}}"
Filename: "{code:GetApplicationComponentHelpFilePath}"; WorkingDir: "{code:GetApplicationMainPath}"; Flags: nowait postinstall skipifsilent unchecked shellexec; Description: "{cm:LaunchProgram,{#StringChange(MyAppNameHelp, '&', '&&')}}"
