// ============================================================================
//  ____                         _____  ____   _____
// |    .  ___  ___  ___  _____ |   __||    . |  |  |
// |  |  ||  _|| -_|| .'||     ||__   ||  |  ||    -|
// |____/ |_|  |___||__,||_|_|_||_____||____/ |__|__|
//
// ============================================================================
// DreamSDK Setup - Toolchain Selection (Profile) Page
// ============================================================================

[Code]
type
  TResetToolchainContext = record
    RootComponentsListItemIndex: Integer;
    ToolchainPackages: TToolchainPackageArray;
  end;
  TResetToolchainContextArray = array of TResetToolchainContext;
  TToolchainComponentsListStateOperation = (tclsoLock, tclsoUnlock);

var
  ToolchainsComboBoxSelection: TNewComboBox;
  ComponentToolchain32ComponentsListItemIndex,
  ComponentToolchain64ComponentsListItemIndex,
  ToolchainComboBoxSelectionStoredItemIndex: Integer;
  ToolchainsLabelSelectionHint: TLabel;

function IsModernWindowsForToolchain(): Boolean;
begin
  Result := IsWindows10OrGreater;
end;

function IsSelectedToolchainForModernWindowsOnly(): Boolean;
(*var
  ToolchainPackages: TToolchainPackageArray; 
  SelectedToolchain: Integer;*)

begin
  Result := IsFoundationMinGW64;
  (*Result := False;
  if GetToolchainPackagesList(ToolchainPackages) then
  begin
    SelectedToolchain := GetSelectedToolchain;
    if SelectedToolchain <> -1 then
      Result := ToolchainPackages[SelectedToolchain].IsModernWindowsOnly;
  end;*)
end;

function ConfirmModernToolchainsUsage(): Boolean;
begin
  Result := (MsgBox(CustomMessage('ToolchainsUnsupportedModernConfirmation'),
    mbError, MB_YESNO) = IDYES);
end;

function ConfirmLegacyToolchainsUsage(): Boolean;
begin
  Result := (MsgBox(CustomMessage('ToolchainsLegacyConfirmation'),
    mbConfirmation, MB_YESNO) = IDYES);
end;

procedure SetToolchainComponentsControlState(
  const Operation: TToolchainComponentsListStateOperation);
var
  ContextIndex,
  i,
  RootComponentsListItemIndex,
  ComponentsListItemIndex: Integer;
  ToolchainPackages: TToolchainPackageArray; 
  ResetToolchainContext: TResetToolchainContextArray;

begin
  Log('SetToolchainComponentsControlState called');

  SetArrayLength(ResetToolchainContext, 2);

  // 32-bit
  ResetToolchainContext[0].RootComponentsListItemIndex := ComponentToolchain32ComponentsListItemIndex;
  ResetToolchainContext[0].ToolchainPackages := Toolchain32Packages;

  // 64-bit
  ResetToolchainContext[1].RootComponentsListItemIndex := ComponentToolchain64ComponentsListItemIndex;
  ResetToolchainContext[1].ToolchainPackages := Toolchain64Packages;

  // Processing all 32-bit and 64-bit checkboxes
  for ContextIndex := Low(ResetToolchainContext) to High(ResetToolchainContext) do
  begin
    ToolchainPackages := ResetToolchainContext[ContextIndex].ToolchainPackages;
    RootComponentsListItemIndex := ResetToolchainContext[ContextIndex]
      .RootComponentsListItemIndex;    

#if InstallerMode == DEBUG
    Log(Format('+ RootComponentsListItemIndex=%d, Name="%s" [%d of %d]', [
      RootComponentsListItemIndex,
      WizardForm.ComponentsList.ItemCaption[RootComponentsListItemIndex],
      (ContextIndex + 1),
      (High(ResetToolchainContext) + 1)
    ]));
#endif
    
    // Process the root node
    WizardForm.ComponentsList.ItemEnabled[RootComponentsListItemIndex] := (Operation = tclsoUnlock);
    if (Operation = tclsoUnlock) then
      WizardForm.ComponentsList.Checked[RootComponentsListItemIndex] := False;
     
    // Process all Toolchain packages
    for i := High(ToolchainPackages) downto Low(ToolchainPackages) do
    begin        
      // Update ComponentsListItemIndex from ToolchainPackages[i] if needed 
      ComponentsListItemIndex := ToolchainPackages[i].ComponentsListItemIndex;

