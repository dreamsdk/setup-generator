[Code]
const
  WM_SETREDRAW = $000B;
  WM_GETTEXTLENGTH = $000E;
  WM_HSCROLL = $0114;
  EM_SETSEL = $00B1;
  EM_LINESCROLL = $00B6;
  EM_GETLINECOUNT = $00BA;
  EM_GETFIRSTVISIBLELINE = $00CE;
  EM_CHARFROMPOS = $00D7;
  SB_HORZ = 0;
  SB_THUMBPOSITION = 4;
  RDW_INVALIDATE = $0001;
  RDW_ERASE = $0004;
  RDW_FRAME = $0400;

function IsAppThemed: Boolean;
external 'IsAppThemed@uxtheme.dll stdcall delayload';

function GetScrollPos(hWnd: HWND; nBar: Integer): Integer;
external 'GetScrollPos@user32.dll stdcall';

function RedrawWindow(hWnd: HWND; lprcUpdate, hrgnUpdate: Longint;
  flags: Cardinal): Boolean;
external 'RedrawWindow@user32.dll stdcall';

// Visual styles are enabled (i.e., not the "Windows Classic" theme).
// Visual styles don't exist before Windows XP (no "uxtheme.dll" available).
function IsVisualStylesEnabled: Boolean;
begin
  Result := IsWindowsXPOrGreater and IsAppThemed;
end;

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
