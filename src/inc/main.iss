[Code]

const
  // This should match the [Types] section of this file.
  TYPES_COMBO_ITEMINDEX_FULL_INSTALLATION_WITHOUT_IDE = 0;
  TYPES_COMBO_ITEMINDEX_FULL_INSTALLATION = 1;
  TYPES_COMBO_ITEMINDEX_COMPACT_INSTALLATION = 2;
  TYPES_COMBO_ITEMINDEX_CUSTOM_INSTALLATION = 3;

  CODEBLOCKS_EXE_NAME = 'codeblocks.exe';

var
  BrowseForFolderExFakePageID,
  IntegratedDevelopmentEnvironmentSettingsPageID, 
  GdbPageID,
  KallistiEmbeddedPageID,
  RubyPageID,
  ToolchainsPageID,
  FoundationPageID: Integer;

  ComponentsListDisabledItemsCount,
  ComponentsListItemsCountWithoutIde: Integer;  

procedure ComponentsListCheckChanges;
var
  SelectedComponentsCount,
  ComponentsCount: Integer;  

begin
  SelectedComponentsCount := GetSelectedComponentsCount;
  ComponentsCount := GetComponentsListCount;

  Log(Format('Components List Status: %d selected of %d', [SelectedComponentsCount, ComponentsCount]));
  
  if (SelectedComponentsCount = ComponentsCount) then
    WizardForm.TypesCombo.ItemIndex := TYPES_COMBO_ITEMINDEX_FULL_INSTALLATION
  else if (SelectedComponentsCount = ComponentsListDisabledItemsCount) then
    WizardForm.TypesCombo.ItemIndex := TYPES_COMBO_ITEMINDEX_COMPACT_INSTALLATION
  else if not IsComponentSelected('{#IdeComponentsListName}') and (SelectedComponentsCount = ComponentsListItemsCountWithoutIde) then
    WizardForm.TypesCombo.ItemIndex := TYPES_COMBO_ITEMINDEX_FULL_INSTALLATION_WITHOUT_IDE
  else
    WizardForm.TypesCombo.ItemIndex := TYPES_COMBO_ITEMINDEX_CUSTOM_INSTALLATION;
end;

procedure ComponentsListClickCheck(Sender: TObject);
begin
  ComponentsListCheckChanges;
end;

procedure HandleComponentsListTypesCombo;
begin
  // Thanks to: https://stackoverflow.com/a/36989894/3726096
  WizardForm.ComponentsList.OnClickCheck := @ComponentsListClickCheck;
end;

function IsModulesRunning: Boolean;
begin
  Result := False;

  // Check if Code::Blocks is running
  Result := IsProcessRunning(CODEBLOCKS_EXE_NAME);
  if Result then
  begin
    MsgBox(CustomMessage('CodeBlocksRunning'), mbError, MB_OK);
    Exit;    
  end;   
end;

function InitializeSetup: Boolean;
begin
  Result := True;
  SetUninstallMode(False);
  GlobalInitialization;

  // Check modules running
  if IsModulesRunning then
  begin
    Result := False;
    Exit;
  end;

#if InstallerMode == DEBUG && DebugUninstallHandlingMode == UNINSTALL_IGNORED
  // Ignore uninstallation of a previous version; if requested
  // Of course, only if installer is in DEBUG mode
  Result := True;
#else
  // This test should be the latest!
  // Check if an old version is installed
  Result := Result
    and HandlePreviousVersion('{#MyAppID}', '{#PackageVersion}');
#endif
end;

procedure FinalizeSetup;
begin
  SaveFoundationToFile;
  SetPackageVersion;
  PatchMountPoint;
  SetupApplication;
  CreateJunctions;
  AddGitSafeDirectories;
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;
  
  // Select Directory Page
  if (CurPageID = wpSelectDir) then
  begin
    // Avoid spaces in the Installation Path  
    Result := (Pos(' ', WizardDirValue) = 0);
    if not Result then
    begin
      MsgBox(CustomMessage('InstallationDirectoryContainSpaces'), mbError, MB_OK);
      Exit;
    end;
    SetWizardDirValueInitialized(True);
  end;

  // Toolchains Page
  if (CurPageID = ToolchainsPageID) then
  begin
    if IsModernWindowsForToolchain and (not IsSelectedToolchainForModernWindowsOnly) then
    begin
      Result := ConfirmLegacyToolchainsUsage;
      if not Result then
        Exit;
    end;

    if (not IsModernWindowsForToolchain) and IsSelectedToolchainForModernWindowsOnly then
    begin
      Result := ConfirmModernToolchainsUsage;
      if not Result then
        Exit;
    end;
  end;

  // Ruby Page
  if (CurPageID = RubyPageID) then
  begin
    if IsRubyEnabled then
    begin
      // Check Ruby prerequisites
      Result := CheckRubyPrerequisites;
      if not Result then
        Exit;

      // Sure to continue?
      Result := ConfirmRubyUsage;
      if not Result then
        Exit;
    end;  
  end;
  
  // KallistiOS Page
  if (CurPageID = KallistiEmbeddedPageID) then
  begin
    // Checking if the user is SURE to use the embedded KOS
    if IsKallistiEmbedded then
    begin
      { Offline }     

      // Check mandatory prerequisites
      Result := CheckOfflinePrerequisitesMandatory;
      if not Result then
        Exit;

      // Check optional prerequisites
      Result := CheckOfflinePrerequisitesOptional;
      if not Result then      
        Exit;
        
      // Sure to continue?
      Result := ConfirmKallistiEmbeddedUsage;
      if not Result then
        Exit;             
    end
    else
    begin
      { Online }
      
      // Check Internet connection
      Result := CheckInternetConnection;
      if not Result then 
        Exit;

      // Check mandatory prerequisites
      Result := CheckOnlinePrerequisitesMandatory;
      if not Result then
        Exit;

      // Check optional prerequisites
      Result := CheckOnlinePrerequisitesOptional;
      if not Result then      
        Exit;
    end;
  end;

  // Foundation Page
  if (CurPageID = FoundationPageID) then
  begin
    if IsFoundationMinGW and IsFoundationPossibleMinGW64 then
    begin      
      // Sure to continue?
      Result := ConfirmFoundationMinGW;
      if not Result then
        Exit;      
    end;       
  end;

  // Code::Blocks Page
  if (CurPageID = IntegratedDevelopmentEnvironmentSettingsPageID) then
  begin
    // Checking if the Code::Blocks Integration page is well filled
    Result := IsCodeBlocksIntegrationEnabled and IsCodeBlocksIntegrationReady;
  end;

  // Finalizing the installation.
  if (CurPageID = wpInfoAfter) then
  begin
    WizardForm.NextButton.Enabled := False;

    // Install Code::Blocks Integration if requested.
    if IsCodeBlocksIntegrationEnabled then
      InstallCodeBlocksIntegration;

    // Patch fstab and setup KallistiOS.
    FinalizeSetup;

    WizardForm.NextButton.Enabled := True;
  end;
