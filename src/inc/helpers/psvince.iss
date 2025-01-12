// PSVince is a DLL to detect if a module is loaded in memory for Inno Setup
// Author: Vincenzo Giordano
// See: https://github.com/XhmikosR/psvince

#define PSVinceLibraryFileName "psvince.dll"
#define PSVinceLibraryUninstallFullPath "{app}\" + AppSupportDirectoryName + "\" + PSVinceLibraryFileName

[Code]

// function IsModuleLoaded to call at install time
// added also setuponly flag
// we can use the file directly from the Setup package
function IsModuleLoaded(ModuleName: String): Boolean;
external 'IsModuleLoaded@files:{#PSVinceLibraryFileName} stdcall setuponly';

// function IsModuleLoadedU to call at uninstall time
// added also uninstallonly flag
// we need to use the file from the disk
function IsModuleLoadedU(ModuleName: String): Boolean;
external 'IsModuleLoaded@{#PSVinceLibraryUninstallFullPath} stdcall uninstallonly';

// Check if a process is running
// This helper function uses PSVince
function IsProcessRunning(const ProcessName: String): Boolean;
begin
  if IsUninstallMode then
    Result := IsModuleLoadedU(ProcessName)
  else
    Result := IsModuleLoaded(ProcessName);
end;

// Prepare PSVince for deletion while uninstalling
procedure PSVinceUnload;
begin
  UnloadDLL(ExpandConstant('{#PSVinceLibraryUninstallFullPath}'));
end;
