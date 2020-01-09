[code]
var
  RadioButtonOnline,
  RadioButtonOffline: TNewRadioButton;

function IsKallistiEmbedded: Boolean;
begin
  Result := RadioButtonOffline.Checked;
end;

function ConfirmKallistiEmbeddedUsage: Boolean;
begin
  Result := (MsgBox(CustomMessage('KallistiEmbeddedOfflineConfirmation'),
    mbError, MB_YESNO) = IDYES);
end;

function CreateKallistiEmbeddedPage: Integer;
var
  KallistiEmbeddedPage: TWizardPage;
  LabelKallistiEmbeddedIntroduction, 
  LabelKallistiEmbeddedDescription,
  LabelKallistiEmbeddedDescriptionOnline,
  LabelKallistiEmbeddedDescriptionOffline: TLabel;
  BtnImage: TBitmapImage;

begin
  KallistiEmbeddedPage := CreateCustomPage(wpSelectComponents,
    CustomMessage('KallistiEmbeddedTitlePage'), 
    CustomMessage('KallistiEmbeddedSubtitlePage'));

  BtnImage := SetPageIcon('kos', KallistiEmbeddedPage);

  // Introduction label
  LabelKallistiEmbeddedIntroduction := TLabel.Create(KallistiEmbeddedPage);
  LabelKallistiEmbeddedIntroduction.Parent := KallistiEmbeddedPage.Surface;  
  LabelKallistiEmbeddedIntroduction.Caption := CustomMessage('LabelKallistiEmbeddedIntroduction');  
  LabelKallistiEmbeddedIntroduction.AutoSize := True;
  LabelKallistiEmbeddedIntroduction.WordWrap := True;
  LabelKallistiEmbeddedIntroduction.Top := (BtnImage.Height div 2) - (LabelKallistiEmbeddedIntroduction.Height div 2);
  LabelKallistiEmbeddedIntroduction.Left := BtnImage.Height + ScaleX(12);

  // Explanation of this page
  LabelKallistiEmbeddedDescription := TLabel.Create(KallistiEmbeddedPage);
  LabelKallistiEmbeddedDescription.Parent := KallistiEmbeddedPage.Surface;
  LabelKallistiEmbeddedDescription.Caption := CustomMessage('LabelKallistiEmbeddedDescription');  
  LabelKallistiEmbeddedDescription.Top := BtnImage.Top + BtnImage.Height + ScaleY(12);
  LabelKallistiEmbeddedDescription.Width := KallistiEmbeddedPage.SurfaceWidth;
  SetMultiLinesLabel(LabelKallistiEmbeddedDescription, 4);
      
  // Online
  RadioButtonOnline := TNewRadioButton.Create(KallistiEmbeddedPage);
  RadioButtonOnline.Parent := KallistiEmbeddedPage.Surface;
  RadioButtonOnline.Caption := CustomMessage('KallistiEmbeddedOnline');  
  RadioButtonOnline.Top := LabelKallistiEmbeddedDescription.Top 
    + LabelKallistiEmbeddedDescription.Height + ScaleY(4);
  RadioButtonOnline.Width := KallistiEmbeddedPage.SurfaceWidth;
  RadioButtonOnline.Checked := True;
  RadioButtonOnline.Font.Style := [fsBold];

  LabelKallistiEmbeddedDescriptionOnline := TLabel.Create(KallistiEmbeddedPage);
  LabelKallistiEmbeddedDescriptionOnline.Parent := KallistiEmbeddedPage.Surface;
  LabelKallistiEmbeddedDescriptionOnline.Caption := CustomMessage('LabelKallistiEmbeddedDescriptionOnline'); 
  LabelKallistiEmbeddedDescriptionOnline.Top := RadioButtonOnline.Top + RadioButtonOnline.Height + ScaleY(4);
  LabelKallistiEmbeddedDescriptionOnline.Width := KallistiEmbeddedPage.SurfaceWidth;
  SetMultiLinesLabel(LabelKallistiEmbeddedDescriptionOnline, 3);  

  // Offline
  RadioButtonOffline := TNewRadioButton.Create(KallistiEmbeddedPage);
  RadioButtonOffline.Parent := KallistiEmbeddedPage.Surface;
  RadioButtonOffline.Caption := CustomMessage('KallistiEmbeddedOffline');  
  RadioButtonOffline.Top := LabelKallistiEmbeddedDescriptionOnline.Top 
    + LabelKallistiEmbeddedDescriptionOnline.Height + ScaleY(8);
  RadioButtonOffline.Width := KallistiEmbeddedPage.SurfaceWidth;
  RadioButtonOffline.Font.Style := [fsBold];

  LabelKallistiEmbeddedDescriptionOffline := TLabel.Create(KallistiEmbeddedPage);
  LabelKallistiEmbeddedDescriptionOffline.Parent := KallistiEmbeddedPage.Surface;
  LabelKallistiEmbeddedDescriptionOffline.Caption := CustomMessage('LabelKallistiEmbeddedDescriptionOffline'); 
  LabelKallistiEmbeddedDescriptionOffline.Top := RadioButtonOffline.Top + RadioButtonOffline.Height + ScaleY(4);
  LabelKallistiEmbeddedDescriptionOffline.Width := KallistiEmbeddedPage.SurfaceWidth;
  SetMultiLinesLabel(LabelKallistiEmbeddedDescriptionOffline, 3);  

  Result := KallistiEmbeddedPage.ID;
end;
