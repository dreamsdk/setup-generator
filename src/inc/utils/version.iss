[Code]
// Thanks to Jernej Simončič, Lex Li and XhmikosR.
// https://blog.lextudio.com/inno-setup-script-sample-for-version-comparison-advanced-version-c398d0ef18ad

type
  TVersionDynamicFunctionSanitize = function(const VersionNumber: String): String;
  TVersionDynamicFunctionBeforeUninstall = procedure;

const
  VERSION_IDENTICAL = 0;
  VERSION_OLDER = -1;
  VERSION_NEWER = 1;

var
  VersionDyncFuncSanitize: TVersionDynamicFunctionSanitize; 
  VersionDyncFuncBeforeUninstall: TVersionDynamicFunctionBeforeUninstall;

procedure VersionSetDynamicFunctionSanitize(ASanitizeVersion: TVersionDynamicFunctionSanitize);
begin
  VersionDyncFuncSanitize := ASanitizeVersion;
end;

procedure SetDoBeforeUninstall(ABeforeUninstall: TVersionDynamicFunctionBeforeUninstall);
begin
  VersionDyncFuncBeforeUninstall := ABeforeUninstall;
end;

// Compares two version numbers, returns -1 if vA is newer, 0 if both are identical, 1 if vB is newer
function CompareVersion(vA, vB: String): Integer;
var
  tmp: TArrayOfString;
  verA, verB: Array of Integer;
  i, len: Integer;

begin
  vA := VersionDyncFuncSanitize(vA);
  vB := VersionDyncFuncSanitize(vB);
 
  StringChange(vA, '-', '.');
  StringChange(vB, '-', '.');

  Log(Format('Comparing Version %s with %s', [vA, vB]));

  Explode(tmp, vA, '.');
  SetArrayLength(verA, GetArrayLength(tmp));
  for i := 0 to GetArrayLength(tmp) - 1 do
    verA[i] := StrToIntDef(tmp[i], 0);
      
  Explode(tmp, vB, '.');
  SetArrayLength(verB, GetArrayLength(tmp));
  for i := 0 to GetArrayLength(tmp) - 1 do
    verB[i] := StrToIntDef(tmp[i], 0);

  len := GetArrayLength(verA);
  if GetArrayLength(verB) < len then
    len := GetArrayLength(verB);

  for i := 0 to len - 1 do
    if verA[i] < verB[i] then
    begin
        Result := 1;
        exit;
    end 
    else
    if verA[i] > verB[i] then
    begin
        Result := -1;
        Exit;
    end;

  if GetArrayLength(verA) < GetArrayLength(verB) then
  begin
    Result := 1;
    Exit;
  end 
  else if GetArrayLength(verA) > GetArrayLength(verB) then
  begin
    Result := -1;
    Exit;
  end;

  Result := 0; 
end;

function GetUninstallCommand(const RootKey: Integer; RegistryKey: string; var UninstallExecutable, UninstallParameters: String): Boolean;
var
  UninstallString, 
  QuietUninstallString: String;

begin
  UninstallExecutable := '';
  UninstallParameters := '';  
  Result := RegQueryStringValue(RootKey, RegistryKey, 'UninstallString', UninstallString);
  Result := Result and RegQueryStringValue(RootKey, RegistryKey, 'QuietUninstallString', QuietUninstallString);
  if Result then
  begin  
    UninstallExecutable := UninstallString;
    StringChangeEx(UninstallExecutable, '"', '', True);
    
    UninstallParameters := QuietUninstallString; 
    StringChangeEx(UninstallParameters, UninstallString, '', True);
   
    UninstallExecutable := Trim(UninstallExecutable);
    UninstallParameters := Trim(UninstallParameters); 
  end;
end;

function UninstallPreviousVersion(RootKey: Integer; RegistryKey, OldVersion: String): Boolean;
var
  UninstallExecutable, 
  UninstallParameters: String;
  ErrorCode: Integer;

begin
  Result := True;
  if GetUninstallCommand(RootKey, RegistryKey, UninstallExecutable, UninstallParameters) then
  begin
    Log(Format('UninstallExecutable: "%s", UninstallParameters: "%s"', [UninstallExecutable, UninstallParameters]));
    VersionDyncFuncBeforeUninstall();
    if not Exec(UninstallExecutable, UninstallParameters, '', SW_HIDE, ewWaitUntilTerminated, ErrorCode) then
      Result := (MsgBox(Format(CustomMessage('PreviousVersionUninstallFailed'), [OldVersion, ErrorCode]), mbError, MB_YESNO) = IDYES);
  end
  else
    Result := (MsgBox(Format(CustomMessage('PreviousVersionUninstallUnableToGetCommand'), [OldVersion]), mbCriticalError, MB_YESNO) = IDYES);
end;

function HandlePreviousVersion(AppID, AppVersion: String): Boolean;
var
  RootKey: Integer;
  RegistryKey,
  OldVersion: String;
  VersionCompareResult: Integer;

begin
  Result := True;
  RootKey := HKEY_LOCAL_MACHINE_32;
  RegistryKey := Format('SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%s_is1', [AppID]);
  Log(Format('AppVersion: %s, Registry Key: %s', [AppVersion, RegistryKey]));    
  if RegKeyExists(RootKey, RegistryKey) then
  begin
    RegQueryStringValue(RootKey, RegistryKey, 'DisplayVersion', OldVersion);
    Log(Format('OldVersion: %s, AppVersion: %s', [OldVersion, AppVersion]));
    VersionCompareResult := CompareVersion(OldVersion, AppVersion);
    
    case VersionCompareResult of
      VERSION_OLDER:
        begin
          MsgBox(Format(CustomMessage('NewerVersionAlreadyInstalled'), [OldVersion, AppVersion]), mbError, MB_OK);
          Result := False;
        end;

      VERSION_IDENTICAL: 
        begin
          Result := (MsgBox(Format(CustomMessage('VersionAlreadyInstalled'), [OldVersion]), mbConfirmation, MB_YESNO) = IDYES);
          if Result then               
            Result := UninstallPreviousVersion(RootKey, RegistryKey, OldVersion);
        end;

      VERSION_NEWER:
        begin
          Result := (MsgBox(Format(CustomMessage('PreviousVersionUninstall'), [OldVersion]), mbConfirmation, MB_YESNO) = IDYES);
          if Result then               
            Result := UninstallPreviousVersion(RootKey, RegistryKey, OldVersion);           
        end;

     end; // case
  end; // RegKeyExists
end;
