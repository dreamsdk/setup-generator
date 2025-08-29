[Code]

function GetMakeDirectoryLinkFileName: String;
begin
  Result := ExpandConstant('{code:GetApplicationHelpersPath}\mkdirln.exe');
end;

// Create a directory junction (equivalent to symbolic link)
function CreateJunction(SourceDirectoryPath, TargetDirectoryPath: String): Boolean;
var
  Executable,
  CommandLine: String;
  ResultCode: Integer;

begin
  Result := False;
  
  SourceDirectoryPath := ExpandConstant(SourceDirectoryPath);
  TargetDirectoryPath := ExpandConstant(TargetDirectoryPath);
    
  Log(Format('CreateJunction [SourceDirectoryPath: "%s", TargetDirectoryPath: "%s"]', [
    SourceDirectoryPath,
    TargetDirectoryPath
  ]));
  
  if DirExists(SourceDirectoryPath) then
  begin
    Executable := GetMakeDirectoryLinkFileName;
    if FileExists(Executable) then
    begin
      CommandLine := Format('create "%s" "%s"', [TargetDirectoryPath, SourceDirectoryPath]);
      Log(Format('  Executable: "%s", CommandLine: [%s]', [Executable, CommandLine]));
      
      Result := Exec(Executable, CommandLine, '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
      Log(Format('  Result: %d, ResultCode: %d', [Result, ResultCode]));	 
	  Result := Result and (ResultCode = 0);
    end
    else
      Result := True;
  end;
end;

// Remove/delete a directory junction (equivalent to symbolic link)
function RemoveJunction(TargetDirectoryPath: String): Boolean;
var
  Executable,
  CommandLine: String;
  ResultCode: Integer;

begin
  Result := False;
  
  TargetDirectoryPath := ExpandConstant(TargetDirectoryPath);
    
  Log(Format('RemoveJunction [TargetDirectoryPath: "%s"]', [
    TargetDirectoryPath
  ]));
  
  if DirExists(TargetDirectoryPath) then
  begin
    Executable := GetMakeDirectoryLinkFileName;
    if FileExists(Executable) then
    begin
      CommandLine := Format('remove "%s"', [TargetDirectoryPath]);
      Log(Format('  Executable: "%s", CommandLine: [%s]', [Executable, CommandLine]));
      
      Result := Exec(Executable, CommandLine, '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
      Log(Format('  Result: %d, ResultCode: %d', [Result, ResultCode]));
	  Result := Result and (ResultCode = 0);	  
    end
    else
      Result := True;
  end;
end;
