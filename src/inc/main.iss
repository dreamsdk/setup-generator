[Code]

var
  BrowseForFolderExFakePageID,
  IntegratedDevelopmentEnvironmentSettingsPageID, 
  GdbPageID,
  KallistiEmbeddedPageID,
  ToolchainsPageID,
  FoundationPageID,
  ShellPageID: Integer;

function InitializeSetup(): Boolean;
begin
  Result := True;
  SetUninstallMode(False);
  GlobalInitialization();

  // Check modules running
  if IsModulesRunning() then
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

procedure FinalizeSetup();
begin
  SaveFoundationToFile();
  SetPackageVersion();  
  ApplyPostInstallPatches();
  SetupApplication();  
  CreateJunctions(); 
  AddGitSafeDirectories();
  SetupPreferredTerminal();
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;
  
  case CurPageID of
    // Select Directory Page
    wpSelectDir:
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
    ToolchainsPageID:
      begin
        // Confirm the choice of the selected Foundation
        ValidateFoundation();
      end;

    // GDB Page
    GdbPageID:
      begin
        Result := GdbCheckUnsupportedPythonUsage();
        if not Result then
          Exit;
      end;
    
    // KallistiOS Page
    KallistiEmbeddedPageID:
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
    FoundationPageID:
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
    IntegratedDevelopmentEnvironmentSettingsPageID:
      begin
        // Checking if the Code::Blocks Integration page is well filled
        Result := IsCodeBlocksIntegrationEnabled and IsCodeBlocksIntegrationReady;
      end;

    // Finalizing the installation.
    wpInfoAfter:
      begin
        WizardForm.NextButton.Enabled := False;

        // Install Code::Blocks Integration if requested.
        if IsCodeBlocksIntegrationEnabled then
          InstallCodeBlocksIntegration;

        // Patch fstab and setup KallistiOS.
        FinalizeSetup();

        WizardForm.NextButton.Enabled := True;
      end;
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
        ToolchainsPageInitialize(False);        
      end;
	  
    GdbPageID:
      begin
        GdbPageInitialize(False);
      end;
    
    KallistiEmbeddedPageID:
      begin
        KallistiPageInitialize(False);
      end;

    wpSelectComponents:
      begin       
        // Update radio buttons in Components List
        UpdateFoundation();
        UpdateToolchainSelection();
        UpdateGdbSelection();

        { Lock Components List items selection
          WARNING: This procedure should/can be executed *ONLY* here!
          Indeed, if you execute this procedure in another location, the
          radio buttons will remains unchecked, so an undefined behaviour is
          happening... sounds like a bug somewhere but nevermind. }
        SetToolchainComponentsControlState(gclsoLock);
        SetGdbComponentsControlState(gclsoLock);

        { Initialize the component list items count. This needs to have all
          the GDB items disabled (see SetGdbComponentsControlState() above). }
        ComponentsListInitialize(False);
      end;
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  case CurStep of
    ssInstall:
      begin
#if InstallerMode == DEBUG
        LogCalculatedTargets();
#endif
        RenamePreviousDirectoriesBeforeInstallation();
      end;

    ssPostInstall:
      begin
        if IsTaskSelected('envpath') then
          EnvAddPath(ExpandConstant('{code:GetApplicationMainPath}'));
        if IsTaskSelected('wtconfig') then
          InstallWindowsTerminalIntegration();
      end;

  end;
end;

procedure InitializeWizard();
begin
  // Parse generated configuration
  InitializeArrayToolchain();
  InitializeArrayGdb();

  // Components List custom code handling
  ComponentsListInitialize(True);

  // Create BrowseForFolderEx component
  BrowseForFolderExFakePageID := CreateBrowseForFolderExFakePage;  

  // Creates pages before Select Components
  // Creates pages in the specified order  
  KallistiEmbeddedPageID := CreateKallistiEmbeddedPage();
  GdbPageID := CreateGdbPage();
  ToolchainsPageID := CreateToolchainsPage();
  ShellPageID := CreateShellPage();
  FoundationPageID := CreateFoundationPage();

  // Create page after Select Components
  IntegratedDevelopmentEnvironmentSettingsPageID := CreateIntegratedDevelopmentEnvironmentPage();

  // First initialization of pages using generated configuration
  ToolchainsPageInitialize(True);
  GdbPageInitialize(True);
  KallistiPageInitialize(True);
end;

//=============================================================================
// UNINSTALL
//=============================================================================

function InitializeUninstall(): Boolean;
begin
  Result := True;
  SetUninstallMode(True);
  GlobalInitialization();

  // Check modules running
  if IsModulesRunning() then
  begin
    Result := False;
    Exit;
  end;

  // As we are on Uninstall, we can't change the foundation base, but we must
  // retrieve it as this has an impact on the uninstallation
  LoadFoundationFromFile();
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  case CurUninstallStep of
    
    usUninstall:
      begin
#if InstallerMode == DEBUG
        LogCalculatedTargets();
#endif        
        RemoveFoundationFile();        
        UninstallCodeBlocksIntegration();
        UninstallWindowsTerminalIntegration();
        RemoveJunctions();
        UnloadHelperLibraries();
      end;
    
    usPostUninstall:
      begin
        EnvRemovePath(ExpandConstant('{code:GetApplicationMainPath}'));        
      end;

  end;  
end;
