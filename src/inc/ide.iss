[Code]
type
  TCodeBlocksBackupRestoreOperation = (cbBackup, cbRestore);
  TCodeBlocksSplashOperation = (soInstall, soUninstall, soClose);

const
  CODEBLOCKS_SDK_DLL_SHA1 = 'bea660dd5dbfca817e6d06a0be04b2e7de5da34f';
  CODEBLOCKS_SDK_DLL_FILE = '\codeblocks.dll';    

  DEFAULT_CB_INSTALL_DIR = '{pf32}\CodeBlocks';
  DEFAULT_CB_CONFIG_FILE = 'CodeBlocks\default.conf';
  
  CB_PATCH_DIR = '{app}\msys\1.0\opt\dreamsdk\packages\ide\codeblocks';
  
  CB_BACKUP_RESTORE_FILE = '\codeblocks-backup-restore.cmd';
  CB_PATCHER_FILE = '\codeblocks-patcher.exe';
  CB_SPLASH_FILE = '\codeblocks-splash.exe';

  CB_INSTALL_DIR_STORE_FILE = '\..\ide.dat';
  
  CB_LIBINFO_DIR = '\share\CodeBlocks\templates\wizard\dc\libinfo';  

var
  IntegratedDevelopmentEnvironmentPage: TWizardPage;
  EditCodeBlocksInstallationDirectory,
  EditCodeBlocksConfigurationFile: TEdit;
  CodeBlocksBackupDirectory,
  CodeBlocksInstallationDirectoryStoreFile: String;

function IsCodeBlocksIntegrationEnabled: Boolean;
begin
  Result := IsComponentSelected('ide\codeblocks');
end;

function GetCodeBlocksInstallationDirectory: String;
var
  Buffer: AnsiString;
  IsInstallMode: Boolean;

begin
  Result := '';

  IsInstallMode := Assigned(EditCodeBlocksInstallationDirectory);   
    
  if IsInstallMode then
  begin
    Result := EditCodeBlocksInstallationDirectory.Text;
    SaveStringToFile(CodeBlocksInstallationDirectoryStoreFile, Result, False);
  end
  else
  begin
    LoadStringFromFile(CodeBlocksInstallationDirectoryStoreFile, Buffer);
    Result := Buffer;
  end;
  
  Result := RemoveBackslash(Result);
end;

function GetCodeBlocksConfigurationFile: String;
begin
  Result := '';
  if Assigned(EditCodeBlocksConfigurationFile) then
    Result := EditCodeBlocksConfigurationFile.Text;
end;

procedure SetCodeBlocksBackupDirectory(ACodeBlocksBackupDirectory: String);
begin
  CodeBlocksBackupDirectory := RemoveBackslash(ACodeBlocksBackupDirectory);
  CodeBlocksInstallationDirectoryStoreFile := CodeBlocksBackupDirectory 
    + CB_INSTALL_DIR_STORE_FILE;
end;

function RunCodeBlocksBackupRestore(const Operation: TCodeBlocksBackupRestoreOperation): Boolean;
var
  Switch,
  Buffer: String;

begin
  Switch := '/B'; 
  if Operation = cbRestore then
    Switch := '/R';

  Buffer := RunCommand(Format('"%s" %s "%s" "%s"', [
    ExpandConstant(CB_PATCH_DIR) + CB_BACKUP_RESTORE_FILE, 
    Switch,
    GetCodeBlocksInstallationDirectory,
    CodeBlocksBackupDirectory
  ]));

  Result := (Pos('done!', LowerCase(Buffer)) > 0);
end;

function RunCodeBlocksPatcher(var Buffer: String): Boolean;
begin
  Buffer := RunCommand(Format('"%s" "%s" "%s" "%s" %s', [
    ExpandConstant(CB_PATCH_DIR) + CB_PATCHER_FILE,
    GetCodeBlocksInstallationDirectory,
    GetCodeBlocksConfigurationFile,
    ExpandConstant('{app}'),
    '--no-logo'
  ]));
  Result := (Pos('is now patched!', LowerCase(Buffer)) > 0);
