﻿[Code]
// Thanks to Jernej Simončič, Lex Li and XhmikosR.
// https://blog.lextudio.com/inno-setup-script-sample-for-version-comparison-advanced-version-c398d0ef18ad
// https://github.com/XhmikosR/psvince

const
  VERSION_IDENTICAL = 0;
  VERSION_OLDER = -1;
  VERSION_NEWER = 1;

function Count(What, Where: String): Integer;
begin
   Result := 0;
    if Length(What) = 0 then
        exit;
    while Pos(What,Where)>0 do
    begin
        Where := Copy(Where,Pos(What,Where)+Length(What),Length(Where));
        Result := Result + 1;
    end;
end;
 
// Split text to array
procedure Explode(var ADest: TArrayOfString; aText, aSeparator: String);
var tmp: Integer;
begin
    if aSeparator='' then
        exit;
 
    SetArrayLength(ADest,Count(aSeparator,aText)+1)
 
    tmp := 0;
    repeat
        if Pos(aSeparator,aText)>0 then
        begin
 
            ADest[tmp] := Copy(aText,1,Pos(aSeparator,aText)-1);
            aText := Copy(aText,Pos(aSeparator,aText)+Length(aSeparator),Length(aText));
            tmp := tmp + 1;
 
        end else
        begin
 
             ADest[tmp] := aText;
             aText := '';
 
        end;
    until Length(aText)=0;
end;

function SanitizeVersion(const VersionNumber: String): String;
begin
  Result := VersionNumber;
  StringChangeEx(Result, 'R', '', True);
  StringChangeEx(Result, '-dev', '', True);
end; 
 
// Compares two version numbers, returns -1 if vA is newer, 0 if both are identical, 1 if vB is newer
function CompareVersion(vA, vB: String): Integer;
var tmp: TArrayOfString;
    verA,verB: Array of Integer;
    i,len: Integer;
begin
    vA := SanitizeVersion(vA);
    vB := SanitizeVersion(vB);
   
    StringChange(vA,'-','.');
    StringChange(vB,'-','.');

    Log(Format('Comparing Version %s with %s', [vA, vB]));
 
    Explode(tmp,vA,'.');
    SetArrayLength(verA,GetArrayLength(tmp));
    for i := 0 to GetArrayLength(tmp) - 1 do
        verA[i] := StrToIntDef(tmp[i],0);
        
    Explode(tmp,vB,'.');
    SetArrayLength(verB,GetArrayLength(tmp));
    for i := 0 to GetArrayLength(tmp) - 1 do
        verB[i] := StrToIntDef(tmp[i],0);
 
    len := GetArrayLength(verA);
    if GetArrayLength(verB) < len then
        len := GetArrayLength(verB);
 
    for i := 0 to len - 1 do
        if verA[i] < verB[i] then
        begin
            Result := 1;
            exit;
        end else
        if verA[i] > verB[i] then
        begin
            Result := -1;
            exit
        end;
 
    if GetArrayLength(verA) < GetArrayLength(verB) then
    begin
        Result := 1;
        exit;
    end else
    if GetArrayLength(verA) > GetArrayLength(verB) then
    begin
        Result := -1;
        exit;
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
             
function HandlePreviousVersion(AppID, AppVersion: string): Boolean;
var
  RootKey: Integer;
  RegistryKey,
  OldVersion,
  UninstallExecutable, 
  UninstallParameters: String;
  VersionCompareResult, ErrorCode: Integer;

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
          MsgBox(Format(CustomMessage('VersionAlreadyInstalled'), [OldVersion]), mbInformation, MB_OK);
          Result := False;
        end;

      VERSION_NEWER:
        begin
          Result := (MsgBox(Format(CustomMessage('PreviousVersionUninstall'), [OldVersion]), mbConfirmation, MB_YESNO) = IDYES);
          if Result then               
            if GetUninstallCommand(RootKey, RegistryKey, UninstallExecutable, UninstallParameters) then
            begin
              Log(Format('UninstallExecutable: "%s", UninstallParameters: "%s"', [UninstallExecutable, UninstallParameters]));    
              if not Exec(UninstallExecutable, UninstallParameters, '', SW_HIDE, ewWaitUntilTerminated, ErrorCode) then
                Result := (MsgBox(Format(CustomMessage('PreviousVersionUninstallFailed'), [OldVersion, ErrorCode]), mbError, MB_YESNO) = IDYES);
            end
            else
              Result := (MsgBox(Format(CustomMessage('PreviousVersionUninstallUnableToGetCommand'), [OldVersion]), mbCriticalError, MB_YESNO) = IDYES);            
        end; // VERSION_NEWER

     end; // case
  end; // RegKeyExists
end;
