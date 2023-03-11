[code]
var
  RadioButtonToolchainsStable,
  RadioButtonToolchainsLegacy: TNewRadioButton;

function IsToolchainsLegacy: Boolean;
begin
  Result := RadioButtonToolchainsLegacy.Checked;
end;

function IsToolchainsStable: Boolean;
begin
  Result := RadioButtonToolchainsStable.Checked;
end;

function CreateToolchainsPage: Integer;
var
  ToolchainsPage: TWizardPage;
  LabelToolchainsIntroduction, 
  LabelToolchainsDescription,
  LabelToolchainsDescriptionLegacy,
  LabelToolchainsDescriptionStable: TLabel;
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
  SetMultiLinesLabel(LabelToolchainsDescription, 3);
      
  // Stable Toolchains
  RadioButtonToolchainsStable := TNewRadioButton.Create(ToolchainsPage);
  RadioButtonToolchainsStable.Parent := ToolchainsPage.Surface;
  RadioButtonToolchainsStable.Caption := CustomMessage('ToolchainsStable');  
  RadioButtonToolchainsStable.Top := LabelToolchainsDescription.Top 
    + LabelToolchainsDescription.Height + ScaleY(4);
  RadioButtonToolchainsStable.Width := ToolchainsPage.SurfaceWidth;
  RadioButtonToolchainsStable.Checked := True;
  RadioButtonToolchainsStable.Font.Style := [fsBold];

  LabelToolchainsDescriptionStable := TLabel.Create(ToolchainsPage);
  LabelToolchainsDescriptionStable.Parent := ToolchainsPage.Surface;
  LabelToolchainsDescriptionStable.Caption := CustomMessage('LabelToolchainsDescriptionStable'); 
  LabelToolchainsDescriptionStable.Top := RadioButtonToolchainsStable.Top 
    + RadioButtonToolchainsStable.Height + ScaleY(4);
  LabelToolchainsDescriptionStable.Width := ToolchainsPage.SurfaceWidth;
  SetMultiLinesLabel(LabelToolchainsDescriptionStable, 3);  

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
    + RadioButtonToolchainsLegacy.Height + ScaleY(4);
  LabelToolchainsDescriptionLegacy.Width := ToolchainsPage.SurfaceWidth;
  SetMultiLinesLabel(LabelToolchainsDescriptionLegacy, 3);  

  Result := ToolchainsPage.ID;
end;
