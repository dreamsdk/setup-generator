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

function IsWindowsTerminalInstalledA: Boolean;
external 'IsWindowsTerminalInstalledA@files:{#HelperLibraryFileName} stdcall setuponly';

function GetFileLocationsInSystemPathA(const lpFileName: AnsiString;
  const lpDelimiter: AnsiChar; lpPathFileNames: AnsiString;
  const uBufferMaxSize: Cardinal): Cardinal;   
external 'GetFileLocationsInSystemPathA@files:{#HelperLibraryFileName} stdcall setuponly';

function RenameFileOrDirectoryAsBackupA(
  const OldDirectoryFullPath: AnsiString): Boolean;
external 'RenameFileOrDirectoryAsBackupA@files:{#HelperLibraryFileName} stdcall setuponly';

function GetPortableExecutableBitnessA(const FileName: AnsiString): Byte; 
external 'GetPortableExecutableBitnessA@files:{#HelperLibraryFileName} stdcall setuponly';

function CodeBlocksGetAvailableUsersA(const lpDelimiter: AnsiChar;
  lpAvailableUsers: AnsiString; const uBufferMaxSize: Cardinal): Cardinal;
external 'CodeBlocksGetAvailableUsersA@files:{#HelperLibraryFileName} stdcall setuponly';

function CodeBlocksRemoveProfilesA: Boolean;
external 'CodeBlocksRemoveProfilesA@files:{#HelperLibraryFileName} stdcall setuponly';

function CodeBlocksDetectInstallationPathA(lpInstallationPath: AnsiString;
  const uBufferMaxSize: Cardinal): Cardinal;
external 'CodeBlocksDetectInstallationPathA@files:{#HelperLibraryFileName} stdcall setuponly';

function CodeBlocksDetectVersionA(const lpCodeBlocksInstallationDirectory: AnsiString;
  lpCodeBlockVersion: AnsiString; const uBufferMaxSize: Cardinal): Cardinal;
external 'CodeBlocksDetectVersionA@files:{#HelperLibraryFileName} stdcall setuponly';

procedure CodeBlocksInitializeProfilesA;
external 'CodeBlocksInitializeProfilesA@files:{#HelperLibraryFileName} stdcall setuponly';

//importing an ANSI custom DLL function, first for Setup, then for uninstall
(*function MyDllFuncSetup(lpText: AnsiString; const uSize: Cardinal): Cardinal;
external 'MyDllFunc@files:{#HelperLibraryFileName} stdcall setuponly';*)

(*procedure MyDllFuncUninstall(hWnd: Integer; lpText, lpCaption: AnsiString; uType: Cardinal);
external 'MyDllFunc@{app}\MyDll.dll stdcall uninstallonly';*)

// ============================================================================
// EXPOSED FUNCTIONS
// ============================================================================

function IsWindowsTerminalInstalled2(): Boolean;
begin
  Result := IsWindowsTerminalInstalledA();
end;

function GetFileLocationsInSystemPath(const FileName: String): String;
var
  Buffer: AnsiString;

begin
  SetLength(Buffer, HELPER_LIBRARY_BUFFER_SIZE_LARGE);
  SetLength(Buffer, GetFileLocationsInSystemPathA(FileName,
    HELPER_LIBRARY_BUFFER_SPLIT_CHAR, Buffer, HELPER_LIBRARY_BUFFER_SIZE_LARGE));
  Result := Copy(Buffer, 1, Length(Buffer));
end;

function RenameFileOrDirectoryAsBackup1(const FileOrDirectory: String): Boolean;
begin
  Result := RenameFileOrDirectoryAsBackupA(FileOrDirectory);
end;

function GetPortableExecutableBitness(const FileName: String): TPortableExecutableBitness;
var
  Buffer: Byte;

begin
  Buffer := GetPortableExecutableBitnessA(FileName);
  Result := TPortableExecutableBitness(Buffer);
end;

//
// Code::Blocks
//

function CodeBlocksGetAvailableUsers(): String;
var
  Buffer: AnsiString;

begin
  SetLength(Buffer, HELPER_LIBRARY_BUFFER_SIZE_LARGE);
  SetLength(Buffer, CodeBlocksGetAvailableUsersA(
    HELPER_LIBRARY_BUFFER_SPLIT_CHAR, Buffer, HELPER_LIBRARY_BUFFER_SIZE_LARGE));
  Result := Copy(Buffer, 1, Length(Buffer));  
end;

function CodeBlocksRemoveProfiles(): Boolean;
begin
  Result := CodeBlocksRemoveProfilesA();
end;

function CodeBlocksDetectInstallationPath(): String;
var
  Buffer: AnsiString;
  
begin
  SetLength(Buffer, HELPER_LIBRARY_BUFFER_SIZE_SMALL);
  SetLength(Buffer, CodeBlocksDetectInstallationPathA(Buffer,
    HELPER_LIBRARY_BUFFER_SIZE_SMALL));
  Result := Copy(Buffer, 1, Length(Buffer));
end;

function CodeBlocksDetectVersion(CodeBlocksInstallationPath: String): String;
var
  Buffer: AnsiString;

begin
  SetLength(Buffer, HELPER_LIBRARY_BUFFER_SIZE_SMALL);
  SetLength(Buffer, CodeBlocksDetectVersionA(CodeBlocksInstallationPath, 
    Buffer, HELPER_LIBRARY_BUFFER_SIZE_SMALL));
  Result := Copy(Buffer, 1, Length(Buffer));
end;

procedure CodeBlocksInitializeProfiles();
begin
  CodeBlocksInitializeProfilesA();
end;


////////////////////////////////////////////////////////////////////////////////


// Check if a process is running
// This helper function uses PSVince
function Test1(): Boolean;
var
  test: string;

begin
  Log(Format('++++++++++++++++++++++++++++++++++++ IsWindowsTerminalInstalled : "%s"', [BoolToStr(IsWindowsTerminalInstalled2())]));
  Log(Format('++++++++++++++++++++++++++++++++++++ GetFileLocationsInSystemPath : "%s"', [GetFileLocationsInSystemPath('explorer.exe')]));
  // RenameFileOrDirectoryAsBackup1
  Log(Format('++++++++++++++++++++++++++++++++++++ GetPortableExecutableBitness : "%d"', [(GetPortableExecutableBitness('D:\setup-helpers\bin\dreamsdk.dll'))]));
  Log(Format('++++++++++++++++++++++++++++++++++++ CodeBlocksGetAvailableUsers : "%s"', [(CodeBlocksGetAvailableUsers())]));
  // CodeBlocksRemoveProfiles
  Log(Format('++++++++++++++++++++++++++++++++++++ CodeBlocksDetectInstallationPath : "%s"', [(CodeBlocksDetectInstallationPath())]));
  // CodeBlocksDetectVersion
  // CodeBlocksInitializeProfiles 
end;


