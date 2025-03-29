#define HelperLibraryFileName "dreamsdk.dll"
#define HelperLibraryUninstallFullPath "{app}\" + AppSupportDirectoryName + "\" + HelperLibraryFileName

[Code]

type
  TPortableExecutableBitness = (pebUnknown, peb16, peb32, peb64); 

const
  HELPER_LIBRARY_BUFFER_SPLIT_CHAR = '|';
  HELPER_LIBRARY_BUFFER_SIZE_SMALL = 4096;    // 4 KB
  HELPER_LIBRARY_BUFFER_SIZE_LARGE = 131072;  // 128 KB  

// ============================================================================
// SYSTEM FUNCTIONS
// ============================================================================

// Prepare the helper library for deletion while uninstalling
procedure HelperLibraryUnload;
begin
  UnloadDLL(ExpandConstant('{#HelperLibraryUninstallFullPath}'));
end;

// ============================================================================
// IMPORTS
// ============================================================================

function IsWindowsTerminalInstalledSetup: Boolean;
external 'IsWindowsTerminalInstalledA@files:{#HelperLibraryFileName} stdcall setuponly';

function IsWindowsTerminalInstalledUninstall: Boolean;
external 'IsWindowsTerminalInstalledA@{#HelperLibraryUninstallFullPath} stdcall uninstallonly';

function GetFileLocationsInSystemPathSetup(const lpFileName: AnsiString;
  const lpDelimiter: AnsiChar; lpPathFileNames: AnsiString;
  const uBufferMaxSize: Cardinal): Cardinal;   
external 'GetFileLocationsInSystemPathA@files:{#HelperLibraryFileName} stdcall setuponly';

function GetFileLocationsInSystemPathUninstall(const lpFileName: AnsiString;
  const lpDelimiter: AnsiChar; lpPathFileNames: AnsiString;
  const uBufferMaxSize: Cardinal): Cardinal; 
external 'GetFileLocationsInSystemPathA@{#HelperLibraryUninstallFullPath} stdcall uninstallonly';

function RenameFileOrDirectoryAsBackupSetup(
  const OldDirectoryFullPath: AnsiString): Boolean;
external 'RenameFileOrDirectoryAsBackupA@files:{#HelperLibraryFileName} stdcall setuponly';

function RenameFileOrDirectoryAsBackupUninstall(
  const OldDirectoryFullPath: AnsiString): Boolean;
external 'RenameFileOrDirectoryAsBackupA@{#HelperLibraryUninstallFullPath} stdcall uninstallonly';

function GetPortableExecutableBitnessSetup(const FileName: AnsiString): Byte; 
external 'GetPortableExecutableBitnessA@files:{#HelperLibraryFileName} stdcall setuponly';

function GetPortableExecutableBitnessUninstall(const FileName: AnsiString): Byte; 
external 'GetPortableExecutableBitnessA@{#HelperLibraryUninstallFullPath} stdcall uninstallonly';

function CodeBlocksGetAvailableUsersSetup(const lpDelimiter: AnsiChar;
  lpAvailableUsers: AnsiString; const uBufferMaxSize: Cardinal): Cardinal;
external 'CodeBlocksGetAvailableUsersA@files:{#HelperLibraryFileName} stdcall setuponly';

function CodeBlocksGetAvailableUsersUninstall(const lpDelimiter: AnsiChar;
  lpAvailableUsers: AnsiString; const uBufferMaxSize: Cardinal): Cardinal;
external 'CodeBlocksGetAvailableUsersA@{#HelperLibraryUninstallFullPath} stdcall uninstallonly';

function CodeBlocksRemoveProfilesSetup: Boolean;
external 'CodeBlocksRemoveProfilesA@files:{#HelperLibraryFileName} stdcall setuponly';

function CodeBlocksRemoveProfilesUninstall: Boolean;
external 'CodeBlocksRemoveProfilesA@{#HelperLibraryUninstallFullPath} stdcall uninstallonly';

function CodeBlocksDetectInstallationPathSetup(lpInstallationPath: AnsiString;
  const uBufferMaxSize: Cardinal): Cardinal;
external 'CodeBlocksDetectInstallationPathA@files:{#HelperLibraryFileName} stdcall setuponly';

function CodeBlocksDetectInstallationPathUninstall(lpInstallationPath: AnsiString;
  const uBufferMaxSize: Cardinal): Cardinal;
external 'CodeBlocksDetectInstallationPathA@{#HelperLibraryUninstallFullPath} stdcall uninstallonly';

function CodeBlocksDetectVersionSetup(const lpCodeBlocksInstallationDirectory: AnsiString;
  lpCodeBlockVersion: AnsiString; const uBufferMaxSize: Cardinal): Cardinal;
external 'CodeBlocksDetectVersionA@files:{#HelperLibraryFileName} stdcall setuponly';

function CodeBlocksDetectVersionUninstall(const lpCodeBlocksInstallationDirectory: AnsiString;
  lpCodeBlockVersion: AnsiString; const uBufferMaxSize: Cardinal): Cardinal;
external 'CodeBlocksDetectVersionA@{#HelperLibraryUninstallFullPath} stdcall uninstallonly';

procedure CodeBlocksInitializeProfilesSetup;
external 'CodeBlocksInitializeProfilesA@files:{#HelperLibraryFileName} stdcall setuponly';

procedure CodeBlocksInitializeProfilesUninstall;
external 'CodeBlocksInitializeProfilesA@{#HelperLibraryUninstallFullPath} stdcall uninstallonly';

// ============================================================================
// GENERIC EXPOSED FUNCTIONS
// ============================================================================

