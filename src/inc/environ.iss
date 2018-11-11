[Code]
// https://stackoverflow.com/a/46609047/3726096

type
  TEnvironmentVariableOperation = (evoAdd, evoRemove);

const
	EnvironmentKey = 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment';

function IsUselessOperation(const Operation: TEnvironmentVariableOperation;
  const Paths: String; const IsPathAdded: Boolean): Boolean;
var
  IsAddUseless,
  IsRemoveUseless: Boolean;

begin
  IsRemoveUseless := (Operation = evoRemove) and ((Paths = '') or (not IsPathAdded));
  IsAddUseless := (Operation = evoAdd) and (IsPathAdded);
  Result := IsRemoveUseless or IsAddUseless;
end;

procedure HandlePathEnvironmentVariable(const Path: String;
  const Operation: TEnvironmentVariableOperation);
var
  Buffer: TStringList;
  i: Integer;
  IsPathAdded: Boolean;
  Paths, LogSuccess, LogFailed: String;

begin
  // Retrieve current path (use empty string if entry not exists)
  if not RegQueryStringValue(HKEY_LOCAL_MACHINE, EnvironmentKey, 'Path', Paths) then
    Paths := '';

  // Check if the Path is already present or not
  IsPathAdded := Pos(';' + UpperCase(Path) + ';', ';' + UpperCase(Paths) + ';') > 0;

  // Check if we have something to do
  if IsUselessOperation(Operation, Paths, IsPathAdded) then
    Exit;

  // Proceed the Path
  Buffer := TStringList.Create;
  try
    StringChangeEx(Paths, ';', sLineBreak, True);
    Buffer.Text := Paths;
    
    { App string to the end of the path variable }
    if (Operation = evoAdd) then    
      Buffer.Add(Path)
    else
    begin
      i := Buffer.IndexOf(Path);
      if (i <> -1) then
        Buffer.Delete(i); 
    end;
    
    // Remove useless blank lines
    for i := Buffer.Count - 1 downto 0 do
      if (Buffer[i] = '') then 
        Buffer.Delete(i);
     
    // Regenerate Paths variable   
    Paths := Buffer.Text; 
    StringChangeEx(Paths, sLineBreak, ';', True); 
  finally
    Buffer.Free;
  end;
  
  // Generate Log messages
  LogSuccess := CustomMessage('LogAddPathVariableSuccess');
  LogFailed := CustomMessage('LogAddPathVariableFailed');
  if Operation = evoRemove then
  begin
    LogSuccess := CustomMessage('LogRemovePathVariableSuccess');
    LogFailed := CustomMessage('LogRemovePathVariableFailed');   
  end;

  // Overwrite (or create if missing) path environment variable
  if RegWriteStringValue(HKEY_LOCAL_MACHINE, EnvironmentKey, 'Path', Paths) then
    Log(Format(LogSuccess, [Path, Paths]))
  else
    Log(Format(LogFailed, [Path, Paths])); 
end;

procedure EnvAddPath(const Path: String);
begin
  HandlePathEnvironmentVariable(Path, evoAdd);  
end;

procedure EnvRemovePath(const Path: String);
begin
  HandlePathEnvironmentVariable(Path, evoRemove);
end;