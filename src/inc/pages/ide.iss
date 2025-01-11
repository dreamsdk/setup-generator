[Code]
type
  TCodeBlocksPatcherOperation = (cbpInstall, cbpUninstall);

const  
  CB_HELPER_FILE = '{tmp}\cbhelper.exe';
  CB_PATCH_FILE = '{app}\msys\1.0\opt\dreamsdk\packages\ide\codeblocks\codeblocks-patcher.exe';
   
  CB_BACKUP_DIR = '{app}\support\ide\codeblocks';
        
var
  IntegratedDevelopmentEnvironmentPage: TWizardPage;
  EditCodeBlocksInstallationDirectory: TEdit;
  EditCodeBlocksUsersList: TMemo;
  ButtonCodeBlocksRefreshUsersList,
  ButtonCodeBlocksInitialize: TButton;
  LabelCodeBlocksDetectedVersion: TLabel;

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

procedure HandleCodeBlocksUsersList(InitializeProfiles: Boolean);
var
  Switches: String;

begin
  WizardForm.NextButton.Enabled := False;
  ButtonCodeBlocksRefreshUsersList.Enabled := False;
  ButtonCodeBlocksInitialize.Enabled := False;  
  
  Switches := '';
  if InitializeProfiles then
    Switches := '--initialize ';

  Switches := Switches + '--get-available-users';

  EditCodeBlocksUsersList.Text := RunCommand( Format('%s %s', [
      ExpandConstant(CB_HELPER_FILE),
      Switches
    ]),
    False
  );
  
  ButtonCodeBlocksInitialize.Enabled := True;
  ButtonCodeBlocksRefreshUsersList.Enabled := True;
  WizardForm.NextButton.Enabled := True;
end;

procedure RetrieveCodeBlocksUsersList;
begin
  HandleCodeBlocksUsersList(False);
end;

procedure InitializeCodeBlocks;
begin
  HandleCodeBlocksUsersList(True);
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

  Buffer := RunCommand(
    Format('"%s" --operation=%s --home-dir="%s" %s --no-logo --show-splash --verbose', [
      ExpandConstant(CB_PATCH_FILE),
      PatcherSwitch,
      ExpandConstant('{app}'),
      ParamExtraOption
    ]),
    False
  );
            
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
    ]),
    False
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

function GetCodeBlocksVersion: String;
begin  
  Result := RunCommand(
    Format('%s %s "%s"', [
      ExpandConstant(CB_HELPER_FILE),
      '--version',
      GetCodeBlocksInstallationDirectory 
    ]),
    True
  );
end;

function RetrieveCodeBlocksVersion: String;
begin
  Result := GetCodeBlocksVersion;
  LabelCodeBlocksDetectedVersion.Caption :=
    Format(CustomMessage('LabelCodeBlocksDetectedVersion'), [Result]);
end;

procedure ButtonCodeBlocksInstallationDirectoryOnClick(Sender: TObject);
var
  Directory: String;

begin
  Directory := GetCodeBlocksInstallationDirectory;
  BrowseForFolderEx(Directory);
  EditCodeBlocksInstallationDirectory.Text := Directory;
  RetrieveCodeBlocksVersion;
end;

procedure ButtonCodeBlocksInitializeOnClick(Sender: TObject);
begin  
  if MsgBox(CustomMessage('CodeBlocksInitializeConfirmation'), mbError, MB_YESNO or MB_DEFBUTTON2) = IDYES then
    InitializeCodeBlocks;
end;

procedure ButtonCodeBlocksRefreshUsersListOnClick(Sender: TObject);
begin
  RetrieveCodeBlocksUsersList;
  RetrieveCodeBlocksVersion;
end;

procedure EditCodeBlocksInstallationDirectoryOnChange(Sender: TObject);
begin
  LabelCodeBlocksDetectedVersion.Caption := '';
end;

function IsCodeBlocksIntegrationReady: Boolean;
var
  CodeBlocksVersion: String;

begin
  Result := True;

  // Check existence of the installation folder
  if not DirExists(GetCodeBlocksInstallationDirectory) then
  begin
    Result := False;
    MsgBox(CustomMessage('CodeBlocksInstallationDirectoryNotExists'), mbError, MB_OK);
    Exit;
  end;

  // Handle the detected C::B version
  CodeBlocksVersion := RetrieveCodeBlocksVersion;
  if CodeBlocksVersion = '(Undetected)' then
  begin
    // C::B is not installed in this directory
    Result := False;
    MsgBox(CustomMessage('CodeBlocksBinaryFileNameNotExists'), mbError, MB_OK);
  end
  else if CodeBlocksVersion = '(Unknown)' then
  begin
    // C::B is installed, but its version is unknown
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