function IsWindowsTerminalInstalled(): Boolean;
begin
  if IsUninstallMode() then
    Result := IsWindowsTerminalInstalledUninstall()
  else
    Result := IsWindowsTerminalInstalledSetup();
  Log(Format('IsWindowsTerminalInstalled: %s', [BoolToStr(Result)]));
end;           

function GetFileLocationsInSystemPath(const FileName: String;
  var OutputPathList: TArrayOfString): Boolean;
var
  Buffer: AnsiString;
  BufferSize: Cardinal;
  Output: String;

begin
  SetLength(Buffer, HELPER_LIBRARY_BUFFER_SIZE_LARGE);
  if IsUninstallMode() then
    BufferSize := GetFileLocationsInSystemPathUninstall(FileName,
      HELPER_LIBRARY_BUFFER_SPLIT_CHAR, Buffer, HELPER_LIBRARY_BUFFER_SIZE_LARGE) 
  else
    BufferSize := GetFileLocationsInSystemPathSetup(FileName,
      HELPER_LIBRARY_BUFFER_SPLIT_CHAR, Buffer, HELPER_LIBRARY_BUFFER_SIZE_LARGE);
  SetLength(Buffer, BufferSize);
  Output := Copy(Buffer, 1, Length(Buffer));
  Result := Length(Output) > 0;
  if Result then
    Explode(OutputPathList, Output, HELPER_LIBRARY_BUFFER_SPLIT_CHAR);
end;

function RenameFileOrDirectoryAsBackup(const TargetFileOrDirectory: String): Boolean;
begin
  if IsUninstallMode() then
    Result := RenameFileOrDirectoryAsBackupUninstall(TargetFileOrDirectory)
  else
    Result := RenameFileOrDirectoryAsBackupSetup(TargetFileOrDirectory);
  Log(Format('RenameFileOrDirectoryAsBackup: "%s", result=%s', [
    TargetFileOrDirectory, BoolToStr(Result)]));  
end;

function GetPortableExecutableBitness(const FileName: String): TPortableExecutableBitness;
var
  Buffer: Byte;

begin
  if IsUninstallMode() then
    Buffer := GetPortableExecutableBitnessUninstall(FileName)
  else
    Buffer := GetPortableExecutableBitnessSetup(FileName);
  Result := TPortableExecutableBitness(Buffer);
end;

function PortableExecutableBitnessToString(E: TPortableExecutableBitness): String;
var
  Values: TArrayOfString;

begin
  Values := ['pebUnknown', 'peb16', 'peb32', 'peb64'];
  Result := Values[Ord(E)];
end;

// ============================================================================
// CODE::BLOCKS EXPOSED FUNCTIONS
// ============================================================================

function CodeBlocksGetAvailableUsers(var AvailableUsers: TArrayOfString): Boolean;
var
  Buffer: AnsiString;
  BufferSize: Cardinal;
  Output: String;

begin
  SetLength(Buffer, HELPER_LIBRARY_BUFFER_SIZE_LARGE);
  if IsUninstallMode() then
    BufferSize := CodeBlocksGetAvailableUsersUninstall(
      HELPER_LIBRARY_BUFFER_SPLIT_CHAR, Buffer, HELPER_LIBRARY_BUFFER_SIZE_LARGE)
  else
    BufferSize := CodeBlocksGetAvailableUsersSetup(
      HELPER_LIBRARY_BUFFER_SPLIT_CHAR, Buffer, HELPER_LIBRARY_BUFFER_SIZE_LARGE);
  SetLength(Buffer, BufferSize);
  Output := Copy(Buffer, 1, Length(Buffer)); 
  Result := Length(Output) > 0; 
  if Result then
    Explode(AvailableUsers, Output, HELPER_LIBRARY_BUFFER_SPLIT_CHAR);
end;

function CodeBlocksRemoveProfiles(): Boolean;
begin
  if IsUninstallMode() then
    Result := CodeBlocksRemoveProfilesUninstall()
  else
    Result := CodeBlocksRemoveProfilesSetup();
end;

function CodeBlocksDetectInstallationPath(): String;
var
  Buffer: AnsiString;
  BufferSize: Cardinal;

begin
  SetLength(Buffer, HELPER_LIBRARY_BUFFER_SIZE_SMALL);
  if IsUninstallMode() then
    BufferSize := CodeBlocksDetectInstallationPathUninstall(Buffer,
      HELPER_LIBRARY_BUFFER_SIZE_SMALL)
  else
    BufferSize := CodeBlocksDetectInstallationPathSetup(Buffer,
      HELPER_LIBRARY_BUFFER_SIZE_SMALL);
  SetLength(Buffer, BufferSize);
  Result := Copy(Buffer, 1, Length(Buffer));
end;

function CodeBlocksDetectVersion(CodeBlocksInstallationPath: String): String;
var
  Buffer: AnsiString;
  BufferSize: Cardinal;

begin
  SetLength(Buffer, HELPER_LIBRARY_BUFFER_SIZE_SMALL);
  if IsUninstallMode() then
    BufferSize := CodeBlocksDetectVersionUninstall(CodeBlocksInstallationPath, 
      Buffer, HELPER_LIBRARY_BUFFER_SIZE_SMALL)
  else
    BufferSize := CodeBlocksDetectVersionSetup(CodeBlocksInstallationPath, 
      Buffer, HELPER_LIBRARY_BUFFER_SIZE_SMALL);
  SetLength(Buffer, BufferSize);
  Result := Copy(Buffer, 1, Length(Buffer));
end;

procedure CodeBlocksInitializeProfiles();
begin
  if IsUninstallMode() then
    CodeBlocksInitializeProfilesUninstall()
  else
    CodeBlocksInitializeProfilesSetup();
end;
