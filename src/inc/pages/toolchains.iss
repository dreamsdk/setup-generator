[Code]
var
  ToolchainsComboBoxSelection: TNewComboBox;
  ToolchainsLabelSelectionHint: TLabel;

function IsModernWindowsForToolchain(): Boolean;
begin
  Result := IsWindows10OrGreater;
end;

function IsSelectedToolchainForModernWindowsOnly(): Boolean;
var
  SelectedToolchain: Integer;

begin
  Result := False;
  SelectedToolchain := GetSelectedToolchain;
  if SelectedToolchain <> -1 then
    Result := ToolchainPackages[SelectedToolchain].IsModernWindowsOnly;   
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

procedure UpdateToolchainSelection();
var
  i,
  ToolchainProfileIndex: Integer;
  ToolchainDescription,
  ToolchainWindowsText: String;
  SelectedToolchain: TToolchainPackage;
   
begin
  if ToolchainsComboBoxSelection.ItemIndex = -1 then
    Exit;

  // Select the correct toolchain
  ToolchainProfileIndex := ToolchainsComboBoxSelection.Items.Objects[ToolchainsComboBoxSelection.ItemIndex];    
  if SetSelectedToolchain(ToolchainProfileIndex) then
  begin
    SelectedToolchain := ToolchainPackages[GetSelectedToolchain];

    // Display toolchain information
    ToolchainsLabelSelectionHint.Caption := SelectedToolchain.Description;
    
    // Append Windows information to toolchain information
    ToolchainWindowsText := ExpandConstant('{cm:ToolchainsAllWindows}');
    if SelectedToolchain.IsModernWindowsOnly then
      ToolchainWindowsText := ExpandConstant('{cm:ToolchainsNewWindowsOnly}');
    ToolchainsLabelSelectionHint.Caption := Format('%s %s', [
      ToolchainsLabelSelectionHint.Caption,
      ToolchainWindowsText
    ]);
    
    // Tick the correct toolchain in the ComponentsList then force UI refresh
    if Assigned(WizardForm) and Assigned(WizardForm.ComponentsList) then
    begin
      with WizardForm.ComponentsList do
      begin
        for i := High(ToolchainPackages) downto Low(ToolchainPackages) do
          Checked[ToolchainPackages[i].ComponentsListItemIndex] := False;
        Checked[SelectedToolchain.ComponentsListItemIndex] := True;         
        Invalidate;  
      end;

      // Force recalculation of disk space usage
      WizardForm.TypesCombo.OnChange(WizardForm.TypesCombo);
    end;      
  end;  
end;

procedure ToolchainsComboBoxSelectionAddItem(Text: String; ToolchainProfileIndex: Integer);
var
  ToolchainItemText: String;
  NewItemIndex,
  ComponentsListItemIndex: Integer;

begin
  ToolchainItemText := Text;  
  if (not IsModernWindowsForToolchain) and ToolchainPackages[ToolchainProfileIndex].IsModernWindowsOnly then
    ToolchainItemText := Format('%s %s', [Text, ExpandConstant('{cm:ToolchainsNotSupportedForOldWindows}')]);

  // Add the toolchain to the ComboBox
  NewItemIndex := ToolchainsComboBoxSelection.Items.Add(ToolchainItemText);
  ToolchainsComboBoxSelection.Items.Objects[NewItemIndex] := Integer(ToolchainProfileIndex);
  
  // Save the item position in ComponentsList
  ComponentsListItemIndex := WizardForm.ComponentsList.Items.IndexOf(Text);
  ToolchainPackages[ToolchainProfileIndex].ComponentsListItemIndex := ComponentsListItemIndex;

  Log(Format('ToolchainsComboBoxSelectionAddItem: %s, index=%d, componentListIndex=%d', [
    Text,
    ToolchainProfileIndex,
    ComponentsListItemIndex
  ]));
end;

procedure ToolchainsComboBoxSelectionInitialize();
var
  i: Integer;
  Name: String;

begin
  // Populate the toolchains list
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

procedure ToolchainsPageInitialize();
begin
  if ToolchainsComboBoxSelection.Enabled then
  begin
    ToolchainsComboBoxSelection.ItemIndex := 0;
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
  ToolchainsComboBoxSelectionInitialize();

  // Hint text for drop down list
  ToolchainsLabelSelectionHint := TLabel.Create(ToolchainsPage);  
  ToolchainsLabelSelectionHint.Parent := ToolchainsPage.Surface;
  ToolchainsLabelSelectionHint.Caption := '(Dynamic)'; 
  ToolchainsLabelSelectionHint.Top := ToolchainsComboBoxSelection.Top + ToolchainsComboBoxSelection.Height + ScaleY(4);
  ToolchainsLabelSelectionHint.Width := ToolchainsPage.SurfaceWidth;
  SetMultiLinesLabel(ToolchainsLabelSelectionHint, 3);         
 
  Result := ToolchainsPage.ID;
end;
