[code]
var
  RadioButtonFoundationMinGW64,
  RadioButtonFoundationMinGW: TNewRadioButton;

function ConfirmFoundationMinGW: Boolean;
begin
  Result := (MsgBox(CustomMessage('FoundationUseMinGWConfirmation'),
    mbError, MB_YESNO) = IDYES);
end;

procedure RadioButtonFoundationMinGW64Click(Sender: TObject);
begin
  SetFoundation(efkMinGW64MSYS2);
  Log('Selected Foundation: MinGW64/MSYS2');
end;

procedure RadioButtonFoundationMinGWClick(Sender: TObject);
begin
  SetFoundation(efkMinGWMSYS);
  Log('Selected Foundation: MinGW/MSYS');
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
  RadioButtonFoundationMinGW64.OnClick := @RadioButtonFoundationMinGW64Click;
  RadioButtonFoundationMinGW64.Enabled := IsFoundationPossibleMinGW64;
  RadioButtonFoundationMinGW64.Checked := IsFoundationPossibleMinGW64;
  RadioButtonFoundationMinGW64.Parent := FoundationPage.Surface;
  RadioButtonFoundationMinGW64.Caption := CustomMessage('FoundationMinGW64');  
  RadioButtonFoundationMinGW64.Top := LabelFoundationDescription.Top 
    + LabelFoundationDescription.Height + ScaleY(4);
  RadioButtonFoundationMinGW64.Width := FoundationPage.SurfaceWidth;
  RadioButtonFoundationMinGW64.Font.Style := [fsBold];

  LabelFoundationDescriptionMinGW64 := TLabel.Create(FoundationPage);
  LabelFoundationDescriptionMinGW64.Enabled := RadioButtonFoundationMinGW64.Enabled;
  LabelFoundationDescriptionMinGW64.Parent := FoundationPage.Surface;
  LabelFoundationDescriptionMinGW64.Caption := CustomMessage('LabelFoundationDescriptionMinGW64'); 
  LabelFoundationDescriptionMinGW64.Top := RadioButtonFoundationMinGW64.Top + RadioButtonFoundationMinGW64.Height + ScaleY(4);
  LabelFoundationDescriptionMinGW64.Width := FoundationPage.SurfaceWidth;
  SetMultiLinesLabel(LabelFoundationDescriptionMinGW64, 3);  

  // MinGW
  RadioButtonFoundationMinGW := TNewRadioButton.Create(FoundationPage);  
  RadioButtonFoundationMinGW.OnClick := @RadioButtonFoundationMinGWClick;
  RadioButtonFoundationMinGW.Checked := not RadioButtonFoundationMinGW64.Checked;
  RadioButtonFoundationMinGW.Parent := FoundationPage.Surface;
  RadioButtonFoundationMinGW.Caption := CustomMessage('FoundationMinGW');  
  RadioButtonFoundationMinGW.Top := LabelFoundationDescriptionMinGW64.Top 
    + LabelFoundationDescriptionMinGW64.Height + ScaleY(8);
  RadioButtonFoundationMinGW.Width := FoundationPage.SurfaceWidth;
  RadioButtonFoundationMinGW.Font.Style := [fsBold];  

  LabelFoundationDescriptionMinGW := TLabel.Create(FoundationPage);
  LabelFoundationDescriptionMinGW.Parent := FoundationPage.Surface;
  LabelFoundationDescriptionMinGW.Caption := CustomMessage('LabelFoundationDescriptionMinGW');    
  LabelFoundationDescriptionMinGW.Top := RadioButtonFoundationMinGW.Top + RadioButtonFoundationMinGW.Height + ScaleY(4);
  LabelFoundationDescriptionMinGW.Width := FoundationPage.SurfaceWidth;
  SetMultiLinesLabel(LabelFoundationDescriptionMinGW, 3);  

  Result := FoundationPage.ID;
end;