function GetCodeBlocksDefaultInstallationDirectory: String;
begin  
  Result := RunCommand(
    Format('%s %s', [
      ExpandConstant(CB_HELPER_FILE),
      '--detect'      
    ]),
    True
  );
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
  EditCodeBlocksInstallationDirectory.Text := ExpandConstant(GetCodeBlocksDefaultInstallationDirectory);
  EditCodeBlocksInstallationDirectory.Width := IntegratedDevelopmentEnvironmentPage.SurfaceWidth 
    - ButtonCodeBlocksInstallationDirectory.Width - ScaleX(8);
  EditCodeBlocksInstallationDirectory.Top := RowTop1;
  EditCodeBlocksInstallationDirectory.Parent := IntegratedDevelopmentEnvironmentPage.Surface;
  EditCodeBlocksInstallationDirectory.OnChange := @EditCodeBlocksInstallationDirectoryOnChange;

  // LabelCodeBlocksDetectedVersion
  LabelCodeBlocksDetectedVersion := TLabel.Create(IntegratedDevelopmentEnvironmentPage);
  LabelCodeBlocksDetectedVersion.Font.Style := [fsBold];
  LabelCodeBlocksDetectedVersion.AutoSize := True;
  LabelCodeBlocksDetectedVersion.Top := EditCodeBlocksInstallationDirectory.Top 
    + EditCodeBlocksInstallationDirectory.Height + ScaleY(4);
  LabelCodeBlocksDetectedVersion.Parent := IntegratedDevelopmentEnvironmentPage.Surface; 

  RowTop2 := EditCodeBlocksInstallationDirectory.Top + 
    EditCodeBlocksInstallationDirectory.Height + ScaleY(24);

  // Label for Refresh button and Users List
  LabelCodeBlocksConfigurationFiles := TLabel.Create(IntegratedDevelopmentEnvironmentPage);
  LabelCodeBlocksConfigurationFiles.Caption := 
    CustomMessage('LabelCodeBlocksConfigurationFiles');   
  LabelCodeBlocksConfigurationFiles.Top := RowTop2;
  LabelCodeBlocksConfigurationFiles.Parent := IntegratedDevelopmentEnvironmentPage.Surface;
  SetMultiLinesLabel(LabelCodeBlocksConfigurationFiles, 3);

  // ButtonCodeBlocksInitialize
  ButtonCodeBlocksInitialize := TButton.Create(IntegratedDevelopmentEnvironmentPage);
  ButtonCodeBlocksInitialize.Width := ScaleX(75);
  ButtonCodeBlocksInitialize.Height := ScaleY(23);
  ButtonCodeBlocksInitialize.Top := RowTop2 + (ButtonCodeBlocksInitialize.Height div 2) 
    - (ButtonCodeBlocksInitialize.Height div 2);
  ButtonCodeBlocksInitialize.Left := IntegratedDevelopmentEnvironmentPage.SurfaceWidth 
    - ButtonCodeBlocksInitialize.Width; 
  ButtonCodeBlocksInitialize.Caption :=
    CustomMessage('ButtonCodeBlocksInitialize');
  ButtonCodeBlocksInitialize.OnClick := @ButtonCodeBlocksInitializeOnClick;
  ButtonCodeBlocksInitialize.Parent := IntegratedDevelopmentEnvironmentPage.Surface;

  // Refresh Code::Blocks Users List
  ButtonCodeBlocksRefreshUsersList := TButton.Create(IntegratedDevelopmentEnvironmentPage);
  ButtonCodeBlocksRefreshUsersList.Width := ScaleX(75);
  ButtonCodeBlocksRefreshUsersList.Height := ScaleY(23);
  ButtonCodeBlocksRefreshUsersList.Top := ButtonCodeBlocksInitialize.Top 
    + ButtonCodeBlocksInitialize.Height + ScaleY(2);
  ButtonCodeBlocksRefreshUsersList.Left := IntegratedDevelopmentEnvironmentPage.SurfaceWidth 
    - ButtonCodeBlocksRefreshUsersList.Width; 
  ButtonCodeBlocksRefreshUsersList.Caption := 
    CustomMessage('ButtonRefresh');
  ButtonCodeBlocksRefreshUsersList.OnClick := @ButtonCodeBlocksRefreshUsersListOnClick;
  ButtonCodeBlocksRefreshUsersList.Parent := IntegratedDevelopmentEnvironmentPage.Surface;
  
  // Update LabelCodeBlocksConfigurationFiles 
  LabelCodeBlocksConfigurationFiles.Width := 
    LabelCodeBlocksConfigurationFiles.Width - ButtonCodeBlocksRefreshUsersList.Width - ScaleX(4);

  // EditCodeBlocksUsersList
  EditCodeBlocksUsersList := TNewMemo.Create(IntegratedDevelopmentEnvironmentPage);
  EditCodeBlocksUsersList.Top := LabelCodeBlocksConfigurationFiles.Top 
    + LabelCodeBlocksConfigurationFiles.Height + ScaleY(12);
  EditCodeBlocksUsersList.Width := IntegratedDevelopmentEnvironmentPage.SurfaceWidth;
  EditCodeBlocksUsersList.Height := ScaleY(64);
  EditCodeBlocksUsersList.ScrollBars := ssVertical;  
  EditCodeBlocksUsersList.ReadOnly := True;
  EditCodeBlocksUsersList.Color := clBtnFace;
  EditCodeBlocksUsersList.Parent := IntegratedDevelopmentEnvironmentPage.Surface;   

  RetrieveCodeBlocksUsersList;
  RetrieveCodeBlocksVersion;

  Result := IntegratedDevelopmentEnvironmentPage.ID;
end;
