#define CommonHelperLibraryFileName "common.dll"
#define CommonHelperLibraryUninstallFullPath "{app}\" + AppSupportDirectoryName + "\" + CommonHelperLibraryFileName

#define CodeBlocksHelperLibraryFileName "cbhelper.dll"
#define CodeBlocksHelperLibraryUninstallFullPath "{app}\" + AppSupportDirectoryName + "\" + CodeBlocksHelperLibraryFileName

#define VisualStudioCodeHelperLibraryFileName "vshelper.dll"
#define VisualStudioCodeHelperLibraryUninstallFullPath "{app}\" + AppSupportDirectoryName + "\" + VisualStudioCodeHelperLibraryFileName

#define PostInstallHelperLibraryFileName "postinst.dll"
#define PostInstallHelperLibrarySetupFullPath "{tmp}\" + PostInstallHelperLibraryFileName

[Files]
Source: "..\.helpers\{#CommonHelperLibraryFileName}"; DestDir: "{code:GetApplicationSupportPath}"; Flags: ignoreversion noencryption nocompression
Source: "..\.helpers\{#CodeBlocksHelperLibraryFileName}"; DestDir: "{code:GetApplicationSupportPath}"; Flags: ignoreversion noencryption nocompression
Source: "..\.helpers\{#VisualStudioCodeHelperLibraryFileName}"; DestDir: "{code:GetApplicationSupportPath}"; Flags: ignoreversion noencryption nocompression
; Post-install helper is used only while installing, so it's never copied
Source: "..\.helpers\{#PostInstallHelperLibraryFileName}"; Flags: dontcopy noencryption nocompression

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
  UnloadDLL(ExpandConstant('{#VisualStudioCodeHelperLibraryUninstallFullPath}'));
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

function CommonGetLastErrorSetup(lpErrorMessage: String;
  const uBufferMaxSize: Cardinal): Cardinal;
external 'CommonGetLastErrorW@files:{#CommonHelperLibraryFileName} stdcall setuponly';

function CommonGetLastErrorUninstall(lpErrorMessage: String;
  const uBufferMaxSize: Cardinal): Cardinal;
external 'CommonGetLastErrorW@{#CommonHelperLibraryUninstallFullPath} stdcall uninstallonly';

// ============================================================================
// EXPOSED FUNCTIONS // COMMON
// ============================================================================

// Log the message of the last exception caught in the helper library, if any
// (the message is cleared once read)
procedure CommonLogLastError(const FunctionName: String);
var
  Buffer: String;
  BufferSize: Cardinal;

begin
  SetLength(Buffer, HELPER_LIBRARY_BUFFER_SIZE_SMALL);
  if IsUninstallMode() then
    BufferSize := CommonGetLastErrorUninstall(Buffer, HELPER_LIBRARY_BUFFER_SIZE_SMALL)
  else
    BufferSize := CommonGetLastErrorSetup(Buffer, HELPER_LIBRARY_BUFFER_SIZE_SMALL);
  SetLength(Buffer, BufferSize);
  if BufferSize > 0 then
    Log(Format('%s: helper exception: %s', [FunctionName, Copy(Buffer, 1, Length(Buffer))]));
end;

function IsWindowsTerminalInstalled(): Boolean;
begin
  Log('IsWindowsTerminalInstalled called');
  if IsUninstallMode() then
    Result := IsWindowsTerminalInstalledUninstall()
  else
    Result := IsWindowsTerminalInstalledSetup();
  CommonLogLastError('IsWindowsTerminalInstalled');
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
  CommonLogLastError('GetFileLocationsInSystemPath');
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
  CommonLogLastError('RenameFileOrDirectoryAsBackup');
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
  CommonLogLastError('GetPortableExecutableBitness');
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

function CodeBlocksGetLastErrorSetup(lpErrorMessage: String;
  const uBufferMaxSize: Cardinal): Cardinal;
external 'CodeBlocksGetLastErrorW@files:{#CodeBlocksHelperLibraryFileName} stdcall setuponly';

function CodeBlocksGetLastErrorUninstall(lpErrorMessage: String;
  const uBufferMaxSize: Cardinal): Cardinal;
external 'CodeBlocksGetLastErrorW@{#CodeBlocksHelperLibraryUninstallFullPath} stdcall uninstallonly';

// ============================================================================
// EXPOSED FUNCTIONS // CODE::BLOCKS
// ============================================================================

// Log the message of the last exception caught in the helper library, if any
// (the message is cleared once read)
procedure CodeBlocksLogLastError(const FunctionName: String);
var
  Buffer: String;
  BufferSize: Cardinal;