end;

procedure RunCodeBlocksSplash(const Operation: TCodeBlocksSplashOperation);
var
  AdditionalSwitch: String;
  ResultCode: Integer;
  ExecWait: TExecWait;

begin
  AdditionalSwitch := '';
  ExecWait := ewNoWait;
  
  case Operation of
    soInstall: AdditionalSwitch := '/install';
    soUninstall: AdditionalSwitch := '/uninstall';
    soClose: 
      begin
        AdditionalSwitch := '/close';
        ExecWait := ewWaitUntilTerminated;
      end;
  end;   
  
  Exec(ExpandConstant(CB_PATCH_DIR) + CB_SPLASH_FILE, AdditionalSwitch, 
    ExpandConstant(CB_PATCH_DIR), SW_SHOW, ExecWait, ResultCode)
end;


procedure SetupCodeBlocksIntegration(ACodeBlocksBackupDirectory: String);
var
  Buffer: String;
  IsSuccess: Boolean;

begin
  RunCodeBlocksSplash(soInstall);
  SetCodeBlocksBackupDirectory(ACodeBlocksBackupDirectory);
  ForceDirectories(CodeBlocksBackupDirectory);
  RunCodeBlocksBackupRestore(cbBackup);  
  IsSuccess := RunCodeBlocksPatcher(Buffer);
  if IsSuccess then
    SetDirectoryRights(GetCodeBlocksInstallationDirectory + CB_LIBINFO_DIR, 'S-1-1-0', 'F');  
  RunCodeBlocksSplash(soClose);  
  if not IsSuccess then
    MsgBox(Format(CustomMessage('CodeBlocksIntegrationSetupFailed'), [Buffer]), mbCriticalError, MB_OK);
end;

procedure UninstallCodeBlocksIntegration(ACodeBlocksBackupDirectory: String);
begin  
  SetCodeBlocksBackupDirectory(ACodeBlocksBackupDirectory);  
  if DirExists(CodeBlocksBackupDirectory) then
  begin
    RunCodeBlocksSplash(soUninstall);
    RunCodeBlocksBackupRestore(cbRestore);
    if FileExists(CodeBlocksInstallationDirectoryStoreFile) then
      DeleteFile(CodeBlocksInstallationDirectoryStoreFile);
    RunCodeBlocksSplash(soClose);
  end;  
end;

procedure ButtonCodeBlocksInstallationDirectoryOnClick(Sender: TObject);
var
  Directory: String;

begin
  Directory := GetCodeBlocksInstallationDirectory;
  BrowseForFolderEx(Directory);
  EditCodeBlocksInstallationDirectory.Text := Directory;
end;

procedure ButtonCodeBlocksConfigurationFileOnClick(Sender: TObject);
var
  FileName: String;

begin
  FileName := GetCodeBlocksConfigurationFile;
  if GetOpenFileName('', FileName, '', 
    CustomMessage('FilterCodeBlocksConfigurationFile'), 'conf') then
      EditCodeBlocksConfigurationFile.Text := FileName;  
end;

function IsCodeBlocksIntegrationReady: Boolean;
var
  CodeBlocksBinaryFileName: String;

