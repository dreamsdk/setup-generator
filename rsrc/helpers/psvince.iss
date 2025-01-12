[Setup]
AppName=UninsPSVince
AppVerName=UninsPSVince
DisableProgramGroupPage=true
DisableStartupPrompt=true
DefaultDirName={pf}\UninsPSVince

[Files]
; dll used to check running notepad at install time
Source: psvince.dll; flags: dontcopy
;psvince is installed in {app} folder, so it will be
;loaded at uninstall time ;to check if notepad is running
Source: psvince.dll; DestDir: {app}

[Code]
// function IsModuleLoaded to call at install time
// added also setuponly flag
function IsModuleLoaded(modulename: String ):  Boolean;
external 'IsModuleLoaded@files:psvince.dll stdcall setuponly';

// function IsModuleLoadedU to call at uninstall time
// added also uninstallonly flag
function IsModuleLoadedU(modulename: String ):  Boolean;
external 'IsModuleLoaded@{app}\psvince.dll stdcall uninstallonly' ;


function InitializeSetup(): Boolean;
begin

  // check if notepad is running
  if IsModuleLoaded( 'notepad.exe' ) then
  begin
    MsgBox( 'Notepad is running, please close it and run again setup.',
             mbError, MB_OK );
    Result := false;
  end
  else Result := true;
end;

function InitializeUninstall(): Boolean;
begin

  // check if notepad is running
  if IsModuleLoadedU( 'notepad.exe' ) then
  begin
    MsgBox( 'Notepad is running, please close it and run again uninstall.',
             mbError, MB_OK );
    Result := false;
  end
  else Result := true;

  // Unload the DLL, otherwise the dll psvince is not deleted
  UnloadDLL(ExpandConstant('{app}\psvince.dll'));
end;
