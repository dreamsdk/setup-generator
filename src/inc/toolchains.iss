[code]
var
  RadioButtonToolchainsStable,
  RadioButtonToolchainsLegacy,
  RadioButtonToolchainsTesting: TNewRadioButton;

function IsToolchainsLegacy: Boolean;
begin
  Result := RadioButtonToolchainsLegacy.Checked;
end;

function IsToolchainsStable: Boolean;
begin
  Result := RadioButtonToolchainsStable.Checked;
end;

function IsToolchainsTesting: Boolean;
begin
  Result := RadioButtonToolchainsTesting.Checked;
end;

function ConfirmTestingToolchainsUsage: Boolean;
begin
  Result := (MsgBox(CustomMessage('ToolchainsTestingConfirmation'),
    mbConfirmation, MB_YESNO) = IDYES);
end;

function CreateToolchainsPage: Integer;
var
  ToolchainsPage: TWizardPage;
  LabelToolchainsIntroduction, 
  LabelToolchainsDescription,
  LabelToolchainsDescriptionLegacy,
  LabelToolchainsDescriptionStable,
  LabelToolchainsDescriptionTesting: TLabel;
  BtnImage: TBitmapImage;

begin
  ToolchainsPage := CreateCustomPage(wpSelectComponents,
    CustomMessage('ToolchainsTitlePage'), 
    CustomMessage('ToolchainsSubtitlePage'));

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

  // Legacy Toolchains
  RadioButtonToolchainsLegacy := TNewRadioButton.Create(ToolchainsPage);
  RadioButtonToolchainsLegacy.Parent := ToolchainsPage.Surface;
  RadioButtonToolchainsLegacy.Caption := CustomMessage('ToolchainsLegacy');  
  RadioButtonToolchainsLegacy.Top := LabelToolchainsDescriptionStable.Top 
    + LabelToolchainsDescriptionStable.Height + ScaleY(8);
  RadioButtonToolchainsLegacy.Width := ToolchainsPage.SurfaceWidth;
  RadioButtonToolchainsLegacy.Font.Style := [fsBold];

  LabelToolchainsDescriptionLegacy := TLabel.Create(ToolchainsPage);
  LabelToolchainsDescriptionLegacy.Parent := ToolchainsPage.Surface;
  LabelToolchainsDescriptionLegacy.Caption := CustomMessage('LabelToolchainsDescriptionLegacy');    
  LabelToolchainsDescriptionLegacy.Top := RadioButtonToolchainsLegacy.Top 
    + RadioButtonToolchainsLegacy.Height + ScaleY(2);
  LabelToolchainsDescriptionLegacy.Width := ToolchainsPage.SurfaceWidth;
  SetMultiLinesLabel(LabelToolchainsDescriptionLegacy, 2);  

  // Testing Toolchains
  RadioButtonToolchainsTesting := TNewRadioButton.Create(ToolchainsPage);
  RadioButtonToolchainsTesting.Parent := ToolchainsPage.Surface;
  RadioButtonToolchainsTesting.Caption := CustomMessage('ToolchainsTesting');  
  RadioButtonToolchainsTesting.Top := LabelToolchainsDescriptionLegacy.Top 
    + LabelToolchainsDescriptionLegacy.Height + ScaleY(8);
  RadioButtonToolchainsTesting.Width := ToolchainsPage.SurfaceWidth;
  RadioButtonToolchainsTesting.Font.Style := [fsBold];

  LabelToolchainsDescriptionTesting := TLabel.Create(ToolchainsPage);
  LabelToolchainsDescriptionTesting.Parent := ToolchainsPage.Surface;
  LabelToolchainsDescriptionTesting.Caption := CustomMessage('LabelToolchainsDescriptionTesting');    
  LabelToolchainsDescriptionTesting.Top := RadioButtonToolchainsTesting.Top 
    + RadioButtonToolchainsTesting.Height + ScaleY(2);
  LabelToolchainsDescriptionTesting.Width := ToolchainsPage.SurfaceWidth;
  SetMultiLinesLabel(LabelToolchainsDescriptionTesting, 2);

  // Testing is only for Vista and greater...
  if not IsWindowsVistaOrGreater then
  begin
    RadioButtonToolchainsTesting.Enabled := False;
    LabelToolchainsDescriptionTesting.Enabled := False;
    RadioButtonToolchainsTesting.Caption := 
      RadioButtonToolchainsTesting.Caption + CustomMessage('ToolchainsTestingDisabled'); 
  end;

  Result := ToolchainsPage.ID;
end;
