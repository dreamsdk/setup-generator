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
  LabelKallistiEmbeddedDescription: TLabel;
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
  LabelKallistiEmbeddedDescription.AutoSize := True;
  LabelKallistiEmbeddedDescription.WordWrap := True;  
  LabelKallistiEmbeddedDescription.Top := BtnImage.Top + BtnImage.Height + ScaleY(12);
  LabelKallistiEmbeddedDescription.Width := KallistiEmbeddedPage.SurfaceWidth;
  LabelKallistiEmbeddedDescription.Height := ScaleY(LabelKallistiEmbeddedIntroduction.Height * 3); // Hack to have 3 lines label... LabelKallistiEmbeddedIntroduction.Height is only 1 line... This is BAD
    
  // Online
  RadioButtonOnline := TNewRadioButton.Create(KallistiEmbeddedPage);
  RadioButtonOnline.Parent := KallistiEmbeddedPage.Surface;
  RadioButtonOnline.Caption := CustomMessage('KallistiEmbeddedOnline');  
  RadioButtonOnline.Top := LabelKallistiEmbeddedDescription.Top 
    + LabelKallistiEmbeddedDescription.Height + ScaleY(4);
  RadioButtonOnline.Width := KallistiEmbeddedPage.SurfaceWidth;
  RadioButtonOnline.Checked := True;
  
  // Offline
  RadioButtonOffline := TNewRadioButton.Create(KallistiEmbeddedPage);
  RadioButtonOffline.Parent := KallistiEmbeddedPage.Surface;
  RadioButtonOffline.Caption := CustomMessage('KallistiEmbeddedOffline');  
  RadioButtonOffline.Top := RadioButtonOnline.Top 
    + RadioButtonOnline.Height + ScaleY(4);
  RadioButtonOffline.Width := KallistiEmbeddedPage.SurfaceWidth;

  Result := KallistiEmbeddedPage.ID;
end;
