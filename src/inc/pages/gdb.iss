[Code]
type
  TResetGdbContext = record
    RootComponentsListItemIndex: Integer;
    GdbPackages: TGdbPackageArray;
  end;
  TTResetGdbContextArray = array of TResetGdbContext;

var
  GdbComboBoxSelection: TNewComboBox;
  GdbLabelSelectionHint: TLabel;
  ComponentGdb32ComponentsListItemIndex,
  ComponentGdb64ComponentsListItemIndex,
  GdbComboBoxSelectionStoredItemIndex: Integer;
  IsGdbComboBoxSelection64: Boolean;

function RunSimpleCommandOnPython(CommandName, PythonFileName: String): String;
begin
  Result := RunCommand(
      ExpandConstant(
        Format('{tmp}\%s "%s"', [CommandName, PythonFileName])
      ),
      True
    );  
end;

function TestPythonVersion(Version: String): Boolean;
var
  i: Integer;
  Buffer,
  PythonFileName,
  PythonBitness,
  PythonFilePath,
  VersionWithoutDot: String;
  PythonFilePaths: TArrayOfString;
  
begin
  Result := False;
  Log(Format('TestPythonVersion: %s', [Version]));

  VersionWithoutDot := Version;
  StringChangeEx(VersionWithoutDot, '.', '', True);
  PythonFileName := Format('python%s.dll', [VersionWithoutDot]);    
  
  Buffer := RunSimpleCommandOnPython('whereis.exe', PythonFileName);
  Explode(PythonFilePaths, Buffer, sLineBreak);  
  
  for i := 0 to Length(PythonFilePaths) - 1 do
  begin
    PythonFilePath := PythonFilePaths[i];
    if FileExists(PythonFilePath) then
    begin
      Log(Format('Python %s is installed: %s', [Version, PythonFilePath]));
      PythonBitness := RunSimpleCommandOnPython('pecheck.exe', PythonFilePath);
      Result := Result or (PythonBitness = '32-bits'); // 32-bits only
      Log(Format('Python %s bitness is %s', [Version, PythonBitness]));
    end
    else
      Log(Format('Python %s is not installed', [Version]));
  end;
end;

function IsSelectedGdbForModernWindowsOnly(): Boolean;
var
  SelectedGdb: Integer;

begin
  Result := False;
  (*SelectedGdb := GetSelectedGdb;
  if SelectedGdb <> -1 then
    Result := GdbPackages[SelectedGdb].IsModernWindowsOnly;   *)
end;

function ConfirmModernGdbUsage(): Boolean;
begin
  Result := (MsgBox(CustomMessage('GdbUnsupportedModernConfirmation'),
    mbError, MB_YESNO) = IDYES);
end;

function ConfirmLegacyGdbUsage(): Boolean;
begin
  Result := (MsgBox(CustomMessage('GdbLegacyConfirmation'),
    mbConfirmation, MB_YESNO) = IDYES);
end;

function GetComponentsListItemIndex(const Text: String; StartIndex: Integer): Integer;
var
  i: Integer;

begin
  if StartIndex = 0 then
    Result := WizardForm.ComponentsList.Items.IndexOf(Text)
  else 
    for i := StartIndex to WizardForm.ComponentsList.Items.Count - 1 do
      if WizardForm.ComponentsList.Items[i] = Text then
      begin
        Result := i;
        Break;
      end;
end;

procedure ResetGdbSelection();
var
  ContextIndex, i,
  RootComponentsListItemIndex,
  ComponentsListItemIndex: Integer;
  GdbPackages: TGdbPackageArray; 
  ResetGdbContext: TTResetGdbContextArray;
#if InstallerMode == DEBUG
  IsComponentsListItemIndexUpdated: Boolean;
#endif

begin
  Log('ResetGdbSelection called');

  SetArrayLength(ResetGdbContext, 2);

  // 32-bit
  ResetGdbContext[0].RootComponentsListItemIndex := ComponentGdb32ComponentsListItemIndex;
  ResetGdbContext[0].GdbPackages := Gdb32Packages;

  // 64-bit
  ResetGdbContext[1].RootComponentsListItemIndex := ComponentGdb64ComponentsListItemIndex;
  ResetGdbContext[1].GdbPackages := Gdb64Packages;

  // Reset all 32-bit and 64-bit checkboxes
  for ContextIndex := Low(ResetGdbContext) to High(ResetGdbContext) do
  begin
    GdbPackages := ResetGdbContext[ContextIndex].GdbPackages;
    RootComponentsListItemIndex := ResetGdbContext[ContextIndex].RootComponentsListItemIndex;    