#if InstallerMode == DEBUG
      Log(Format('++ ComponentsListItemIndex=%d, Name="%s"', [
        ComponentsListItemIndex,
        WizardForm.ComponentsList.ItemCaption[ComponentsListItemIndex]        
      ]));
#endif

      // Process the current node
      WizardForm.ComponentsList.ItemEnabled[ComponentsListItemIndex] := (Operation = tclsoUnlock);
      if (Operation = tclsoUnlock) then
        WizardForm.ComponentsList.Checked[ComponentsListItemIndex] := False;
    end;
    
    // Refresh the UI
    WizardForm.ComponentsList.Invalidate();

#if InstallerMode == DEBUG
    Log(Format('+ RootComponentsListItemIndex=%d, Name="%s", Status="%s"', [
      ComponentsListItemIndex,
      WizardForm.ComponentsList.ItemCaption[RootComponentsListItemIndex],
      BoolToStrCustom(WizardForm.ComponentsList.Checked[RootComponentsListItemIndex], 'Checked', 'Unchecked')
    ]));
#endif
  end; // ResetToolchainContext

  Log('SetToolchainComponentsControlState ended');
end;

procedure UpdateToolchainSelection();
var
  ToolchainProfileIndex,
  ToolchainComponentsListItemIndex: Integer;
  SelectedToolchain: TToolchainPackage;
   
begin
  if ToolchainsComboBoxSelection.ItemIndex = -1 then
    Exit;

  // Select the correct toolchain
  ToolchainProfileIndex := ToolchainsComboBoxSelection.Items
    .Objects[ToolchainsComboBoxSelection.ItemIndex];
  SetSelectedToolchain(ToolchainProfileIndex);

  if GetSelectedToolchainPackage(SelectedToolchain) then
  begin
    ToolchainComboBoxSelectionStoredItemIndex := ToolchainsComboBoxSelection.ItemIndex;

    // Display toolchain information
    ToolchainsLabelSelectionHint.Caption := SelectedToolchain.Description;

    // Tick the correct toolchain in the ComponentsList then force UI refresh
    if Assigned(WizardForm) and Assigned(WizardForm.ComponentsList) then
    begin
      SetToolchainComponentsControlState(gclsoUnlock);

      with WizardForm.ComponentsList do
      begin
        // Check only the choice the user made
        if SelectedToolchain.ComponentsListItemIndex <> -1 then
        begin
          // Check the root toolchain node
          CheckItem(ToolchainComponentsListItemIndex, coCheck);
          Checked[ToolchainComponentsListItemIndex] := True;

          // Check the specified toolchain packaged in that toolchain node
          CheckItem(SelectedToolchain.ComponentsListItemIndex, coCheck);
          Checked[SelectedToolchain.ComponentsListItemIndex] := True;

#if InstallerMode == DEBUG
          Log(Format('UpdateToolchainSelection: Checking: ComponentsListItemIndex=%d, Name="%s", Status="%s"', [
            SelectedToolchain.ComponentsListItemIndex,
            WizardForm.ComponentsList.ItemCaption[SelectedToolchain.ComponentsListItemIndex],
            BoolToStrCustom(WizardForm.ComponentsList.Checked[SelectedToolchain.ComponentsListItemIndex], 'Checked', 'Unchecked')
          ]));
#endif
        end;
      end;
    end;      
  end;  
end;

procedure ToolchainsComboBoxSelectionAddItem(Text: String; ToolchainProfileIndex: Integer);
var
  NewItemIndex: Integer;

begin    
  // Add the toolchain to the ComboBox
  NewItemIndex := ToolchainsComboBoxSelection.Items.Add(Text);  
  ToolchainsComboBoxSelection.Items.Objects[NewItemIndex] := Integer(ToolchainProfileIndex);
end;

procedure ToolchainComboBoxSelectionInitialize();
var
  i: Integer;
  Name: String;
  ToolchainPackages: TToolchainPackageArray;

begin
  // Populate the toolchain list
  ToolchainsComboBoxSelection.Items.Clear;
  
  GetToolchainPackagesList(ToolchainPackages);
  for i := Low(ToolchainPackages) to High(ToolchainPackages) do
  begin
    Name := ToolchainPackages[i].Name;
    ToolchainsComboBoxSelectionAddItem(Name, i);
  end;
  
  // Select the first item
  ToolchainsComboBoxSelection.Enabled := (ToolchainsComboBoxSelection.Items.Count > 0);
