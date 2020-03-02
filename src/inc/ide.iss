[Code]
type
  TCodeBlocksPatcherOperation = (cbpInstall, cbpUninstall);

const
  CODEBLOCKS_SDK_DLL_SHA1 = 'bea660dd5dbfca817e6d06a0be04b2e7de5da34f';
  CODEBLOCKS_SDK_DLL_FILE = '\codeblocks.dll';    

  DEFAULT_CB_INSTALL_DIR = '{pf32}\CodeBlocks';
  
  CB_HELPER_FILE = '{tmp}\cbhelper.exe';
  CB_PATCH_FILE = '{app}\msys\1.0\opt\dreamsdk\packages\ide\codeblocks\codeblocks-patcher.exe';
   
  CB_BACKUP_DIR = '{app}\support\ide\codeblocks';
        
var
  IntegratedDevelopmentEnvironmentPage: TWizardPage;
  EditCodeBlocksInstallationDirectory: TEdit;
  EditCodeBlocksUsersList: TMemo;
  ButtonCodeBlocksRefreshUsersList: TButton;

function IsCodeBlocksIntegrationEnabled: Boolean;
begin
  Result := IsComponentSelected('ide\codeblocks');
end;

function IsCodeBlocksInstallationMode: Boolean;
begin
  Result := Assigned( EditCodeBlocksInstallationDirectory );
end;

function IsCodeBlocksUsersAvailable: Boolean;
begin
  Result := (EditCodeBlocksUsersList.Lines.Count > 0);
end;

function GetCodeBlocksInstallationDirectory: String;
begin                        
  Result := '';   
  if IsCodeBlocksInstallationMode then
    Result := RemoveBackslash(EditCodeBlocksInstallationDirectory.Text); 
end;

procedure RetrieveCodeBlocksUsersList;
begin
  WizardForm.NextButton.Enabled := False;
  ButtonCodeBlocksRefreshUsersList.Enabled := False;  
  
  EditCodeBlocksUsersList.Text := RunCommand( Format('%s %s', [
      ExpandConstant(CB_HELPER_FILE),
      '--get-available-users' 
    ])
  );
  
  ButtonCodeBlocksRefreshUsersList.Enabled := True;
  WizardForm.NextButton.Enabled := True;
end;

function RunCodeBlocksPatcher(const Operation: TCodeBlocksPatcherOperation;
  var Buffer: String): Boolean;
var
  PatcherSwitch,
  ParamExtraOption: string;

begin
  PatcherSwitch := 'uninstall';

  if IsCodeBlocksInstallationMode then
  begin
    PatcherSwitch := 'install';
    ParamExtraOption := Format('--install-dir="%s" --backup-dir="%s"', [
      GetCodeBlocksInstallationDirectory,      
      ExpandConstant(CB_BACKUP_DIR)
    ]);
  end;

  Buffer := RunCommand(Format('"%s" --operation=%s --home-dir="%s" %s --no-logo --show-splash --verbose', [
    ExpandConstant(CB_PATCH_FILE),
    PatcherSwitch,
    ExpandConstant('{app}'),
    ParamExtraOption
  ]));
            
  Result := IsInString('is now ', Buffer);
end;
                                                                                 
procedure InstallCodeBlocksIntegration;
var
  Buffer: String;
  IsSuccess: Boolean;

begin
  // Cleanup previous C::B for DreamSDK install if necessary
  RunCommand(
    Format('%s %s', [
      ExpandConstant(CB_HELPER_FILE),
      '--cleanup' 
    ])
  );
  
  // Executing the Patcher  
  IsSuccess := RunCodeBlocksPatcher(cbpInstall, Buffer);
  if not IsSuccess then
    MsgBox(Format(CustomMessage('CodeBlocksIntegrationSetupFailed'), [Buffer]), mbCriticalError, MB_OK);
end;

procedure UninstallCodeBlocksIntegration;
var
  Buffer: String;
  IsSuccess: Boolean;

begin
  IsSuccess := RunCodeBlocksPatcher(cbpUninstall, Buffer);
  IsSuccess := IsSuccess or IsInString('nothing to uninstall', Buffer);
  if not IsSuccess then
    MsgBox(Format(CustomMessage('CodeBlocksIntegrationRemoveFailed'), [Buffer]), mbCriticalError, MB_OK); 
end;

procedure ButtonCodeBlocksInstallationDirectoryOnClick(Sender: TObject);
var
  Directory: String;

