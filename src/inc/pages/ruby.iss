[code]
var
  RadioButtonRubyDisabled,
  RadioButtonRubyEnabled: TNewRadioButton;

function IsRubyEnabled: Boolean;
begin
  Result := RadioButtonRubyEnabled.Checked;
end;

function IsRubyOnline: Boolean;
begin
  Result := (not IsKallistiEmbedded) and IsRubyEnabled;
end;

function ConfirmRubyUsage: Boolean;
begin
  Result := (MsgBox(CustomMessage('RubyEnableConfirmation'),
    mbConfirmation, MB_YESNO) = IDYES);
end;

function CreateRubyPage: Integer;
var
  RubyPage: TWizardPage;
  LabelRubyIntroduction, 
  LabelRubyDescription,
  LabelRubyDescriptionEnabled,
  LabelRubyDescriptionDisabled: TLabel;
  BtnImage: TBitmapImage;

begin
  RubyPage := CreateCustomPage(wpSelectComponents,
    CustomMessage('RubyTitlePage'), 
    CustomMessage('RubySubtitlePage'));

  BtnImage := SetPageIcon('ruby', RubyPage);

  // Introduction label
  LabelRubyIntroduction := TLabel.Create(RubyPage);
  LabelRubyIntroduction.Parent := RubyPage.Surface;  
  LabelRubyIntroduction.Caption := CustomMessage('LabelRubyIntroduction');  
  LabelRubyIntroduction.AutoSize := True;
  LabelRubyIntroduction.WordWrap := True;
  LabelRubyIntroduction.Top := (BtnImage.Height div 2) - (LabelRubyIntroduction.Height div 2);
  LabelRubyIntroduction.Left := BtnImage.Height + ScaleX(12);

  // Explanation of this page
  LabelRubyDescription := TLabel.Create(RubyPage);
  LabelRubyDescription.Parent := RubyPage.Surface;
  LabelRubyDescription.Caption := CustomMessage('LabelRubyDescription');  
  LabelRubyDescription.Top := BtnImage.Top + BtnImage.Height + ScaleY(12);
  LabelRubyDescription.Width := RubyPage.SurfaceWidth;
  SetMultiLinesLabel(LabelRubyDescription, 4);
      
  // Disable Ruby
  RadioButtonRubyDisabled := TNewRadioButton.Create(RubyPage);
  RadioButtonRubyDisabled.Parent := RubyPage.Surface;
  RadioButtonRubyDisabled.Caption := CustomMessage('RubyDisabled');  
  RadioButtonRubyDisabled.Top := LabelRubyDescription.Top 
    + LabelRubyDescription.Height + ScaleY(4);
  RadioButtonRubyDisabled.Width := RubyPage.SurfaceWidth;
  RadioButtonRubyDisabled.Checked := True;
  RadioButtonRubyDisabled.Font.Style := [fsBold];

  LabelRubyDescriptionDisabled := TLabel.Create(RubyPage);
  LabelRubyDescriptionDisabled.Parent := RubyPage.Surface;
  LabelRubyDescriptionDisabled.Caption := CustomMessage('LabelRubyDescriptionDisabled'); 
  LabelRubyDescriptionDisabled.Top := RadioButtonRubyDisabled.Top + RadioButtonRubyDisabled.Height + ScaleY(4);
  LabelRubyDescriptionDisabled.Width := RubyPage.SurfaceWidth;
  SetMultiLinesLabel(LabelRubyDescriptionDisabled, 3);  

  // Enable Ruby
  RadioButtonRubyEnabled := TNewRadioButton.Create(RubyPage);
  RadioButtonRubyEnabled.Parent := RubyPage.Surface;
  RadioButtonRubyEnabled.Caption := CustomMessage('RubyEnabled');  
  RadioButtonRubyEnabled.Top := LabelRubyDescriptionDisabled.Top 
    + LabelRubyDescriptionDisabled.Height + ScaleY(8);
  RadioButtonRubyEnabled.Width := RubyPage.SurfaceWidth;
  RadioButtonRubyEnabled.Font.Style := [fsBold];

  LabelRubyDescriptionEnabled := TLabel.Create(RubyPage);
  LabelRubyDescriptionEnabled.Parent := RubyPage.Surface;
  LabelRubyDescriptionEnabled.Caption := CustomMessage('LabelRubyDescriptionEnabled');    
  LabelRubyDescriptionEnabled.Top := RadioButtonRubyEnabled.Top + RadioButtonRubyEnabled.Height + ScaleY(4);
  LabelRubyDescriptionEnabled.Width := RubyPage.SurfaceWidth;
  SetMultiLinesLabel(LabelRubyDescriptionEnabled, 3);  

  Result := RubyPage.ID;
end;