begin
  SetLength(Buffer, HELPER_LIBRARY_BUFFER_SIZE_SMALL);
  if IsUninstallMode() then
    BufferSize := CodeBlocksGetLastErrorUninstall(Buffer, HELPER_LIBRARY_BUFFER_SIZE_SMALL)
  else
    BufferSize := CodeBlocksGetLastErrorSetup(Buffer, HELPER_LIBRARY_BUFFER_SIZE_SMALL);
  SetLength(Buffer, BufferSize);
  if BufferSize > 0 then
    Log(Format('%s: helper exception: %s', [FunctionName, Copy(Buffer, 1, Length(Buffer))]));
end;

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
  CodeBlocksLogLastError('CodeBlocksGetAvailableUsers');
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
  CodeBlocksLogLastError('CodeBlocksRemoveProfiles');
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
  CodeBlocksLogLastError('CodeBlocksDetectInstallationPath');
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
  CodeBlocksLogLastError('CodeBlocksDetectVersion');
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
  CodeBlocksLogLastError('CodeBlocksInitializeProfiles');
end;

// ============================================================================
// IMPORTS FROM LIBRARY // VISUAL STUDIO CODE (AND FORKS)
// ============================================================================

// The editor identifiers are defined in the VSCTools unit (e.g. "vscode",
// "vscodium"): see VSCODE_EDITORS.

function VSCodeDetectCliSetup(const lpEditorId: String;
  lpCommandLineInterface: String; const uBufferMaxSize: Cardinal): Cardinal;
external 'VSCodeDetectCliW@files:{#VisualStudioCodeHelperLibraryFileName} stdcall setuponly';

function VSCodeDetectCliUninstall(const lpEditorId: String;
  lpCommandLineInterface: String; const uBufferMaxSize: Cardinal): Cardinal;
external 'VSCodeDetectCliW@{#VisualStudioCodeHelperLibraryUninstallFullPath} stdcall uninstallonly';

function VSCodeDetectVersionSetup(const lpEditorId: String;
  lpVersion: String; const uBufferMaxSize: Cardinal): Cardinal;
external 'VSCodeDetectVersionW@files:{#VisualStudioCodeHelperLibraryFileName} stdcall setuponly';

function VSCodeDetectVersionUninstall(const lpEditorId: String;
  lpVersion: String; const uBufferMaxSize: Cardinal): Cardinal;
external 'VSCodeDetectVersionW@{#VisualStudioCodeHelperLibraryUninstallFullPath} stdcall uninstallonly';

function VSCodeGetAvailableUsersSetup(const lpDelimiter: AnsiChar;
  lpAvailableUsers: String; const uBufferMaxSize: Cardinal): Cardinal;
external 'VSCodeGetAvailableUsersW@files:{#VisualStudioCodeHelperLibraryFileName} stdcall setuponly';

function VSCodeGetAvailableUsersUninstall(const lpDelimiter: AnsiChar;
  lpAvailableUsers: String; const uBufferMaxSize: Cardinal): Cardinal;
external 'VSCodeGetAvailableUsersW@{#VisualStudioCodeHelperLibraryUninstallFullPath} stdcall uninstallonly';

function VSCodeInstallExtensionSetup(const lpEditorId: String;
  const lpVsixFileName: String): Boolean;
external 'VSCodeInstallExtensionW@files:{#VisualStudioCodeHelperLibraryFileName} stdcall setuponly';

function VSCodeRemoveExtensionSetup(const lpEditorId: String): Boolean;
external 'VSCodeRemoveExtensionW@files:{#VisualStudioCodeHelperLibraryFileName} stdcall setuponly';

function VSCodeRemoveExtensionUninstall(const lpEditorId: String): Boolean;
external 'VSCodeRemoveExtensionW@{#VisualStudioCodeHelperLibraryUninstallFullPath} stdcall uninstallonly';

function VSCodeRefreshInstalledUsersSetup(const lpEditorId: String;
  const lpConfigurationFileName: String): Boolean;
external 'VSCodeRefreshInstalledUsersW@files:{#VisualStudioCodeHelperLibraryFileName} stdcall setuponly';

function VSCodeGetLastErrorSetup(lpErrorMessage: String;
  const uBufferMaxSize: Cardinal): Cardinal;
external 'VSCodeGetLastErrorW@files:{#VisualStudioCodeHelperLibraryFileName} stdcall setuponly';

function VSCodeGetLastErrorUninstall(lpErrorMessage: String;
  const uBufferMaxSize: Cardinal): Cardinal;
