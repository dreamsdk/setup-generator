[code]
var
  RadioButtonToolchainsStable,
  RadioButtonToolchainsExperimental: TNewRadioButton;

function IsToolchainsExperimental: Boolean;
begin
  Result := RadioButtonToolchainsExperimental.Checked;
end;

function IsToolchainsStable: Boolean;
begin
  Result := RadioButtonToolchainsStable.Checked;
end;

function ConfirmExperimentalToolchainsUsage: Boolean;
begin
  Result := (MsgBox(CustomMessage('ToolchainsExperimentalConfirmation'),
    mbConfirmation, MB_YESNO) = IDYES);
end;

function CreateToolchainsPage: Integer;
var
  ToolchainsPage: TWizardPage;
  LabelToolchainsIntroduction, 
  LabelToolchainsDescription,
  LabelToolchainsDescriptionExperimental,
  LabelToolchainsDescriptionStable: TLabel;
  BtnImage: TBitmapImage;

begin
  ToolchainsPage := CreateCustomPage(wpSelectComponents,
    CustomMessage('ToolchainsTitlePage'), 
    CustomMessage('ToolchainsSubtitlePage'));

  BtnImage := SetPageIcon('Toolchains', ToolchainsPage);

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

  // Experimental Toolchains
  RadioButtonToolchainsExperimental := TNewRadioButton.Create(ToolchainsPage);
  RadioButtonToolchainsExperimental.Parent := ToolchainsPage.Surface;
  RadioButtonToolchainsExperimental.Caption := CustomMessage('ToolchainsExperimental');  
  RadioButtonToolchainsExperimental.Top := LabelToolchainsDescriptionStable.Top 
    + LabelToolchainsDescriptionStable.Height + ScaleY(8);
  RadioButtonToolchainsExperimental.Width := ToolchainsPage.SurfaceWidth;
  RadioButtonToolchainsExperimental.Font.Style := [fsBold];

  LabelToolchainsDescriptionExperimental := TLabel.Create(ToolchainsPage);
  LabelToolchainsDescriptionExperimental.Parent := ToolchainsPage.Surface;
  LabelToolchainsDescriptionExperimental.Caption := CustomMessage('LabelToolchainsDescriptionExperimental');    
  LabelToolchainsDescriptionExperimental.Top := RadioButtonToolchainsExperimental.Top 
    + RadioButtonToolchainsExperimental.Height + ScaleY(4);
  LabelToolchainsDescriptionExperimental.Width := ToolchainsPage.SurfaceWidth;
  SetMultiLinesLabel(LabelToolchainsDescriptionExperimental, 3);  

  Result := ToolchainsPage.ID;
end;
