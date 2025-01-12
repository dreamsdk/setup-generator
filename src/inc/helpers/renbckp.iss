[Code]

const
  RENBCKP_HELPER_FILE = 'renbckp.exe';    

function RenameFileOrDirectoryAsBackup(TargetFileOrDirectory: String): Boolean;
var
  RenameBackupHelperFileName: String;
  Buffer: String;

begin
  Result := True;
  if FileExists(TargetFileOrDirectory) or DirExists(TargetFileOrDirectory) then
  begin
    RenameBackupHelperFileName := ExpandConstant('{tmp}\' + RENBCKP_HELPER_FILE);
    if not FileExists(RenameBackupHelperFileName) then
      ExtractTemporaryFile(RENBCKP_HELPER_FILE);  
    Buffer := RunCommand(
      Format('"%s" "%s"', [
        RenameBackupHelperFileName,
        TargetFileOrDirectory
      ]),
      True
    );
    Result := not IsInString('Error: ', Buffer);
  end;
end;