end;

function ShouldSkipPage(PageID: Integer): Boolean;
begin 
  Result := False;

  // Always skip BrowseForFolderExFakePage...
  if (PageID = BrowseForFolderExFakePageID) then
    Result := True;

  // Display Foundation Page only if we have the choice to use MinGW64
  if (PageID = FoundationPageID) then
  begin
    Result := not IsFoundationPossibleMinGW64;
    if Result then 
      Log('Skipping Foundation Page as we are using pre-Windows 10+');
  end;
    
  // Display IDE Page only if needed
  if (PageID = IntegratedDevelopmentEnvironmentSettingsPageID) then
  begin
    Result := not IsCodeBlocksIntegrationEnabled;
    if Result then
      Log('Should Skip IDE Page');
  end;
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  case CurPageID of

    ToolchainsPageID:
      begin        
        ToolchainsPageInitialize();
      end;
    
    wpSelectComponents:
      begin
        // Retrieve components name from the ComponentsList
        InitializeComponentsListNames;

        // Get all disabled items from the ComponentsList
        ComponentsListDisabledItemsCount := GetComponentsListDisabledItemsCount;

        // Get the IDE items from the ComponentsList
        ComponentsListItemsCountWithoutIde := 
          GetComponentsListCount - GetComponentRootLevelItemsCount('{#IdeComponentsListName}');

        // Update radio buttons in the Components List
        UpdateFoundation();
        UpdateToolchainSelection();
      end;
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  case CurStep of
    ssInstall:
      begin
#if InstallerMode == DEBUG
        LogCalculatedTargets;
#endif
        RenamePreviousDirectoriesBeforeInstallation;
      end;

    ssPostInstall:
      begin
        if IsTaskSelected('envpath') then
          EnvAddPath(ExpandConstant('{code:GetApplicationMainPath}'));
        if IsTaskSelected('wtconfig') then
          InstallWindowsTerminalIntegration;
      end;

  end;
end;

procedure InitializeWizard;
begin
  // Parse generated configuration
  InitializeRecordArray;

  // Create BrowseForFolderEx component
  BrowseForFolderExFakePageID := CreateBrowseForFolderExFakePage;  

  // Creates pages before Select Components
  // Creates pages in the specified order  
  RubyPageID := CreateRubyPage;
  KallistiEmbeddedPageID := CreateKallistiEmbeddedPage;  
  GdbPageID := CreateGdbPage;
  ToolchainsPageID := CreateToolchainsPage;    
  FoundationPageID := CreateFoundationPage;

  // Create page after Select Components
  IntegratedDevelopmentEnvironmentSettingsPageID := CreateIntegratedDevelopmentEnvironmentPage;

  // Initialize the components list dropdown
  HandleComponentsListTypesCombo;
end;

//=============================================================================
// UNINSTALL
//=============================================================================

function InitializeUninstall: Boolean;
begin
  Result := True;
  SetUninstallMode(True);
  GlobalInitialization;

  // Check modules running
  if IsModulesRunning then
  begin
    Result := False;
    Exit;
  end;

  // Unload the DLL, otherwise the dll is not deleted
  PSVinceUnload;

  // As we are on Uninstall, we can't change the foundation base, but we must
  // retrieve it as this has an impact on the uninstallation
  LoadFoundationFromFile;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  case CurUninstallStep of
    
    usUninstall:
      begin
#if InstallerMode == DEBUG
        LogCalculatedTargets;
#endif
        RemoveFoundationFile;
        RemoveJunctions;
        UninstallCodeBlocksIntegration;
        UninstallWindowsTerminalIntegration;
      end;
    
    usPostUninstall:
      begin
        EnvRemovePath(ExpandConstant('{code:GetApplicationMainPath}'));
      end;

  end;  
end;
