#define CommonHelperLibraryFileName "common.dll"
#define CommonHelperLibraryUninstallFullPath "{app}\" + AppSupportDirectoryName + "\" + CommonHelperLibraryFileName

#define CodeBlocksHelperLibraryFileName "cbhelper.dll"
#define CodeBlocksHelperLibraryUninstallFullPath "{app}\" + AppSupportDirectoryName + "\" + CodeBlocksHelperLibraryFileName

[Files]
Source: "..\.helpers\{#CommonHelperLibraryFileName}"; DestDir: "{code:GetApplicationSupportPath}"; Flags: ignoreversion noencryption nocompression
Source: "..\.helpers\{#CodeBlocksHelperLibraryFileName}"; DestDir: "{code:GetApplicationSupportPath}"; Flags: ignoreversion noencryption nocompression

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
  UnloadDLL(ExpandConstant('{#CommonHelperLibraryUninstallFullPath}'));
  UnloadDLL(ExpandConstant('{#CodeBlocksHelperLibraryUninstallFullPath}'));
end;

// ============================================================================
// IMPORTS FROM LIBRARY // COMMON
// ============================================================================

function IsWindowsTerminalInstalledSetup: Boolean;
external 'IsWindowsTerminalInstalled@files:{#CommonHelperLibraryFileName} stdcall setuponly';

function IsWindowsTerminalInstalledUninstall: Boolean;
external 'IsWindowsTerminalInstalled@{#CommonHelperLibraryUninstallFullPath} stdcall uninstallonly';

function GetFileLocationsInSystemPathSetup(const lpFileName: String;
  const lpDelimiter: AnsiChar; lpPathFileNames: String;
  const uBufferMaxSize: Cardinal): Cardinal;   
external 'GetFileLocationsInSystemPathW@files:{#CommonHelperLibraryFileName} stdcall setuponly';

function GetFileLocationsInSystemPathUninstall(const lpFileName: String;
  const lpDelimiter: AnsiChar; lpPathFileNames: String;
  const uBufferMaxSize: Cardinal): Cardinal; 
external 'GetFileLocationsInSystemPathW@{#CommonHelperLibraryUninstallFullPath} stdcall uninstallonly';

function RenameFileOrDirectoryAsBackupSetup(
  const OldDirectoryFullPath: String): Boolean;
external 'RenameFileOrDirectoryAsBackupW@files:{#CommonHelperLibraryFileName} stdcall setuponly';

function RenameFileOrDirectoryAsBackupUninstall(
  const OldDirectoryFullPath: String): Boolean;
external 'RenameFileOrDirectoryAsBackupW@{#CommonHelperLibraryUninstallFullPath} stdcall uninstallonly';

function GetPortableExecutableBitnessSetup(const FileName: String): Byte; 
external 'GetPortableExecutableBitnessW@files:{#CommonHelperLibraryFileName} stdcall setuponly';

function GetPortableExecutableBitnessUninstall(const FileName: String): Byte; 
external 'GetPortableExecutableBitnessW@{#CommonHelperLibraryUninstallFullPath} stdcall uninstallonly';

// ============================================================================
// EXPOSED FUNCTIONS // COMMON
// ============================================================================

function IsWindowsTerminalInstalled(): Boolean;
begin
  Log('IsWindowsTerminalInstalled called');
  if IsUninstallMode() then
    Result := IsWindowsTerminalInstalledUninstall()
  else
    Result := IsWindowsTerminalInstalledSetup();
  Log(Format('IsWindowsTerminalInstalled: %s', [BoolToStr(Result)]));
end;

function GetFileLocationsInSystemPath(const FileName: String;
  var OutputPathList: TArrayOfString): Boolean;
var
  Buffer,
  OutputBuffer: String;
  BufferSize: Cardinal;

begin
  SetLength(Buffer, HELPER_LIBRARY_BUFFER_SIZE_LARGE);
  if IsUninstallMode() then
    BufferSize := GetFileLocationsInSystemPathUninstall(FileName,
      HELPER_LIBRARY_BUFFER_SPLIT_CHAR, Buffer, HELPER_LIBRARY_BUFFER_SIZE_LARGE) 
  else
    BufferSize := GetFileLocationsInSystemPathSetup(FileName,
      HELPER_LIBRARY_BUFFER_SPLIT_CHAR, Buffer, HELPER_LIBRARY_BUFFER_SIZE_LARGE);
  SetLength(Buffer, BufferSize);
  OutputBuffer := Copy(Buffer, 1, Length(Buffer));
  Result := Length(OutputBuffer) > 0;
  if Result then
    Explode(OutputPathList, OutputBuffer, HELPER_LIBRARY_BUFFER_SPLIT_CHAR);
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
// IMPORTS FROM LIBRARY // CODE::BLOCKS
// ============================================================================