external 'VSCodeGetLastErrorW@{#VisualStudioCodeHelperLibraryUninstallFullPath} stdcall uninstallonly';

// ============================================================================
// EXPOSED FUNCTIONS // VISUAL STUDIO CODE (AND FORKS)
// ============================================================================

function VSCodeDetectCli(const EditorId: String): String;
var
  Buffer: String;
  BufferSize: Cardinal;

begin
  SetLength(Buffer, HELPER_LIBRARY_BUFFER_SIZE_SMALL);
  if IsUninstallMode() then
    BufferSize := VSCodeDetectCliUninstall(EditorId, Buffer, HELPER_LIBRARY_BUFFER_SIZE_SMALL)
  else
    BufferSize := VSCodeDetectCliSetup(EditorId, Buffer, HELPER_LIBRARY_BUFFER_SIZE_SMALL);
  SetLength(Buffer, BufferSize);
  Result := Copy(Buffer, 1, Length(Buffer));
  Log(Format('VSCodeDetectCli: %s="%s"', [EditorId, Result]));
end;

function VSCodeDetectVersion(const EditorId: String): String;
var
  Buffer: String;
  BufferSize: Cardinal;

begin
  SetLength(Buffer, HELPER_LIBRARY_BUFFER_SIZE_SMALL);
  if IsUninstallMode() then
    BufferSize := VSCodeDetectVersionUninstall(EditorId, Buffer, HELPER_LIBRARY_BUFFER_SIZE_SMALL)
  else
    BufferSize := VSCodeDetectVersionSetup(EditorId, Buffer, HELPER_LIBRARY_BUFFER_SIZE_SMALL);
  SetLength(Buffer, BufferSize);
  Result := Copy(Buffer, 1, Length(Buffer));
end;

function VSCodeGetAvailableUsers(var AvailableUsers: TArrayOfString): Boolean;
var
  Buffer,
  OutputBuffer: String;
  BufferSize: Cardinal;

begin
  SetLength(Buffer, HELPER_LIBRARY_BUFFER_SIZE_LARGE);
  if IsUninstallMode() then
    BufferSize := VSCodeGetAvailableUsersUninstall(
      HELPER_LIBRARY_BUFFER_SPLIT_CHAR, Buffer, HELPER_LIBRARY_BUFFER_SIZE_LARGE)
  else
    BufferSize := VSCodeGetAvailableUsersSetup(
      HELPER_LIBRARY_BUFFER_SPLIT_CHAR, Buffer, HELPER_LIBRARY_BUFFER_SIZE_LARGE);
  SetLength(Buffer, BufferSize);
  OutputBuffer := Copy(Buffer, 1, Length(Buffer));
  Result := Length(OutputBuffer) > 0;
  if Result then
    Explode(AvailableUsers, OutputBuffer, HELPER_LIBRARY_BUFFER_SPLIT_CHAR);
end;

// Error message of the last install/remove operation, or of the last exception
// caught in the helper library
function VSCodeGetLastError(): String;
var
  Buffer: String;
  BufferSize: Cardinal;

begin
  SetLength(Buffer, HELPER_LIBRARY_BUFFER_SIZE_LARGE);
  if IsUninstallMode() then
    BufferSize := VSCodeGetLastErrorUninstall(Buffer, HELPER_LIBRARY_BUFFER_SIZE_LARGE)
  else
    BufferSize := VSCodeGetLastErrorSetup(Buffer, HELPER_LIBRARY_BUFFER_SIZE_LARGE);
  SetLength(Buffer, BufferSize);
  Result := Copy(Buffer, 1, Length(Buffer));
end;

// Only available while installing: the .vsix is installed with DreamSDK
function VSCodeInstallExtension(const EditorId, VsixFileName: String): Boolean;
begin
  Result := VSCodeInstallExtensionSetup(EditorId, VsixFileName);
  Log(Format('VSCodeInstallExtension: %s, "%s", result=%s', [EditorId, VsixFileName, BoolToStr(Result)]));
  if not Result then
    Log(Format('VSCodeInstallExtension: error: %s', [VSCodeGetLastError()]));
end;

function VSCodeRemoveExtension(const EditorId: String): Boolean;
begin
  if IsUninstallMode() then
    Result := VSCodeRemoveExtensionUninstall(EditorId)
  else
    Result := VSCodeRemoveExtensionSetup(EditorId);
  Log(Format('VSCodeRemoveExtension: %s, result=%s', [EditorId, BoolToStr(Result)]));
  if not Result then
    Log(Format('VSCodeRemoveExtension: error: %s', [VSCodeGetLastError()]));
