[Code]
const
  REPOSITORIES_COUNT = 4;
  REPOSITORIES_DEFAULT_FILE_NAME = 'repositories-default.conf';
  GIT_LS_REMOTE_OUTPUT_FILE_NAME = 'git-ls-remote.txt';
  GIT_HEADS_PREFIX = 'refs/heads/';
  GIT_TAGS_PREFIX = 'refs/tags/';
  GIT_PEELED_TAG_SUFFIX = '^{}';

var
  RepositoryUrlComboBoxes,
  RepositoryRefComboBoxes: array[0..3] of TNewComboBox;
  RepositoryDefaultUrls,
  RepositoryRefsLoadedUrls: array[0..3] of String;
  RepositoryRefsLoaded,
  RepositoryRefsLoadSucceeded: array[0..3] of Boolean;

// Repository configuration file name, as used by the Manager
// (i.e., "etc/dreamsdk/repositories/*.conf")
function GetRepositoryListFileName(const Index: Integer): String;
begin
  case Index of
    0: Result := 'kallisti.conf';
    1: Result := 'kallisti-ports.conf';
    2: Result := 'dcload-serial.conf';
    3: Result := 'dcload-ip.conf';
  end;
end;

// Used as section name in "repositories-default.conf" and as key prefix in the
// [Repositories] section of "dreamsdk.conf" (e.g., "KallistiURL", "KallistiRef")
function GetRepositoryKey(const Index: Integer): String;
begin
  case Index of
    0: Result := 'Kallisti';
    1: Result := 'KallistiPorts';
    2: Result := 'DreamcastToolSerial';
    3: Result := 'DreamcastToolInternetProtocol';
  end;
end;

function GetRepositoryName(const Index: Integer): String;
begin
  Result := CustomMessage('RepositoryName' + GetRepositoryKey(Index));
end;