function CodeBlocksGetAvailableUsersSetup(const lpDelimiter: AnsiChar;
  lpAvailableUsers: String; const uBufferMaxSize: Cardinal): Cardinal;
external 'CodeBlocksGetAvailableUsersW@files:{#CodeBlocksHelperLibraryFileName} stdcall setuponly';

function CodeBlocksGetAvailableUsersUninstall(const lpDelimiter: AnsiChar;
  lpAvailableUsers: String; const uBufferMaxSize: Cardinal): Cardinal;
external 'CodeBlocksGetAvailableUsersW@{#CodeBlocksHelperLibraryUninstallFullPath} stdcall uninstallonly';

function CodeBlocksRemoveProfilesSetup: Boolean;
external 'CodeBlocksRemoveProfiles@files:{#CodeBlocksHelperLibraryFileName} stdcall setuponly';

function CodeBlocksRemoveProfilesUninstall: Boolean;
external 'CodeBlocksRemoveProfiles@{#CodeBlocksHelperLibraryUninstallFullPath} stdcall uninstallonly';

function CodeBlocksDetectInstallationPathSetup(lpInstallationPath: String;
  const uBufferMaxSize: Cardinal): Cardinal;
external 'CodeBlocksDetectInstallationPathW@files:{#CodeBlocksHelperLibraryFileName} stdcall setuponly';

function CodeBlocksDetectInstallationPathUninstall(lpInstallationPath: String;
  const uBufferMaxSize: Cardinal): Cardinal;
external 'CodeBlocksDetectInstallationPathW@{#CodeBlocksHelperLibraryUninstallFullPath} stdcall uninstallonly';

function CodeBlocksDetectVersionSetup(const lpCodeBlocksInstallationDirectory: String;
  lpCodeBlockVersion: String; const uBufferMaxSize: Cardinal): Cardinal;
external 'CodeBlocksDetectVersionW@files:{#CodeBlocksHelperLibraryFileName} stdcall setuponly';

function CodeBlocksDetectVersionUninstall(const lpCodeBlocksInstallationDirectory: String;
  lpCodeBlockVersion: String; const uBufferMaxSize: Cardinal): Cardinal;
external 'CodeBlocksDetectVersionW@{#CodeBlocksHelperLibraryUninstallFullPath} stdcall uninstallonly';

procedure CodeBlocksInitializeProfilesSetup;
external 'CodeBlocksInitializeProfiles@files:{#CodeBlocksHelperLibraryFileName} stdcall setuponly';

procedure CodeBlocksInitializeProfilesUninstall;
external 'CodeBlocksInitializeProfiles@{#CodeBlocksHelperLibraryUninstallFullPath} stdcall uninstallonly';

// ============================================================================
// EXPOSED FUNCTIONS // CODE::BLOCKS
// ============================================================================

function CodeBlocksGetAvailableUsers(var AvailableUsers: TArrayOfString): Boolean;
var
  Buffer,
  OutputBuffer: String;
  BufferSize: Cardinal;

begin
  SetLength(Buffer, HELPER_LIBRARY_BUFFER_SIZE_LARGE);
  if IsUninstallMode() then
    BufferSize := CodeBlocksGetAvailableUsersUninstall(
      HELPER_LIBRARY_BUFFER_SPLIT_CHAR, Buffer, HELPER_LIBRARY_BUFFER_SIZE_LARGE)
  else
    BufferSize := CodeBlocksGetAvailableUsersSetup(
      HELPER_LIBRARY_BUFFER_SPLIT_CHAR, Buffer, HELPER_LIBRARY_BUFFER_SIZE_LARGE);
  SetLength(Buffer, BufferSize);  
  OutputBuffer := Copy(Buffer, 1, Length(Buffer)); 
  Result := Length(OutputBuffer) > 0; 
  if Result then
    Explode(AvailableUsers, OutputBuffer, HELPER_LIBRARY_BUFFER_SPLIT_CHAR);
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
  Buffer,
  OutputBuffer: String;
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
  OutputBuffer := Copy(Buffer, 1, Length(Buffer));   
  Result := OutputBuffer;
end;

function CodeBlocksDetectVersion(CodeBlocksInstallationPath: String): String;
var
  Buffer,
  OutputBuffer: String;
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
  OutputBuffer := Copy(Buffer, 1, Length(Buffer));
  Result := OutputBuffer;
end;

procedure CodeBlocksInitializeProfiles();
begin
  if IsUninstallMode() then
    CodeBlocksInitializeProfilesUninstall()
  else
    CodeBlocksInitializeProfilesSetup();
end;
