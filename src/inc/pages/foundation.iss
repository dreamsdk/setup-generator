[code]
var
  RadioButtonFoundationMinGW64,
  RadioButtonFoundationMinGW: TNewRadioButton;

function IsFoundationPossibleMinGW64: Boolean;
begin
  Result := RadioButtonFoundationMinGW64.Enabled;
end;

function IsFoundationMinGW64: Boolean;
begin
  Result := IsFoundationPossibleMinGW64 and
    RadioButtonFoundationMinGW64.Checked;
end;

function IsFoundationMinGW: Boolean;
begin
  Result := RadioButtonFoundationMinGW.Checked
    or (not IsFoundationPossibleMinGW64);
end;

function ConfirmFoundationMinGW: Boolean;
begin
  Result := (MsgBox(CustomMessage('FoundationUseMinGWConfirmation'),
    mbError, MB_YESNO) = IDYES);
end;

function CreateFoundationPage: Integer;
var
  FoundationPage: TWizardPage;
  LabelFoundationIntroduction, 
  LabelFoundationDescription,
  LabelFoundationDescriptionMinGW64,
  LabelFoundationDescriptionMinGW: TLabel;
  BtnImage: TBitmapImage;

begin
  FoundationPage := CreateCustomPage(wpSelectComponents,
    CustomMessage('FoundationTitlePage'), 
    CustomMessage('FoundationSubtitlePage'));

  BtnImage := SetPageIcon('Foundation', FoundationPage);

  // Introduction label
  LabelFoundationIntroduction := TLabel.Create(FoundationPage);
  LabelFoundationIntroduction.Parent := FoundationPage.Surface;  
  LabelFoundationIntroduction.Caption := CustomMessage('LabelFoundationIntroduction');  
  LabelFoundationIntroduction.AutoSize := True;
  LabelFoundationIntroduction.WordWrap := True;
  LabelFoundationIntroduction.Top := (BtnImage.Height div 2) - (LabelFoundationIntroduction.Height div 2);
  LabelFoundationIntroduction.Left := BtnImage.Height + ScaleX(12);

  // Explanation of this page
  LabelFoundationDescription := TLabel.Create(FoundationPage);
  LabelFoundationDescription.Parent := FoundationPage.Surface;
  LabelFoundationDescription.Caption := CustomMessage('LabelFoundationDescription');  
  LabelFoundationDescription.Top := BtnImage.Top + BtnImage.Height + ScaleY(12);
  LabelFoundationDescription.Width := FoundationPage.SurfaceWidth;
  SetMultiLinesLabel(LabelFoundationDescription, 4);
      
  // MinGW64 (Windows 10+)
  RadioButtonFoundationMinGW64 := TNewRadioButton.Create(FoundationPage);
  RadioButtonFoundationMinGW64.Parent := FoundationPage.Surface;
  RadioButtonFoundationMinGW64.Caption := CustomMessage('FoundationMinGW64');  
  RadioButtonFoundationMinGW64.Top := LabelFoundationDescription.Top 
    + LabelFoundationDescription.Height + ScaleY(4);
  RadioButtonFoundationMinGW64.Width := FoundationPage.SurfaceWidth;
  RadioButtonFoundationMinGW64.Checked := True;
  RadioButtonFoundationMinGW64.Font.Style := [fsBold];

  LabelFoundationDescriptionMinGW := TLabel.Create(FoundationPage);
  LabelFoundationDescriptionMinGW.Parent := FoundationPage.Surface;
  LabelFoundationDescriptionMinGW.Caption := CustomMessage('LabelFoundationDescriptionMinGW64'); 
  LabelFoundationDescriptionMinGW.Top := RadioButtonFoundationMinGW64.Top + RadioButtonFoundationMinGW64.Height + ScaleY(4);
  LabelFoundationDescriptionMinGW.Width := FoundationPage.SurfaceWidth;
  SetMultiLinesLabel(LabelFoundationDescriptionMinGW, 3);  

  // MinGW
  RadioButtonFoundationMinGW := TNewRadioButton.Create(FoundationPage);
  RadioButtonFoundationMinGW.Parent := FoundationPage.Surface;
  RadioButtonFoundationMinGW.Caption := CustomMessage('FoundationMinGW');  
  RadioButtonFoundationMinGW.Top := LabelFoundationDescriptionMinGW.Top 
    + LabelFoundationDescriptionMinGW.Height + ScaleY(8);
  RadioButtonFoundationMinGW.Width := FoundationPage.SurfaceWidth;
  RadioButtonFoundationMinGW.Font.Style := [fsBold];
  RadioButtonFoundationMinGW.Enabled := IsWindows10OrGreater;

  LabelFoundationDescriptionMinGW64 := TLabel.Create(FoundationPage);
  LabelFoundationDescriptionMinGW64.Parent := FoundationPage.Surface;
  LabelFoundationDescriptionMinGW64.Caption := CustomMessage('LabelFoundationDescriptionMinGW');    
  LabelFoundationDescriptionMinGW64.Top := RadioButtonFoundationMinGW.Top + RadioButtonFoundationMinGW.Height + ScaleY(4);
  LabelFoundationDescriptionMinGW64.Width := FoundationPage.SurfaceWidth;
  SetMultiLinesLabel(LabelFoundationDescriptionMinGW64, 3);  

  Result := FoundationPage.ID;
end;