begin
  Result := True;

  // codeblocks.dll will be used to check if we are on 17.12 stock release
  CodeBlocksBinaryFileName := GetCodeBlocksInstallationDirectory + 
    CODEBLOCKS_SDK_DLL_FILE;

  // Check existence of the installation folder
  if not DirExists(GetCodeBlocksInstallationDirectory) then
  begin
    Result := False;
    MsgBox(CustomMessage('CodeBlocksInstallationDirectoryNotExists'), mbError, MB_OK);
    Exit;
  end;

  // Check if the configuration file exists                                                 
  if not FileExists(GetCodeBlocksConfigurationFile) then
  begin
    Result := False;
    MsgBox(CustomMessage('CodeBlocksConfigurationFileNotExists'), mbError, MB_OK);
    Exit;
  end; 

  // Check if codeblocks.dll exists
  if not FileExists(CodeBlocksBinaryFileName) then
  begin
    Result := False;
    MsgBox(CustomMessage('CodeBlocksBinaryFileNameNotExists'), mbError, MB_OK);
  end
  else if LowerCase(GetSHA1OfFile(CodeBlocksBinaryFileName)) <> CODEBLOCKS_SDK_DLL_SHA1 then
  begin
    // Check if the SHA-1 hash of the codeblocks.dll file is correct
    Result := (MsgBox(CustomMessage('CodeBlocksBinaryHashDifferent'), mbError, MB_YESNO) = IDYES);
  end;
end;

function CreateIntegratedDevelopmentEnvironmentPage: Integer;
var
  ButtonCodeBlocksInstallationDirectory, 
  ButtonCodeBlocksConfigurationFile: TButton;
  LabelCodeBlocksIntroduction, LabelCodeBlocksInstallationDirectory, 
  LabelCodeBlocksConfigurationFile: TLabel;
  RowTop1, RowTop2: Integer;
  BtnImage: TBitmapImage;

