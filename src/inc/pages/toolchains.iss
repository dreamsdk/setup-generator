[code]
var
  RadioButtonToolchainsStable,
  RadioButtonToolchainsLegacy,
  RadioButtonToolchainsOldStable: TNewRadioButton;

function IsToolchainsLegacy: Boolean;
begin
  Result := RadioButtonToolchainsLegacy.Checked;
end;

function IsToolchainsStable: Boolean;
begin
  Result := RadioButtonToolchainsStable.Checked;
end;

function IsToolchainsOldStable: Boolean;
begin
  Result := RadioButtonToolchainsOldStable.Checked;
end;

function ConfirmLegacyToolchainsUsage: Boolean;
begin
  Result := (MsgBox(CustomMessage('ToolchainsLegacyConfirmation'),
    mbConfirmation, MB_YESNO) = IDYES);
end;

function CreateToolchainsPage: Integer;
var
  ToolchainsPage: TWizardPage;
  LabelToolchainsIntroduction, 
  LabelToolchainsDescription,
  LabelToolchainsDescriptionLegacy,
  LabelToolchainsDescriptionStable,
  LabelToolchainsDescriptionOldStable: TLabel;
  BtnImage: TBitmapImage;

begin
  ToolchainsPage := CreateCustomPage(
    wpSelectDir,
    CustomMessage('ToolchainsTitlePage'), 
    CustomMessage('ToolchainsSubtitlePage')
  );

  BtnImage := SetPageIcon('toolchains', ToolchainsPage);

  // Introduction label
  LabelToolchainsIntroduction := TLabel.Create(ToolchainsPage);
  LabelToolchainsIntroduction.Parent := ToolchainsPage.Surface;  
  LabelToolchainsIntroduction.Caption := CustomMessage('LabelToolchainsIntroduction');  
  LabelToolchainsIntroduction.AutoSize := True;
  LabelToolchainsIntroduction.WordWrap := True;
  LabelToolchainsIntroduction.Top := (BtnImage.Height div 2) - (LabelToolchainsIntroduction.Height div 2);
  LabelToolchainsIntroduction.Left := BtnImage.Height + ScaleX(12);

  // Explanation of this page
  LabelToolchainsDescription := TLabel.Create(ToolchainsPage);
  LabelToolchainsDescription.Parent := ToolchainsPage.Surface;
  LabelToolchainsDescription.Caption := CustomMessage('LabelToolchainsDescription');  
  LabelToolchainsDescription.Top := BtnImage.Top + BtnImage.Height + ScaleY(12);
  LabelToolchainsDescription.Width := ToolchainsPage.SurfaceWidth;
  SetMultiLinesLabel(LabelToolchainsDescription, 2);
      
  // Stable Toolchains
  RadioButtonToolchainsStable := TNewRadioButton.Create(ToolchainsPage);
  RadioButtonToolchainsStable.Parent := ToolchainsPage.Surface;
  RadioButtonToolchainsStable.Caption := CustomMessage('ToolchainsStable');  
  RadioButtonToolchainsStable.Top := LabelToolchainsDescription.Top 
    + LabelToolchainsDescription.Height + ScaleY(8);
  RadioButtonToolchainsStable.Width := ToolchainsPage.SurfaceWidth;
  RadioButtonToolchainsStable.Checked := True;
  RadioButtonToolchainsStable.Font.Style := [fsBold];

  LabelToolchainsDescriptionStable := TLabel.Create(ToolchainsPage);
  LabelToolchainsDescriptionStable.Parent := ToolchainsPage.Surface;
  LabelToolchainsDescriptionStable.Caption := CustomMessage('LabelToolchainsDescriptionStable'); 
  LabelToolchainsDescriptionStable.Top := RadioButtonToolchainsStable.Top 
    + RadioButtonToolchainsStable.Height + ScaleY(2);
  LabelToolchainsDescriptionStable.Width := ToolchainsPage.SurfaceWidth;
  SetMultiLinesLabel(LabelToolchainsDescriptionStable, 2);  

  // OldStable Toolchains
  RadioButtonToolchainsOldStable := TNewRadioButton.Create(ToolchainsPage);
  RadioButtonToolchainsOldStable.Parent := ToolchainsPage.Surface;
  RadioButtonToolchainsOldStable.Caption := CustomMessage('ToolchainsOldStable');  
  RadioButtonToolchainsOldStable.Top := LabelToolchainsDescriptionStable.Top 
    + LabelToolchainsDescriptionStable.Height + ScaleY(8);
  RadioButtonToolchainsOldStable.Width := ToolchainsPage.SurfaceWidth;
  RadioButtonToolchainsOldStable.Font.Style := [fsBold];

  LabelToolchainsDescriptionOldStable := TLabel.Create(ToolchainsPage);
  LabelToolchainsDescriptionOldStable.Parent := ToolchainsPage.Surface;
  LabelToolchainsDescriptionOldStable.Caption := CustomMessage('LabelToolchainsDescriptionOldStable');    
  LabelToolchainsDescriptionOldStable.Top := RadioButtonToolchainsOldStable.Top 
    + RadioButtonToolchainsOldStable.Height + ScaleY(2);
  LabelToolchainsDescriptionOldStable.Width := ToolchainsPage.SurfaceWidth;
  SetMultiLinesLabel(LabelToolchainsDescriptionOldStable, 2);

  // Legacy Toolchains
  RadioButtonToolchainsLegacy := TNewRadioButton.Create(ToolchainsPage);
  RadioButtonToolchainsLegacy.Parent := ToolchainsPage.Surface;
  RadioButtonToolchainsLegacy.Caption := CustomMessage('ToolchainsLegacy');  
  RadioButtonToolchainsLegacy.Top := LabelToolchainsDescriptionOldStable.Top 
    + LabelToolchainsDescriptionOldStable.Height + ScaleY(8);
  RadioButtonToolchainsLegacy.Width := ToolchainsPage.SurfaceWidth;
  RadioButtonToolchainsLegacy.Font.Style := [fsBold];

  LabelToolchainsDescriptionLegacy := TLabel.Create(ToolchainsPage);
  LabelToolchainsDescriptionLegacy.Parent := ToolchainsPage.Surface;
  LabelToolchainsDescriptionLegacy.Caption := CustomMessage('LabelToolchainsDescriptionLegacy');    
  LabelToolchainsDescriptionLegacy.Top := RadioButtonToolchainsLegacy.Top 
    + RadioButtonToolchainsLegacy.Height + ScaleY(2);
  LabelToolchainsDescriptionLegacy.Width := ToolchainsPage.SurfaceWidth;
  SetMultiLinesLabel(LabelToolchainsDescriptionLegacy, 2);  

  // Stable is only for Vista and greater...
  if not IsWindowsVistaOrGreater then
  begin
    RadioButtonToolchainsStable.Enabled := False;
    LabelToolchainsDescriptionStable.Enabled := False;
    RadioButtonToolchainsStable.Caption := 
      RadioButtonToolchainsStable.Caption + CustomMessage('ToolchainsStableDisabled');
    RadioButtonToolchainsOldStable.Checked := True; 
  end;

  Result := ToolchainsPage.ID;
end;