end;

// Save the users having the extension in ide.conf (read by DreamSDK Manager)
function VSCodeRefreshInstalledUsers(const EditorId, ConfigurationFileName: String): Boolean;
begin
  Result := VSCodeRefreshInstalledUsersSetup(EditorId, ConfigurationFileName);
  Log(Format('VSCodeRefreshInstalledUsers: %s, "%s", result=%s', [EditorId,
    ConfigurationFileName, BoolToStr(Result)]));
end;

// ============================================================================
// IMPORTS FROM LIBRARY // POST-INSTALL
// ============================================================================

const
  POST_INSTALL_STATUS_IDLE = 0;
  POST_INSTALL_STATUS_RUNNING = 1;
  POST_INSTALL_STATUS_SUCCEEDED = 2;
  POST_INSTALL_STATUS_FAILED = 3;
  POST_INSTALL_STATUS_ABORTED = 4;

function PostInstallInitialize(const lpHomeDirectory: String): Boolean;
external 'PostInstallInitializeW@files:{#PostInstallHelperLibraryFileName} stdcall setuponly delayload';

function PostInstallStart: Boolean;
external 'PostInstallStart@files:{#PostInstallHelperLibraryFileName} stdcall setuponly delayload';

function PostInstallPoll: Cardinal;
external 'PostInstallPoll@files:{#PostInstallHelperLibraryFileName} stdcall setuponly delayload';

function PostInstallGetProgressTextSetup(lpProgressText: String;
  const uBufferMaxSize: Cardinal): Cardinal;
external 'PostInstallGetProgressTextW@files:{#PostInstallHelperLibraryFileName} stdcall setuponly delayload';

function PostInstallGetNewLinesSetup(lpNewLines: String;
  const uBufferMaxSize: Cardinal): Cardinal;
external 'PostInstallGetNewLinesW@files:{#PostInstallHelperLibraryFileName} stdcall setuponly delayload';

function PostInstallGetProgressPosition: Integer;
external 'PostInstallGetProgressPosition@files:{#PostInstallHelperLibraryFileName} stdcall setuponly delayload';

procedure PostInstallAbort;
external 'PostInstallAbort@files:{#PostInstallHelperLibraryFileName} stdcall setuponly delayload';

procedure PostInstallFinalize;
external 'PostInstallFinalize@files:{#PostInstallHelperLibraryFileName} stdcall setuponly delayload';

function PostInstallGetLastErrorSetup(lpErrorMessage: String;
  const uBufferMaxSize: Cardinal): Cardinal;
external 'PostInstallGetLastErrorW@files:{#PostInstallHelperLibraryFileName} stdcall setuponly delayload';

// ============================================================================
// EXPOSED FUNCTIONS // POST-INSTALL
// ============================================================================

// Unload the post-install helper (PostInstallFinalize must be called before)
procedure PostInstallUnload;
begin
  UnloadDLL(ExpandConstant('{#PostInstallHelperLibrarySetupFullPath}'));
end;

function PostInstallGetProgressText(): String;
var
  Buffer: String;
  BufferSize: Cardinal;

begin
  SetLength(Buffer, HELPER_LIBRARY_BUFFER_SIZE_SMALL);
  BufferSize := PostInstallGetProgressTextSetup(Buffer,
    HELPER_LIBRARY_BUFFER_SIZE_SMALL);
  SetLength(Buffer, BufferSize);
  Result := Copy(Buffer, 1, Length(Buffer));
end;

// Get the output lines received since the last call (separated by CR/LF)
function PostInstallGetNewLines(): String;
var
  Buffer: String;
  BufferSize: Cardinal;

begin
  SetLength(Buffer, HELPER_LIBRARY_BUFFER_SIZE_LARGE);
  BufferSize := PostInstallGetNewLinesSetup(Buffer,
    HELPER_LIBRARY_BUFFER_SIZE_LARGE);
  SetLength(Buffer, BufferSize);
  Result := Copy(Buffer, 1, Length(Buffer));
end;

// Get the message of the last exception caught in the helper library, or an
// empty string (the message is cleared once read)
function PostInstallGetLastError(): String;
var
  Buffer: String;
  BufferSize: Cardinal;

begin
  SetLength(Buffer, HELPER_LIBRARY_BUFFER_SIZE_SMALL);
  BufferSize := PostInstallGetLastErrorSetup(Buffer,
    HELPER_LIBRARY_BUFFER_SIZE_SMALL);
  SetLength(Buffer, BufferSize);
  Result := Copy(Buffer, 1, Length(Buffer));
end;
