[Code]
type
  TCodeBlocksPatcherOperation = (cbpInstall, cbpUninstall);

const
  CODEBLOCKS_SDK_DLL_SHA1 = 'bea660dd5dbfca817e6d06a0be04b2e7de5da34f';
  CODEBLOCKS_SDK_DLL_FILE = '\codeblocks.dll';    

  DEFAULT_CB_INSTALL_DIR = '{pf32}\CodeBlocks';
  DEFAULT_CB_CONFIG_FILE = 'CodeBlocks\default.conf';
  
  CB_PATCH_DIR = '{app}\msys\1.0\opt\dreamsdk\packages\ide\codeblocks';
  
  CB_PATCHER_FILE = '\codeblocks-patcher.exe';

  CB_HELPER = '{tmp}\codeblocks-helper.exe';
          
var
  IntegratedDevelopmentEnvironmentPage: TWizardPage;
  EditCodeBlocksInstallationDirectory: TEdit;

function IsCodeBlocksIntegrationEnabled: Boolean;
begin
  Result := IsComponentSelected('ide\codeblocks');
end;

function IsCodeBlocksInstallationMode: Boolean;
begin
  Result := Assigned(EditCodeBlocksInstallationDirectory);
end;

function GetCodeBlocksInstallationDirectory: String;
var
  Buffer: AnsiString;
  IsInstallMode: Boolean;

begin                        
  Result := '';   
  if IsCodeBlocksInstallationMode then
    Result := RemoveBackslash(EditCodeBlocksInstallationDirectory.Text); 
end;

function GetCodeBlocksConfigurationFileNames: String;
begin
  Result := RunCommand( ExpandConstant(CB_HELPER) );
end;

function RunCodeBlocksPatcher(const Operation: TCodeBlocksPatcherOperation;
  var Buffer: String): Boolean;
var
  PatcherSwitch,
  ParamInstallOption: string;

begin
  PatcherSwitch := 'install';

  if IsCodeBlocksInstallationMode then
  begin
    ParamInstallOption := Format('--install-dir="%s" --home-dir="%s"', [
      GetCodeBlocksInstallationDirectory,
      ExpandConstant('{app}')
    ]);
  end
  else
    PatcherSwitch := 'uninstall';

  Buffer := RunCommand(Format('"%s" --operation=%s %s --no-logo --show-splash', [
    ExpandConstant(CB_PATCH_DIR) + CB_PATCHER_FILE,
    PatcherSwitch,
    ParamInstallOption
  ]));

  Result := (Pos('is now patched!', LowerCase(Buffer)) > 0);
end;
                                                                                 
procedure InstallCodeBlocksIntegration;
var
  Buffer: String;
  IsSuccess: Boolean;

begin    
  IsSuccess := RunCodeBlocksPatcher(cbpInstall, Buffer);
  if not IsSuccess then
    MsgBox(Format(CustomMessage('CodeBlocksIntegrationSetupFailed'), [Buffer]), mbCriticalError, MB_OK);
end;

procedure UninstallCodeBlocksIntegration;
var
  Buffer: String;

begin
  RunCodeBlocksPatcher(cbpUninstall, Buffer); 
end;

procedure ButtonCodeBlocksInstallationDirectoryOnClick(Sender: TObject);
var
  Directory: String;

begin
  Directory := GetCodeBlocksInstallationDirectory;
  BrowseForFolderEx(Directory);
  EditCodeBlocksInstallationDirectory.Text := Directory;
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
end;

function CreateIntegratedDevelopmentEnvironmentPage: Integer;
var
  ButtonCodeBlocksInstallationDirectory, 
  ButtonCodeBlocksConfigurationFile: TButton;
  LabelCodeBlocksIntroduction, LabelCodeBlocksInstallationDirectory, 
  LabelCodeBlocksConfigurationFile,
  LabelCodeBlocksConfigurationFiles: TLabel;
  RowTop1, RowTop2: Integer;
  BtnImage: TBitmapImage;
  EditCodeBlocksUsersList: TMemo;

begin
  ExtractTemporaryFile('codeblocks-helper.exe');

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

  // Label for CodeBlocksInstallationDirectory
  LabelCodeBlocksConfigurationFiles := TLabel.Create(IntegratedDevelopmentEnvironmentPage);
  LabelCodeBlocksConfigurationFiles.Caption := 
    CustomMessage('LabelCodeBlocksInstallationDirectory');
  LabelCodeBlocksConfigurationFiles.AutoSize := True;
  LabelCodeBlocksConfigurationFiles.Top := EditCodeBlocksInstallationDirectory.Top + 
    EditCodeBlocksInstallationDirectory.Height + ScaleY(8);
  LabelCodeBlocksConfigurationFiles.Parent := IntegratedDevelopmentEnvironmentPage.Surface;

  // EditCodeBlocksUsersList
  EditCodeBlocksUsersList := TNewMemo.Create(IntegratedDevelopmentEnvironmentPage);
  EditCodeBlocksUsersList.Top := LabelCodeBlocksConfigurationFiles.Top 
    + LabelCodeBlocksConfigurationFiles.Height + ScaleY(8);
  EditCodeBlocksUsersList.Width := IntegratedDevelopmentEnvironmentPage.SurfaceWidth;
  EditCodeBlocksUsersList.Height := ScaleY(90);
  EditCodeBlocksUsersList.ScrollBars := ssVertical;
  EditCodeBlocksUsersList.Text := GetCodeBlocksConfigurationFileNames;
  EditCodeBlocksUsersList.ReadOnly := True;
  EditCodeBlocksUsersList.Color := clGreen;
  EditCodeBlocksUsersList.Parent := IntegratedDevelopmentEnvironmentPage.Surface;   

  Result := IntegratedDevelopmentEnvironmentPage.ID;
end;