#if InstallerMode == DEBUG
    Log(Format('+ RootComponentsListItemIndex=%d, Name="%s" [%d of %d]', [
      RootComponentsListItemIndex,
      WizardForm.ComponentsList.ItemCaption[RootComponentsListItemIndex],
      (ContextIndex + 1),
      (High(ResetGdbContext) + 1)
    ]));
#endif

    with WizardForm.ComponentsList do
    begin      
      // Process all GDB packages
      for i := High(GdbPackages) downto Low(GdbPackages) do
      begin        
        // Update ComponentsListItemIndex from GdbPackages[i] if needed 
        ComponentsListItemIndex := GdbPackages[i].ComponentsListItemIndex;
#if InstallerMode == DEBUG
        IsComponentsListItemIndexUpdated := False;
#endif                 
        if (ComponentsListItemIndex = -1) then
        begin
          ComponentsListItemIndex := GetComponentsListItemIndex(GdbPackages[i].Name, RootComponentsListItemIndex);          
          GdbPackages[i].ComponentsListItemIndex := ComponentsListItemIndex;
#if InstallerMode == DEBUG
          IsComponentsListItemIndexUpdated := True;
#endif
        end;

#if InstallerMode == DEBUG
        Log(Format('++ ComponentsListItemIndex=%d, Name="%s", IsComponentsListItemIndexUpdated="%s"', [
          ComponentsListItemIndex,
          WizardForm.ComponentsList.ItemCaption[ComponentsListItemIndex],
          BoolToStrCustom(IsComponentsListItemIndexUpdated, 'Updated', 'Not Updated')
        ]));
#endif

        // Uncheck all packages that are linked to the root node
        ItemEnabled[ComponentsListItemIndex] := True;
        (*CheckItem(ComponentsListItemIndex, coUncheck);
        Checked[ComponentsListItemIndex] := False;
        ItemEnabled[ComponentsListItemIndex] := False;*)
      end;

      // Uncheck the root node
      ItemEnabled[RootComponentsListItemIndex] := True;
      //CheckItem(RootComponentsListItemIndex, coUncheck);
      Checked[RootComponentsListItemIndex] := False;
      //ItemEnabled[RootComponentsListItemIndex] := False;

      Invalidate();

#if InstallerMode == DEBUG
        Log(Format('+ RootComponentsListItemIndex=%d, Name="%s", Status="%s"', [
          ComponentsListItemIndex,
          WizardForm.ComponentsList.ItemCaption[RootComponentsListItemIndex],
          BoolToStrCustom(WizardForm.ComponentsList.Checked[RootComponentsListItemIndex], 'Checked', 'Unchecked')
        ]));
#endif
    end;    
  end;

  Log('ResetGdbSelection ended');
end;

procedure UpdateGdbSelection();
var
  GdbProfileIndex,
  GdbComponentsListItemIndex: Integer;
  GdbDescription,
  GdbWindowsText: String;
  SelectedGdb: TGdbPackage;
  GdbPackages: TGdbPackageArray;
   
