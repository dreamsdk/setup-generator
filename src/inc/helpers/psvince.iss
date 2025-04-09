// PSVince is a DLL to detect if a module is loaded in memory for Inno Setup
// Author: Vincenzo Giordano
// See: https://github.com/XhmikosR/psvince

#define PSVinceLibraryFileName "psvince.dll"
#define PSVinceLibraryUninstallFullPath "{app}\" + AppSupportDirectoryName + "\" + PSVinceLibraryFileName

[Files]
Source: "..\rsrc\helpers\{#PSVinceLibraryFileName}"; DestDir: "{code:GetApplicationSupportPath}"; Flags: ignoreversion noencryption nocompression

[Code]

// ============================================================================
// SYSTEM FUNCTIONS
// ============================================================================

// Prepare PSVince for deletion while uninstalling
procedure PSVinceUnload;
begin
  UnloadDLL(ExpandConstant('{#PSVinceLibraryUninstallFullPath}'));
end;

// ============================================================================
// IMPORTS
// ============================================================================

// function IsModuleLoaded to call at install time
// added also setuponly flag
// we can use the file directly from the Setup package
function IsModuleLoadedSetup(ModuleName: String): Boolean;
external 'IsModuleLoaded@files:{#PSVinceLibraryFileName} stdcall setuponly';

// function IsModuleLoadedU to call at uninstall time
// added also uninstallonly flag
// we need to use the file from the disk
function IsModuleLoadedUninstall(ModuleName: String): Boolean;
external 'IsModuleLoaded@{#PSVinceLibraryUninstallFullPath} stdcall uninstallonly';

// ============================================================================
// EXPOSED FUNCTIONS
// ============================================================================

// Check if a process is running
// This helper function uses PSVince
function IsProcessRunning(const ProcessName: String): Boolean;
begin
  if IsUninstallMode() then
    Result := IsModuleLoadedUninstall(ProcessName)
  else
    Result := IsModuleLoadedSetup(ProcessName);
end;