end;

procedure ToolchainsComboBoxSelectionChange(Sender: TObject);
begin
  UpdateToolchainSelection();
end;

procedure ToolchainPackagesInitialize();
var
  ContextIndex,
  i,
  RootComponentsListItemIndex,
  ComponentsListItemIndex: Integer;
  ToolchainPackages: TToolchainPackageArray; 
  ResetToolchainContext: TResetToolchainContextArray;
#if InstallerMode == DEBUG
  IsComponentsListItemIndexUpdated: Boolean;
#endif

begin
  Log('ToolchainPackagesInitialize called');

  SetArrayLength(ResetToolchainContext, 2);

  // 32-bit
  ResetToolchainContext[0].RootComponentsListItemIndex := ComponentToolchain32ComponentsListItemIndex;
  ResetToolchainContext[0].ToolchainPackages := Toolchain32Packages;

  // 64-bit
  ResetToolchainContext[1].RootComponentsListItemIndex := ComponentToolchain64ComponentsListItemIndex;
  ResetToolchainContext[1].ToolchainPackages := Toolchain64Packages;

  // Reset all 32-bit and 64-bit checkboxes
  for ContextIndex := Low(ResetToolchainContext) to High(ResetToolchainContext) do
  begin
    ToolchainPackages := ResetToolchainContext[ContextIndex].ToolchainPackages;
    RootComponentsListItemIndex := ResetToolchainContext[ContextIndex]
      .RootComponentsListItemIndex;    

#if InstallerMode == DEBUG
    Log(Format('+ RootComponentsListItemIndex=%d, Name="%s" [%d of %d]', [
      RootComponentsListItemIndex,
      WizardForm.ComponentsList.ItemCaption[RootComponentsListItemIndex],
      (ContextIndex + 1),
      (High(ResetToolchainContext) + 1)
    ]));
#endif
    
    // Process all Toolchain packages
    for i := High(ToolchainPackages) downto Low(ToolchainPackages) do
    begin        
      // Update ComponentsListItemIndex from ToolchainPackages[i] if needed 
      ComponentsListItemIndex := ToolchainPackages[i].ComponentsListItemIndex;

#if InstallerMode == DEBUG
      IsComponentsListItemIndexUpdated := False;
#endif
      
      // Assign ComponentsListItemIndex if needed         
      if (ComponentsListItemIndex = -1) then
      begin
        ComponentsListItemIndex := GetComponentsListItemIndex(ToolchainPackages[i].Name, RootComponentsListItemIndex);          
        ToolchainPackages[i].ComponentsListItemIndex := ComponentsListItemIndex;
#if InstallerMode == DEBUG
        IsComponentsListItemIndexUpdated := True;
#endif
      end;

#if InstallerMode == DEBUG
      Log(Format('++ ComponentsListItemIndex=%d, Name="%s", IndexUpdated="%s"', [
        ComponentsListItemIndex,
        WizardForm.ComponentsList.ItemCaption[ComponentsListItemIndex],
        BoolToStr(IsComponentsListItemIndexUpdated)
      ]));
#endif
    end;
  end;    

  Log('ToolchainPackagesInitialize ended');
end;

procedure ToolchainsPageInitialize(const FirstInitialization: Boolean);
begin
  Log(Format('ToolchainPageInitialize called, first call: %s', [BoolToStr(FirstInitialization)]));

  if FirstInitialization then
  begin
    ToolchainComboBoxSelectionStoredItemIndex := -1;
    ComponentToolchain32ComponentsListItemIndex :=
      WizardForm.ComponentsList.Items.IndexOf(ExpandConstant('{cm:ComponentToolchain32}'));
    ComponentToolchain64ComponentsListItemIndex :=
      WizardForm.ComponentsList.Items.IndexOf(ExpandConstant('{cm:ComponentToolchain64}'));
    ToolchainPackagesInitialize();
  end;

  Log(Format('ToolchainPageInitialize: Toolchain32ComponentListIndex=%d, Toolchain64ComponentListIndex=%d', [
    ComponentToolchain32ComponentsListItemIndex,
    ComponentToolchain64ComponentsListItemIndex
  ]));

  ToolchainComboBoxSelectionInitialize();
  if ToolchainsComboBoxSelection.Enabled then
  begin
    ToolchainsComboBoxSelection.ItemIndex := 0;

    // Handle re-selection but only if we are in the same flavour (32 or 64-bit)
    if (ToolchainComboBoxSelectionStoredItemIndex <> -1) then