function ExtractRepositoryFile(const FileName: String): String;
begin
  Result := '';
  try
    ExtractTemporaryFile(FileName);
    Result := ExpandConstant('{tmp}\' + FileName);
  except
    Log(Format('ExtractRepositoryFile: Unable to extract "%s": %s', [
      FileName, GetExceptionMessage]));
  end;
end;

procedure LoadRepositoryUrls(const Index: Integer; const DefaultsFileName: String);
var
  FileName,
  Url: String;
  Lines: TArrayOfString;
  i: Integer;

begin
  with RepositoryUrlComboBoxes[Index] do
  begin
    FileName := ExtractRepositoryFile(GetRepositoryListFileName(Index));
    if (FileName <> '') and LoadStringsFromFile(FileName, Lines) then
      for i := 0 to GetArrayLength(Lines) - 1 do
      begin
        Url := Trim(Lines[i]);
        if (Url <> '') and (Items.IndexOf(Url) = -1) then
          Items.Add(Url);
      end;

    // Same default URL as the Manager (i.e., the "Primary" one)
    if DefaultsFileName <> '' then
      RepositoryDefaultUrls[Index] := Trim(GetIniString(GetRepositoryKey(Index),
        'Primary', '', DefaultsFileName));
    if (RepositoryDefaultUrls[Index] = '') and (Items.Count > 0) then
      RepositoryDefaultUrls[Index] := Items[0];

    if (RepositoryDefaultUrls[Index] <> '')
      and (Items.IndexOf(RepositoryDefaultUrls[Index]) = -1) then
        Items.Insert(0, RepositoryDefaultUrls[Index]);

    Text := RepositoryDefaultUrls[Index];
  end;

  Log(Format('LoadRepositoryUrls: %s, Count=%d, Default="%s"', [
    GetRepositoryKey(Index),
    RepositoryUrlComboBoxes[Index].Items.Count,
    RepositoryDefaultUrls[Index]
  ]));
end;

function GetRepositoryUrl(const Index: Integer): String;
begin
  Result := Trim(RepositoryUrlComboBoxes[Index].Text);
end;

function GetRepositoryRef(const Index: Integer): String;
begin
  Result := Trim(RepositoryRefComboBoxes[Index].Text);
end;

// Retrieve branches then tags available on the remote repository, sorted like
// in the Manager (i.e., master/main first, then tags in "newest first" order)
function FetchRepositoryRefs(Url: String; Refs: TStringList): Boolean;
var
  OutputFileName,
  CommandLine,
  RefName: String;
  Lines: TArrayOfString;
  Branches,
  Tags: TStringList;
  i,
  TabPosition,
  ResultCode: Integer;

begin
  Result := False;
  Refs.Clear;

  // Avoid breaking the command line
  StringChangeEx(Url, '"', '', True);

  OutputFileName := ExpandConstant('{tmp}\' + GIT_LS_REMOTE_OUTPUT_FILE_NAME);
  DeleteFile(OutputFileName);

  // Never prompt for credentials (e.g., with a wrong GitHub URL)
  CommandLine := Format('/C set GIT_TERMINAL_PROMPT=0&& set GCM_INTERACTIVE=never&& '
    + 'git ls-remote --heads --tags "%s" > "%s" 2> nul', [Url, OutputFileName]);
  Log(Format('FetchRepositoryRefs: %s', [CommandLine]));

  if not Exec(ExpandConstant('{cmd}'), CommandLine, '', SW_HIDE,
    ewWaitUntilTerminated, ResultCode) then
  begin
    Log(Format('FetchRepositoryRefs: Unable to execute Git: %s', [SysErrorMessage(ResultCode)]));
    Exit;
  end;

  Log(Format('FetchRepositoryRefs: ResultCode=%d', [ResultCode]));
  if (ResultCode <> 0) or (not LoadStringsFromFile(OutputFileName, Lines)) then
    Exit;

  Branches := TStringList.Create;
  Tags := TStringList.Create;
  try
    Tags.Sorted := True;

    // Lines are like "<hash><TAB>refs/heads/master"
    for i := 0 to GetArrayLength(Lines) - 1 do
    begin
      TabPosition := Pos(#9, Lines[i]);
      if TabPosition = 0 then
        Continue;

      RefName := Trim(Copy(Lines[i], TabPosition + 1, Length(Lines[i])));
      if EndsWith(GIT_PEELED_TAG_SUFFIX, RefName) then
        Continue;

      if StartsWith(GIT_HEADS_PREFIX, RefName) then
        Branches.Add(Copy(RefName, Length(GIT_HEADS_PREFIX) + 1, Length(RefName)))
      else if StartsWith(GIT_TAGS_PREFIX, RefName) then
        Tags.Add(Copy(RefName, Length(GIT_TAGS_PREFIX) + 1, Length(RefName)));
    end;

    // Pin master/main at the top of the branch list, if present
    for i := Branches.Count - 1 downto 0 do
      if (CompareText(Branches[i], 'master') = 0)
        or (CompareText(Branches[i], 'main') = 0) then
      begin
        RefName := Branches[i];
        Branches.Delete(i);
        Branches.Insert(0, RefName);
        Break;
      end;

    for i := 0 to Branches.Count - 1 do
      Refs.Add(Branches[i]);

    // Reverse alphabetical order for tags (approximates newest first)
    for i := Tags.Count - 1 downto 0 do
      Refs.Add(Tags[i]);

    Result := True;
  finally
    Tags.Free;
    Branches.Free;
  end;

  Log(Format('FetchRepositoryRefs: %d refs found', [Refs.Count]));
end;

// Fill the branch/tag list for the current URL; the list is cached until the
// URL is changed
function EnsureRepositoryRefsLoaded(const Index: Integer): Boolean;
var
  Url,
  SavedRef: String;
  Refs: TStringList;
  i: Integer;

begin
  Url := GetRepositoryUrl(Index);

  if RepositoryRefsLoaded[Index] and (RepositoryRefsLoadedUrls[Index] = Url) then
  begin
    Result := RepositoryRefsLoadSucceeded[Index];
    Exit;
  end;

  Refs := TStringList.Create;
  try
    WizardForm.Cursor := crHourGlass;
    try
      Result := (Url <> '') and FetchRepositoryRefs(Url, Refs);
    finally
      WizardForm.Cursor := crDefault;
    end;

    with RepositoryRefComboBoxes[Index] do
    begin
      // Clearing the list clears the typed text as well
      SavedRef := Text;
      Items.Clear;
      for i := 0 to Refs.Count - 1 do
        Items.Add(Refs[i]);
      Text := SavedRef;
    end;
  finally
    Refs.Free;
  end;

  RepositoryRefsLoaded[Index] := True;
  RepositoryRefsLoadedUrls[Index] := Url;
  RepositoryRefsLoadSucceeded[Index] := Result;
end;

procedure RepositoryRefComboBoxDropDown(Sender: TObject);
begin
  EnsureRepositoryRefsLoaded((Sender as TNewComboBox).Tag);
end;

// Force reloading the branch/tag list, then show it to the user
procedure RepositoryRefreshButtonClick(Sender: TObject);
var
  Index: Integer;

begin
  Index := (Sender as TNewButton).Tag;
  RepositoryRefsLoaded[Index] := False;

  if EnsureRepositoryRefsLoaded(Index) then
  begin
    WizardForm.ActiveControl := RepositoryRefComboBoxes[Index];
    RepositoryRefComboBoxes[Index].DroppedDown := True;
  end
  else
    MsgBox(FmtMessage(CustomMessage('RepositoryUnreachable'), [GetRepositoryName(Index),
      GetRepositoryUrl(Index)]), mbError, MB_OK);
end;

function IsRepositoryRefAvailable(const Index: Integer; const Ref: String): Boolean;
var
  i: Integer;

begin
  Result := False;
  with RepositoryRefComboBoxes[Index] do
    for i := 0 to Items.Count - 1 do
      if Items[i] = Ref then
      begin
        Result := True;
        Exit;
      end;
end;

function ValidateRepositories: Boolean;
var
  i: Integer;
  Url,
  Ref: String;

begin
  Result := True;

  for i := 0 to REPOSITORIES_COUNT - 1 do
  begin
    Url := GetRepositoryUrl(i);
    Ref := GetRepositoryRef(i);

    if Url = '' then
    begin
      MsgBox(FmtMessage(CustomMessage('RepositoryUrlEmpty'), [GetRepositoryName(i)]),
        mbError, MB_OK);
      Result := False;
      Exit;
    end;

    // Default values don't need to be checked
    if (Url = RepositoryDefaultUrls[i]) and (Ref = '') then
      Continue;

    if not EnsureRepositoryRefsLoaded(i) then
    begin
      MsgBox(FmtMessage(CustomMessage('RepositoryUnreachable'), [GetRepositoryName(i), Url]),
        mbError, MB_OK);
      Result := False;
      Exit;
    end;

    if (Ref <> '') and (not IsRepositoryRefAvailable(i, Ref)) then
    begin
      MsgBox(FmtMessage(CustomMessage('RepositoryRefNotFound'), [GetRepositoryName(i), Ref, Url]),
        mbError, MB_OK);
      Result := False;
      Exit;
    end;
  end;
end;

// Pass the selection to the Manager through the "dreamsdk.conf" file.
// Empty values mean "use the default" for the Manager.
procedure SaveRepositoriesConfiguration(const ConfigurationFilePath: String);
var
  i: Integer;
  Url,
  Ref: String;

begin
  Log('SaveRepositoriesConfiguration');

  for i := 0 to REPOSITORIES_COUNT - 1 do
  begin
    Url := '';
    Ref := '';

    if not IsKallistiEmbedded then
    begin
      Url := GetRepositoryUrl(i);
      if Url = RepositoryDefaultUrls[i] then
        Url := '';
      Ref := GetRepositoryRef(i);
    end;

    Log(Format('  %s: URL="%s", Ref="%s"', [GetRepositoryKey(i), Url, Ref]));
    SetIniString('Repositories', GetRepositoryKey(i) + 'URL', Url, ConfigurationFilePath);
    SetIniString('Repositories', GetRepositoryKey(i) + 'Ref', Ref, ConfigurationFilePath);
  end;
end;

function CreateRepositoriesPage(const AfterID: Integer): Integer;
var
  RepositoriesPage: TWizardPage;
  LabelRepositoriesIntroduction,
  LabelRepository: TLabel;
  ButtonRefresh: TNewButton;
  BtnImage: TBitmapImage;
  DefaultsFileName: String;
  i,
  ControlTop: Integer;

begin
  RepositoriesPage := CreateCustomPage(AfterID,
    CustomMessage('RepositoriesTitlePage'),
    CustomMessage('RepositoriesSubtitlePage'));

  BtnImage := SetPageIcon('kos', RepositoriesPage);

  // Introduction label
  LabelRepositoriesIntroduction := TLabel.Create(RepositoriesPage);
  LabelRepositoriesIntroduction.Parent := RepositoriesPage.Surface;
  LabelRepositoriesIntroduction.AutoSize := False;
  LabelRepositoriesIntroduction.WordWrap := True;
  LabelRepositoriesIntroduction.Left := BtnImage.Width + ScaleX(12);
  LabelRepositoriesIntroduction.Width := RepositoriesPage.SurfaceWidth
    - LabelRepositoriesIntroduction.Left;
  LabelRepositoriesIntroduction.Caption := CustomMessage('LabelRepositoriesIntroduction');
  LabelRepositoriesIntroduction.AutoSize := True;
  LabelRepositoriesIntroduction.Top := (BtnImage.Height div 2)
    - (LabelRepositoriesIntroduction.Height div 2);

  DefaultsFileName := ExtractRepositoryFile(REPOSITORIES_DEFAULT_FILE_NAME);

  ControlTop := BtnImage.Top + BtnImage.Height + ScaleY(12);
  for i := 0 to REPOSITORIES_COUNT - 1 do
  begin
    LabelRepository := TLabel.Create(RepositoriesPage);
    LabelRepository.Parent := RepositoriesPage.Surface;
    LabelRepository.Caption := FmtMessage(CustomMessage('LabelRepository'), [GetRepositoryName(i)]);
    LabelRepository.Top := ControlTop;

    // Repository URL
    RepositoryUrlComboBoxes[i] := TNewComboBox.Create(RepositoriesPage);
    with RepositoryUrlComboBoxes[i] do
    begin
      Parent := RepositoriesPage.Surface;
      Style := csDropDown;
      Tag := i;
      Top := LabelRepository.Top + LabelRepository.Height + ScaleY(3);
      Width := (RepositoriesPage.SurfaceWidth * 55) div 100;

      // The real height (computed from the font) is only known once the
      // window is created, so force it before using the height elsewhere
      if Handle = 0 then
        Log('CreateRepositoriesPage: Unable to create the ComboBox handle');
    end;

    // Refresh the branch/tag list for the selected URL
    ButtonRefresh := TNewButton.Create(RepositoriesPage);
    with ButtonRefresh do
    begin
      Parent := RepositoriesPage.Surface;
      Caption := CustomMessage('ButtonRepositoryRefresh');
      Tag := i;
      OnClick := @RepositoryRefreshButtonClick;
      Top := RepositoryUrlComboBoxes[i].Top;
      Height := RepositoryUrlComboBoxes[i].Height;
      Width := ScaleX(70);
      Left := RepositoriesPage.SurfaceWidth - Width;

      // Themed buttons are drawn with a 1px margin inside their bounds
      if IsVisualStylesEnabled then
      begin
        Top := Top - ScaleY(1);
        Height := Height + ScaleY(2);
      end;
    end;

    // Branch/Tag, empty means the default branch of the repository
    RepositoryRefComboBoxes[i] := TNewComboBox.Create(RepositoriesPage);
    with RepositoryRefComboBoxes[i] do
    begin
      Parent := RepositoriesPage.Surface;
      Style := csDropDown;
      Tag := i;
      DropDownCount := 16;
      OnDropDown := @RepositoryRefComboBoxDropDown;
      Top := RepositoryUrlComboBoxes[i].Top;
      Left := RepositoryUrlComboBoxes[i].Left + RepositoryUrlComboBoxes[i].Width + ScaleX(8);
      Width := ButtonRefresh.Left - ScaleX(4) - Left;
    end;

    LoadRepositoryUrls(i, DefaultsFileName);

    ControlTop := RepositoryUrlComboBoxes[i].Top
      + RepositoryUrlComboBoxes[i].Height + ScaleY(8);
  end;

  Result := RepositoriesPage.ID;
end;