begin
  if GdbComboBoxSelection.ItemIndex = -1 then
    Exit;
	
  GetGdbPackagesList(GdbPackages);

  // Select the correct Gdb
  GdbProfileIndex := GdbComboBoxSelection.Items.Objects[GdbComboBoxSelection.ItemIndex];    
  if SetSelectedGdb(GdbProfileIndex) then
  begin
    GdbComboBoxSelectionStoredItemIndex := GdbComboBoxSelection.ItemIndex;
    IsGdbComboBoxSelection64 := IsFoundationMinGW64;

    SelectedGdb := Gdb32Packages[GetSelectedGdb];
    GdbComponentsListItemIndex := ComponentGdb32ComponentsListItemIndex;
    if IsGdbComboBoxSelection64 then
    begin
      SelectedGdb := Gdb64Packages[GetSelectedGdb];
      GdbComponentsListItemIndex := ComponentGdb64ComponentsListItemIndex;
    end;

    // Display Gdb information
    GdbLabelSelectionHint.Caption := SelectedGdb.Description;
          
    // Tick the correct Gdb in the ComponentsList then force UI refresh
    if Assigned(WizardForm) and Assigned(WizardForm.ComponentsList) then
    begin
      with WizardForm.ComponentsList do
      begin
        // Uncheck all GDB packages              
        ResetGdbSelection();

        // Check only the choice the user made
        if SelectedGdb.ComponentsListItemIndex <> -1 then
        begin
          // Check the root GDB node
          CheckItem(GdbComponentsListItemIndex, coCheck);        
          Checked[GdbComponentsListItemIndex] := True;

          // Check the specified GDB packaged in that GBD node
          Log(Format('Checking: %d', [SelectedGdb.ComponentsListItemIndex]));
          CheckItem(SelectedGdb.ComponentsListItemIndex, coCheck);
          Checked[SelectedGdb.ComponentsListItemIndex] := True;

          // Refresh UI
          Invalidate();
        end;
      end;

      // Force recalculation of disk space usage
      WizardForm.TypesCombo.OnChange(WizardForm.TypesCombo);
    end;      
  end;  
end;

procedure GdbComboBoxSelectionAddItem(Text: String; GdbProfileIndex: Integer);
var
  GdbItemText: String;
  NewItemIndex: Integer;
  GdbPackages: TGdbPackageArray;  

begin
  GetGdbPackagesList(GdbPackages);
  
  GdbItemText := Text;  
  (*if (not IsModernWindowsForGdb) and GdbPackages[GdbProfileIndex].IsModernWindowsOnly then
    GdbItemText := Format('%s %s', [Text, ExpandConstant('{cm:GdbNotSupportedForOldWindows}')]);*)

  // Add the Gdb to the ComboBox
  NewItemIndex := GdbComboBoxSelection.Items.Add(GdbItemText);  
  GdbComboBoxSelection.Items.Objects[NewItemIndex] := Integer(GdbProfileIndex);
end;

(*procedure GdbInitialize();
var
  ComponentsListItemIndex,
  RootComponentsListItemIndex: Integer;

begin
    // Save the item position in ComponentsList
    RootComponentsListItemIndex := ComponentGdb32ComponentsListItemIndex;
    if IsFoundationMinGW64 then
      RootComponentsListItemIndex := ComponentGdb64ComponentsListItemIndex;
    ComponentsListItemIndex := GetComponentsListItemIndex(GdbItemText, RootComponentsListItemIndex);    
    GdbPackages[GdbProfileIndex].ComponentsListItemIndex := ComponentsListItemIndex;
    
    Log(Format('GdbComboBoxSelectionAddItem: %s, index=%d, componentListIndex=%d', [
      Text,
      GdbProfileIndex,
      ComponentsListItemIndex
    ]));  
end;*)

procedure GdbComboBoxSelectionInitialize();
var
  i: Integer;
  Name: String;
  GdbPackages: TGdbPackageArray;  
  
begin
  (*if FirstInitialization then
  begin
    GdbInitialize();    
  end;*)

  // Populate the Gdb list
  GdbComboBoxSelection.Items.Clear;
  
  GetGdbPackagesList(GdbPackages);  
  for i := Low(GdbPackages) to High(GdbPackages) do
  begin
    Name := GdbPackages[i].Name;
    GdbComboBoxSelectionAddItem(Name, i);
  end;
  
  // Enable the list
  GdbComboBoxSelection.Enabled := (GdbComboBoxSelection.Items.Count > 0);
end;

procedure GdbComboBoxSelectionChange(Sender: TObject);
begin
  UpdateGdbSelection();
end;

