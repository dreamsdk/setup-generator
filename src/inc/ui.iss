[Code]
var
  BrowseForFolderExFakePage: TInputDirWizardPage;

function CreateBrowseForFolderExFakePage: Integer;
begin
  // Create BrowseForFolderExFakePage
  BrowseForFolderExFakePage := CreateInputDirPage(wpWelcome, '', '', '', 
    False, SetupMessage(msgButtonNewFolder));
  BrowseForFolderExFakePage.Add('');
  Result := BrowseForFolderExFakePage.ID;
end;

procedure BrowseForFolderEx(var Directory: String);
begin
  BrowseForFolderExFakePage.Values[0] := Directory;
  BrowseForFolderExFakePage.Buttons[0].OnClick(BrowseForFolderExFakePage.Buttons[0]);
  Directory := BrowseForFolderExFakePage.Values[0];
end;

function SetPageIcon(const Name: string; Page: TWizardPage): TBitmapImage;
var
  FileName: string;

begin
  FileName := Name + '.bmp';

  ExtractTemporaryFile(FileName);
    
  Result := TBitmapImage.Create(Page);

  with Result do
  begin
    Parent := Page.Surface;
    Bitmap.LoadFromFile(ExpandConstant('{tmp}') + '\' + FileName);
    Bitmap.AlphaFormat := afPremultiplied;
    AutoSize := True;
    Left := 0;
    Top := 0;
  end;
end;

function SetMultiLinesLabel(ControlLabel: TLabel; Lines: Integer): Boolean;
var
  ParentPage: TWizardPage;
  SingleLineHeight: Integer;

begin
  ParentPage := (ControlLabel.Owner as TWizardPage);
  Result := Assigned(ParentPage);

  if Result then
  begin
    SingleLineHeight := ControlLabel.Height;
    ControlLabel.AutoSize := False;
    ControlLabel.WordWrap := True;
    ControlLabel.Height := SingleLineHeight * Lines;
    ControlLabel.Width := ParentPage.SurfaceWidth;
  end;
end;