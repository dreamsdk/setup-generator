; PSVince is a DLL to detect if a module is loaded in memory for Inno Setup
; Author: Vincenzo Giordano
; See: https://github.com/XhmikosR/psvince

#define PSVinceLibraryFileName "psvince.dll"
#define PSVinceLibrary "{app}\" + AppSupportDirectory + "\" + PSVinceLibraryFileName

[Code]
function IsModuleLoaded(ModuleName: AnsiString): Boolean;
external 'IsModuleLoaded@files:{#PSVinceLibraryFileName} stdcall';

function IsModuleLoadedU(ModuleName: String): Boolean;
external 'IsModuleLoaded@{#PSVinceLibrary} stdcall uninstallonly';