procedure GdbPageInitialize(const FirstInitialization: Boolean);
begin
  Log(Format('GdbPageInitialize called, first call: %s', [BoolToStr(FirstInitialization)]));

  if FirstInitialization then
  begin
    GdbComboBoxSelectionStoredItemIndex := -1;
    IsGdbComboBoxSelection64 := False;
    ComponentGdb32ComponentsListItemIndex :=
      WizardForm.ComponentsList.Items.IndexOf(ExpandConstant('{cm:ComponentGdb32}'));
    ComponentGdb64ComponentsListItemIndex :=
      WizardForm.ComponentsList.Items.IndexOf(ExpandConstant('{cm:ComponentGdb64}'));
  end;

  Log(Format('GdbPageInitialize: gdb32ComponentListIndex=%d, gdb64ComponentListIndex=%d', [
    ComponentGdb32ComponentsListItemIndex,
    ComponentGdb64ComponentsListItemIndex
  ]));

  GdbComboBoxSelectionInitialize();
  if GdbComboBoxSelection.Enabled then
  begin
    GdbComboBoxSelection.ItemIndex := 0;

    // Handle re-selection but only if we are in the same flavour (32 or 64-bit)
    if (GdbComboBoxSelectionStoredItemIndex <> -1) 
      and (IsFoundationMinGW64 = IsGdbComboBoxSelection64) then
    begin
      Log(Format('+ Re-selection: %d', [GdbComboBoxSelectionStoredItemIndex]));
      GdbComboBoxSelection.ItemIndex := GdbComboBoxSelectionStoredItemIndex;
    end;

    UpdateGdbSelection();    
  end;
end;

function CreateGdbPage(): Integer;
var
  GdbPage: TWizardPage;  
  Labelntroduction,
  LabelPageExplanation, 
  LabelComboBoxSelection: TLabel;
  BtnImage: TBitmapImage;

begin
  // Extract utility files
  ExtractTemporaryFile('whereis.exe');
  ExtractTemporaryFile('pecheck.exe');
  
  GdbPage := CreateCustomPage(
    wpSelectDir,
    CustomMessage('GdbTitlePage'), 
    CustomMessage('GdbSubtitlePage')
  );

  BtnImage := SetPageIcon('gdb', GdbPage);
  
  // Introduction label
  Labelntroduction := TLabel.Create(GdbPage);
  Labelntroduction.Parent := GdbPage.Surface;  
  Labelntroduction.Caption := CustomMessage('LabelGdbIntroduction');  
  Labelntroduction.AutoSize := True;
  Labelntroduction.WordWrap := True;
  Labelntroduction.Top := (BtnImage.Height div 2) - (Labelntroduction.Height div 2);
  Labelntroduction.Left := BtnImage.Height + ScaleX(12);

  // Explanation of this page
  LabelPageExplanation := TLabel.Create(GdbPage);
  LabelPageExplanation.Parent := GdbPage.Surface;
  LabelPageExplanation.Caption := CustomMessage('LabelGdbDescription');  
  LabelPageExplanation.Top := BtnImage.Top + BtnImage.Height + ScaleY(12);
  LabelPageExplanation.Width := GdbPage.SurfaceWidth;
  SetMultiLinesLabel(LabelPageExplanation, 3);
  
  // Drop down list label
  LabelComboBoxSelection := TLabel.Create(GdbPage);  
  LabelComboBoxSelection.Parent := GdbPage.Surface;
  LabelComboBoxSelection.Caption := CustomMessage('LabelGdbSelection'); 
  LabelComboBoxSelection.Top := LabelPageExplanation.Top + LabelPageExplanation.Height + ScaleY(12);
  LabelComboBoxSelection.Width := GdbPage.SurfaceWidth;
  LabelComboBoxSelection.Font.Style := [fsBold];  

  // Drop down list (main component of this page)
  GdbComboBoxSelection := TNewComboBox.Create(GdbPage);
  GdbComboBoxSelection.OnChange := @GdbComboBoxSelectionChange;  
  GdbComboBoxSelection.Parent := GdbPage.Surface; 
  GdbComboBoxSelection.Top := LabelComboBoxSelection.Top + LabelComboBoxSelection.Height + ScaleY(8);
  GdbComboBoxSelection.Width := GdbPage.SurfaceWidth; 
  GdbComboBoxSelection.Style := csDropDownList;

  // Hint text for drop down list
  GdbLabelSelectionHint := TLabel.Create(GdbPage);  
  GdbLabelSelectionHint.Parent := GdbPage.Surface;
  GdbLabelSelectionHint.Caption := '(Dynamic)'; 
  GdbLabelSelectionHint.Top := GdbComboBoxSelection.Top + GdbComboBoxSelection.Height + ScaleY(4);
  GdbLabelSelectionHint.Width := GdbPage.SurfaceWidth;
  SetMultiLinesLabel(GdbLabelSelectionHint, 3);         
 
  Result := GdbPage.ID;
end;