begin
  Directory := GetCodeBlocksInstallationDirectory;
  BrowseForFolderEx(Directory);
  EditCodeBlocksInstallationDirectory.Text := Directory;
end;

procedure ButtonCodeBlocksRefreshUsersListOnClick(Sender: TObject);
begin
  RetrieveCodeBlocksUsersList;
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

  // Check if the users are available
  if not IsCodeBlocksUsersAvailable then
  begin
    Result := False;
    MsgBox(CustomMessage('CodeBlocksInstallationUsersUnavailable'), mbError, MB_OK);
    Exit;
  end;
end;

function CreateIntegratedDevelopmentEnvironmentPage: Integer;
var
  ButtonCodeBlocksInstallationDirectory: TButton;
  LabelCodeBlocksIntroduction, LabelCodeBlocksInstallationDirectory, 
  LabelCodeBlocksConfigurationFiles: TLabel;
  RowTop1, RowTop2: Integer;
  BtnImage: TBitmapImage;

begin
  ExtractTemporaryFile('cbhelper.exe');

  IntegratedDevelopmentEnvironmentPage := CreateCustomPage(wpSelectComponents,
    CustomMessage('CodeBlocksTitlePage'),
    CustomMessage('CodeBlocksSubtitlePage'));

  BtnImage := SetPageIcon('codeblocks', IntegratedDevelopmentEnvironmentPage);

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

  RowTop2 := EditCodeBlocksInstallationDirectory.Top + 
    EditCodeBlocksInstallationDirectory.Height + ScaleY(16);

  // Label for CodeBlocksInstallationDirectory
  LabelCodeBlocksConfigurationFiles := TLabel.Create(IntegratedDevelopmentEnvironmentPage);
  LabelCodeBlocksConfigurationFiles.Caption := 
    CustomMessage('LabelCodeBlocksConfigurationFiles');   
  LabelCodeBlocksConfigurationFiles.Top := RowTop2;
  LabelCodeBlocksConfigurationFiles.Parent := IntegratedDevelopmentEnvironmentPage.Surface;
  SetMultiLinesLabel(LabelCodeBlocksConfigurationFiles, 3);

  // Refresh Code::Blocks Users List
  ButtonCodeBlocksRefreshUsersList := TButton.Create(IntegratedDevelopmentEnvironmentPage);
  ButtonCodeBlocksRefreshUsersList.Width := ScaleX(75);
  ButtonCodeBlocksRefreshUsersList.Height := ScaleY(23);
  ButtonCodeBlocksRefreshUsersList.Top := RowTop2 + (LabelCodeBlocksConfigurationFiles.Height div 2) 
    - (ButtonCodeBlocksRefreshUsersList.Height div 2);
  ButtonCodeBlocksRefreshUsersList.Left := IntegratedDevelopmentEnvironmentPage.SurfaceWidth 
    - ButtonCodeBlocksRefreshUsersList.Width; 
  ButtonCodeBlocksRefreshUsersList.Caption := 
    CustomMessage('ButtonRefresh');
  ButtonCodeBlocksRefreshUsersList.OnClick := @ButtonCodeBlocksRefreshUsersListOnClick;
  ButtonCodeBlocksRefreshUsersList.Parent := IntegratedDevelopmentEnvironmentPage.Surface;
  LabelCodeBlocksConfigurationFiles.Width := 
    LabelCodeBlocksConfigurationFiles.Width - ButtonCodeBlocksRefreshUsersList.Width - ScaleX(4);

  // EditCodeBlocksUsersList
  EditCodeBlocksUsersList := TNewMemo.Create(IntegratedDevelopmentEnvironmentPage);
  EditCodeBlocksUsersList.Top := LabelCodeBlocksConfigurationFiles.Top 
    + LabelCodeBlocksConfigurationFiles.Height + ScaleY(8);
  EditCodeBlocksUsersList.Width := IntegratedDevelopmentEnvironmentPage.SurfaceWidth;
  EditCodeBlocksUsersList.Height := ScaleY(80);
  EditCodeBlocksUsersList.ScrollBars := ssVertical;  
  EditCodeBlocksUsersList.ReadOnly := True;
  EditCodeBlocksUsersList.Color := clBtnFace;
  EditCodeBlocksUsersList.Parent := IntegratedDevelopmentEnvironmentPage.Surface;   

  RetrieveCodeBlocksUsersList;

  Result := IntegratedDevelopmentEnvironmentPage.ID;
end;
