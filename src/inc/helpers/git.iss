[Code]

function AddGitSafeDirectory(Directory: String): Boolean;
var
  Executable,
  CommandLine: String;
  ResultCode: Integer;

begin
  Result := False;
  
  Directory := ExpandConstant(
    Format('{code:GetApplicationToolchainBasePath}\%s', [Directory]));
  StringChangeEx(Directory, '\', '/', True);  
       
  Log(Format('AddGitSafeDirectory [Directory: "%s"]', [
    Directory
  ]));
  
  Executable := 'git';                                        
  CommandLine := Format('config --system --add safe.directory %s', [Directory]);
  Log(Format('  Executable: "%s", CommandLine: [%s]', [Executable, CommandLine]));  
  
  Result := Exec(Executable, CommandLine, '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  Log(Format('  Result: %d', [Result]));
end;
