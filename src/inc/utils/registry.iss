[Code]

function GetRegistryValue(const AppID, ValueName: String): String;
var
  RootKey: Integer;
  RegistryKey: String;

begin
  Result := sEmptyStr;
  RootKey := HKEY_LOCAL_MACHINE_32;
  RegistryKey := Format('SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%s_is1', [AppID]);  
  if RegKeyExists(RootKey, RegistryKey) then
  begin
    RegQueryStringValue(RootKey, RegistryKey, ValueName, Result);
  end;
//  Log(Format('GetRegistryValue: ValueName: "%s", Value: "%s"', [ValueName, Result]));  
end;