begin
  IntegratedDevelopmentEnvironmentPage := CreateCustomPage(wpSelectTasks, 
    CustomMessage('CodeBlocksTitlePage'),
    CustomMessage('CodeBlocksSubtitlePage'));

  ExtractTemporaryFile('codeblocks.bmp');

  BtnImage := TBitmapImage.Create(WizardForm);
  with BtnImage do
  begin
    Parent := IntegratedDevelopmentEnvironmentPage.Surface;
    Bitmap.LoadFromFile(ExpandConstant('{tmp}') + '\codeblocks.bmp');
    Bitmap.AlphaFormat := afPremultiplied; 
    AutoSize := True;
    Left := 0;
    Top := 0;
  end;

  // Introduction label
  LabelCodeBlocksIntroduction := TLabel.Create(IntegratedDevelopmentEnvironmentPage);
  LabelCodeBlocksIntroduction.Caption := 
    CustomMessage('LabelCodeBlocksIntroduction');
  LabelCodeBlocksIntroduction.AutoSize := True;
  LabelCodeBlocksIntroduction.Top := (BtnImage.Height div 2) - (LabelCodeBlocksIntroduction.Height div 2);
  LabelCodeBlocksIntroduction.Left := BtnImage.Height + ScaleX(12);
  LabelCodeBlocksIntroduction.Parent := IntegratedDevelopmentEnvironmentPage.Surface;

  // Label for CodeBlocksInstallationDirectory
  LabelCodeBlocksInstallationDirectory := TLabel.Create(IntegratedDevelopmentEnvironmentPage);
  LabelCodeBlocksInstallationDirectory.Caption := 
    CustomMessage('LabelCodeBlocksInstallationDirectory');
  LabelCodeBlocksInstallationDirectory.AutoSize := True;
  LabelCodeBlocksInstallationDirectory.Top := BtnImage.Top + BtnImage.Height + ScaleY(12);
  LabelCodeBlocksInstallationDirectory.Parent := IntegratedDevelopmentEnvironmentPage.Surface;

  RowTop1 := LabelCodeBlocksInstallationDirectory.Top 
    + LabelCodeBlocksInstallationDirectory.Height + ScaleY(8);

  // Browse for CodeBlocksInstallationDirectory
  ButtonCodeBlocksInstallationDirectory := TButton.Create(IntegratedDevelopmentEnvironmentPage);
  ButtonCodeBlocksInstallationDirectory.Width := ScaleX(75);
  ButtonCodeBlocksInstallationDirectory.Height := ScaleY(23);
  ButtonCodeBlocksInstallationDirectory.Top := RowTop1;
  ButtonCodeBlocksInstallationDirectory.Left := IntegratedDevelopmentEnvironmentPage.SurfaceWidth 
    - ButtonCodeBlocksInstallationDirectory.Width; 
  ButtonCodeBlocksInstallationDirectory.Caption := 
    CustomMessage('ButtonBrowse');
  ButtonCodeBlocksInstallationDirectory.OnClick := @ButtonCodeBlocksInstallationDirectoryOnClick;
  ButtonCodeBlocksInstallationDirectory.Parent := IntegratedDevelopmentEnvironmentPage.Surface;

  // CodeBlocksInstallationDirectory
  EditCodeBlocksInstallationDirectory := TEdit.Create(IntegratedDevelopmentEnvironmentPage);
  EditCodeBlocksInstallationDirectory.Text := ExpandConstant(DEFAULT_CB_INSTALL_DIR);
  EditCodeBlocksInstallationDirectory.Width := IntegratedDevelopmentEnvironmentPage.SurfaceWidth 
    - ButtonCodeBlocksInstallationDirectory.Width - ScaleX(8);
  EditCodeBlocksInstallationDirectory.Top := RowTop1;
  EditCodeBlocksInstallationDirectory.Parent := IntegratedDevelopmentEnvironmentPage.Surface;

  // Label for CodeBlocksConfigurationFile
  LabelCodeBlocksConfigurationFile := TLabel.Create(IntegratedDevelopmentEnvironmentPage);
  LabelCodeBlocksConfigurationFile.Caption := 
    CustomMessage('LabelCodeBlocksConfigurationFile');
  LabelCodeBlocksConfigurationFile.AutoSize := True;
  LabelCodeBlocksConfigurationFile.Top := ButtonCodeBlocksInstallationDirectory.Top 
    + ButtonCodeBlocksInstallationDirectory.Height + ScaleY(8);
  LabelCodeBlocksConfigurationFile.Parent := IntegratedDevelopmentEnvironmentPage.Surface;

  RowTop2 := LabelCodeBlocksConfigurationFile.Top + LabelCodeBlocksConfigurationFile.Height + ScaleY(8);

  // Browse for CodeBlocksConfigurationFile
  ButtonCodeBlocksConfigurationFile := TButton.Create(IntegratedDevelopmentEnvironmentPage);
  ButtonCodeBlocksConfigurationFile.Width := ScaleX(75);
  ButtonCodeBlocksConfigurationFile.Height := ScaleY(23);
  ButtonCodeBlocksConfigurationFile.Top := RowTop2;
  ButtonCodeBlocksConfigurationFile.Left := IntegratedDevelopmentEnvironmentPage.SurfaceWidth 
    - ButtonCodeBlocksInstallationDirectory.Width; 
  ButtonCodeBlocksConfigurationFile.Caption := 
    CustomMessage('ButtonBrowse');
  ButtonCodeBlocksConfigurationFile.OnClick := @ButtonCodeBlocksConfigurationFileOnClick;
  ButtonCodeBlocksConfigurationFile.Parent := IntegratedDevelopmentEnvironmentPage.Surface;

  // CodeBlocksConfigurationFile
  EditCodeBlocksConfigurationFile := TEdit.Create(IntegratedDevelopmentEnvironmentPage);
  EditCodeBlocksConfigurationFile.Text := GetCurrentUserRealAppDataDirectory + DEFAULT_CB_CONFIG_FILE;
  EditCodeBlocksConfigurationFile.Width := IntegratedDevelopmentEnvironmentPage.SurfaceWidth 
    - ButtonCodeBlocksInstallationDirectory.Width - ScaleX(8);
  EditCodeBlocksConfigurationFile.Top := RowTop2;
  EditCodeBlocksConfigurationFile.Parent := IntegratedDevelopmentEnvironmentPage.Surface;

  Result := IntegratedDevelopmentEnvironmentPage.ID;
end;