//      and (ToolchainSavedStateIsFoundationMinGW64 = IsFoundationMinGW64)then
    begin
      ToolchainsComboBoxSelection.ItemIndex := ToolchainComboBoxSelectionStoredItemIndex;
#if InstallerMode == DEBUG
      Log(Format('+ Toolchain ItemIndex Restore: %d', [ToolchainComboBoxSelectionStoredItemIndex]));
#endif      
    end;
    
    UpdateToolchainSelection();
  end;
end;

function CreateToolchainsPage(): Integer;
var
  ToolchainsPage: TWizardPage; 
  Labelntroduction,
  LabelPageExplanation, 
  LabelComboBoxSelection: TLabel;
  BtnImage: TBitmapImage;

begin
  ToolchainsPage := CreateCustomPage(
    wpSelectDir,
    CustomMessage('ToolchainsTitlePage'), 
    CustomMessage('ToolchainsSubtitlePage')
  );

  BtnImage := SetPageIcon('toolchains', ToolchainsPage);

  // Introduction label
  Labelntroduction := TLabel.Create(ToolchainsPage);
  Labelntroduction.Parent := ToolchainsPage.Surface;  
  Labelntroduction.Caption := CustomMessage('LabelToolchainsIntroduction');  
  Labelntroduction.AutoSize := True;
  Labelntroduction.WordWrap := True;
  Labelntroduction.Top := (BtnImage.Height div 2) - (Labelntroduction.Height div 2);
  Labelntroduction.Left := BtnImage.Height + ScaleX(12);

  // Explanation of this page
  LabelPageExplanation := TLabel.Create(ToolchainsPage);
  LabelPageExplanation.Parent := ToolchainsPage.Surface;
  LabelPageExplanation.Caption := CustomMessage('LabelToolchainsDescription');  
  LabelPageExplanation.Top := BtnImage.Top + BtnImage.Height + ScaleY(12);
  LabelPageExplanation.Width := ToolchainsPage.SurfaceWidth;
  SetMultiLinesLabel(LabelPageExplanation, 3);
  
  // Drop down list label
  LabelComboBoxSelection := TLabel.Create(ToolchainsPage);  
  LabelComboBoxSelection.Parent := ToolchainsPage.Surface;
  LabelComboBoxSelection.Caption := CustomMessage('LabelToolchainsSelection'); 
  LabelComboBoxSelection.Top := LabelPageExplanation.Top + LabelPageExplanation.Height + ScaleY(12);
  LabelComboBoxSelection.Width := ToolchainsPage.SurfaceWidth;
  LabelComboBoxSelection.Font.Style := [fsBold];  

  // Drop down list (main component of this page)
  ToolchainsComboBoxSelection := TNewComboBox.Create(ToolchainsPage);
  ToolchainsComboBoxSelection.OnChange := @ToolchainsComboBoxSelectionChange;  
  ToolchainsComboBoxSelection.Parent := ToolchainsPage.Surface; 
  ToolchainsComboBoxSelection.Top := LabelComboBoxSelection.Top + LabelComboBoxSelection.Height + ScaleY(8);
  ToolchainsComboBoxSelection.Width := ToolchainsPage.SurfaceWidth; 
  ToolchainsComboBoxSelection.Style := csDropDownList;

  // Hint text for drop down list
  ToolchainsLabelSelectionHint := TLabel.Create(ToolchainsPage);  
  ToolchainsLabelSelectionHint.Parent := ToolchainsPage.Surface;
  ToolchainsLabelSelectionHint.Caption := '(Dynamic)'; 
  ToolchainsLabelSelectionHint.Top := ToolchainsComboBoxSelection.Top + ToolchainsComboBoxSelection.Height + ScaleY(4);
  ToolchainsLabelSelectionHint.Width := ToolchainsPage.SurfaceWidth;
  SetMultiLinesLabel(ToolchainsLabelSelectionHint, 3);         
 
  Result := ToolchainsPage.ID;
end;
