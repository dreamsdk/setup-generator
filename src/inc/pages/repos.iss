[Code]
const
  REPOSITORIES_COUNT = 4;
  REPOSITORIES_DEFAULT_FILE_NAME = 'repositories-default.conf';
  GIT_LS_REMOTE_OUTPUT_FILE_NAME = 'git-ls-remote-%d-%d.txt';
  GIT_LS_REMOTE_DONE_FILE_NAME = 'git-ls-remote-%d-%d.done';
  GIT_LS_REMOTE_SCRIPT_FILE_NAME = 'git-ls-remote-%d-%d.cmd';
  GIT_LS_REMOTE_START_FILE_NAME = 'git-ls-remote-start-%d.cmd';
  GIT_LS_REMOTE_SUCCEEDED = 'ok';
  GIT_LS_REMOTE_FAILED = 'fail';
  GIT_HEADS_PREFIX = 'refs/heads/';
  GIT_TAGS_PREFIX = 'refs/tags/';
  GIT_SYMREF_PREFIX = 'ref: ';
  GIT_HEAD_REF = 'HEAD';
  GIT_PEELED_TAG_SUFFIX = '^{}';
  REPOSITORY_REFS_FETCH_TIMEOUT = 15000; // ms
  REPOSITORY_REFS_FETCH_POLL_INTERVAL = 100; // ms

type
  TRepositoryRefsStatus = (rrsSucceeded, rrsFailed, rrsPending);

var
  RepositoryUrlComboBoxes,
  RepositoryRefComboBoxes: array[0..3] of TNewComboBox;
  RepositoryDefaultUrls,
  RepositoryDefaultBranches,
  RepositoryRefsLoadedUrls,
  RepositoryRefsFetchUrls: array[0..3] of String;
  RepositoryRefsLoaded,
  RepositoryRefsFetchStarted: array[0..3] of Boolean;
  RepositoryRefsLoadStatus: array[0..3] of TRepositoryRefsStatus;
  RepositoryRefsFetchCounts: array[0..3] of Integer;
  RepositoryRefsFetchStartCount: Integer;

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

function GetRepositoryRefsFetchFileName(const Index: Integer;
  const FileNameFormat: String): String;
begin
  Result := ExpandConstant('{tmp}\' + Format(FileNameFormat, [Index,
    RepositoryRefsFetchCounts[Index]]));
end;

// The "done" file is written by the background fetch once Git has exited.
// It may exist but still be empty while it's being written.
function IsRepositoryRefsFetchFinished(const Index: Integer;
  var Succeeded: Boolean): Boolean;
var
  Done: AnsiString;

begin
  Result := LoadStringFromFile(GetRepositoryRefsFetchFileName(Index,
    GIT_LS_REMOTE_DONE_FILE_NAME), Done) and (Trim(Done) <> '');
  Succeeded := Result and (Trim(Done) = GIT_LS_REMOTE_SUCCEEDED);
end;

// Run "git ls-remote" in the background for the current URL of each
// repository in the range, so the branch/tag list is ready when the user needs
// it. Repositories whose list is already loaded or being fetched for their URL
// are skipped. All the fetches are started from a single process: starting
// processes is slow (e.g., with an antivirus) and it's done on the UI thread.
// Scripts only use file names relative to {tmp} (the working directory), as
// they are saved in the ANSI code page while cmd reads them in the OEM one.
function StartRepositoryRefsFetches(const FirstIndex, LastIndex: Integer): Boolean;
var
  Url,
  FetchCommand,
  StartScript,
  StartScriptFileName: String;
  Pending: array[0..3] of Boolean;
  i,
  PendingCount,
  ResultCode: Integer;

begin
  Result := True;
  PendingCount := 0;
  StartScript := '@echo off' + #13#10
    // Never prompt for credentials (e.g., with a wrong GitHub URL)
    + 'set GIT_TERMINAL_PROMPT=0' + #13#10
    + 'set GCM_INTERACTIVE=never' + #13#10;

  for i := FirstIndex to LastIndex do
  begin
    Pending[i] := False;
    Url := GetRepositoryUrl(i);

    if (RepositoryRefsLoaded[i] and (RepositoryRefsLoadedUrls[i] = Url))
      or (RepositoryRefsFetchStarted[i] and (RepositoryRefsFetchUrls[i] = Url)) then
        Continue;

    if Url = '' then
    begin
      Result := False;
      Continue;
    end;

    // Each fetch has its own files, so a slow previous fetch (e.g., for another
    // URL) can't be mistaken for this one
    Inc(RepositoryRefsFetchCounts[i]);
    RepositoryRefsFetchUrls[i] := Url;

    // Avoid breaking the command line
    StringChangeEx(Url, '"', '', True);

    // "--symref" with "HEAD" gives the default branch of the repository too
    FetchCommand := Format('git ls-remote --symref "%s" HEAD "refs/heads/*" "refs/tags/*" > %s 2> nul && echo %s> %s || echo %s> %s', [
      Url,
      ExtractFileName(GetRepositoryRefsFetchFileName(i, GIT_LS_REMOTE_OUTPUT_FILE_NAME)),
      GIT_LS_REMOTE_SUCCEEDED,
      ExtractFileName(GetRepositoryRefsFetchFileName(i, GIT_LS_REMOTE_DONE_FILE_NAME)),
      GIT_LS_REMOTE_FAILED,
      ExtractFileName(GetRepositoryRefsFetchFileName(i, GIT_LS_REMOTE_DONE_FILE_NAME))
    ]);
    Log(Format('StartRepositoryRefsFetches: %s', [FetchCommand]));

    // "%" has a special meaning in scripts (e.g., in "%20" from an URL)
    StringChangeEx(FetchCommand, '%', '%%', True);

    if not SaveStringToFile(GetRepositoryRefsFetchFileName(i, GIT_LS_REMOTE_SCRIPT_FILE_NAME),
      '@echo off' + #13#10 + FetchCommand + #13#10, False) then
    begin
      Log(Format('StartRepositoryRefsFetches: Unable to write the script for %s', [
        GetRepositoryKey(i)]));
      Result := False;
      Continue;
    end;

    // ".\" is needed when the current directory isn't searched for commands
    // (i.e., when "NoDefaultCurrentDirectoryInExePath" is set)
    StartScript := StartScript + 'start "" /b cmd /C .\' + ExtractFileName(
      GetRepositoryRefsFetchFileName(i, GIT_LS_REMOTE_SCRIPT_FILE_NAME)) + #13#10;
    Pending[i] := True;
    Inc(PendingCount);
  end;

  if PendingCount = 0 then
    Exit;

  // Each start has its own script, so it can't be changed while still running
  Inc(RepositoryRefsFetchStartCount);
  StartScriptFileName := Format(GIT_LS_REMOTE_START_FILE_NAME, [RepositoryRefsFetchStartCount]);
  if SaveStringToFile(ExpandConstant('{tmp}\' + StartScriptFileName), StartScript, False) then
  begin
    Log(Format('StartRepositoryRefsFetches: Starting %d fetch(es)', [PendingCount]));
    if not Exec(ExpandConstant('{cmd}'), '/C .\' + StartScriptFileName,
      ExpandConstant('{tmp}'), SW_HIDE, ewNoWait, ResultCode) then
    begin
      Log(Format('StartRepositoryRefsFetches: Unable to execute Git: %s', [
        SysErrorMessage(ResultCode)]));
      PendingCount := 0;
    end;
  end
  else
  begin
    Log('StartRepositoryRefsFetches: Unable to write the start script');
    PendingCount := 0;
  end;

  for i := FirstIndex to LastIndex do
    if Pending[i] then
      RepositoryRefsFetchStarted[i] := PendingCount > 0;
  Result := Result and (PendingCount > 0);
end;

function StartRepositoryRefsFetch(const Index: Integer): Boolean;
begin
  Result := StartRepositoryRefsFetches(Index, Index);
end;

// Wait for the background fetch to finish (up to the timeout)
function WaitRepositoryRefsFetch(const Index: Integer): TRepositoryRefsStatus;
var
  Elapsed: Integer;
  Succeeded: Boolean;

begin
  Elapsed := 0;
  while not IsRepositoryRefsFetchFinished(Index, Succeeded) do
  begin
    if Elapsed >= REPOSITORY_REFS_FETCH_TIMEOUT then
    begin
      Log(Format('WaitRepositoryRefsFetch: %s still pending', [GetRepositoryKey(Index)]));
      Result := rrsPending;
      Exit;
    end;
    Sleep(REPOSITORY_REFS_FETCH_POLL_INTERVAL);
    Elapsed := Elapsed + REPOSITORY_REFS_FETCH_POLL_INTERVAL;
  end;

  if Succeeded then
    Result := rrsSucceeded
  else
    Result := rrsFailed;
end;

// Read branches then tags from the "git ls-remote" output, sorted like in the
// Manager (i.e., default branch first, then tags in "newest first" order)
function ParseRepositoryRefs(const OutputFileName: String; Refs: TStringList;
  var DefaultBranch: String): Boolean;
var
  Target,
  RefName: String;
  Lines: TArrayOfString;
  Branches,
  Tags: TStringList;
  i,
  TabPosition: Integer;

begin
  Result := False;
  Refs.Clear;
  DefaultBranch := '';

  if not LoadStringsFromFile(OutputFileName, Lines) then
    Exit;

  Branches := TStringList.Create;
  Tags := TStringList.Create;
  try
    Tags.Sorted := True;

    // Lines are like "<hash><TAB>refs/heads/master", plus
    // "ref: refs/heads/master<TAB>HEAD" for the default branch
    for i := 0 to GetArrayLength(Lines) - 1 do
    begin
      TabPosition := Pos(#9, Lines[i]);
      if TabPosition = 0 then
        Continue;

      Target := Trim(Copy(Lines[i], 1, TabPosition - 1));
      RefName := Trim(Copy(Lines[i], TabPosition + 1, Length(Lines[i])));

      if RefName = GIT_HEAD_REF then
      begin
        if StartsWith(GIT_SYMREF_PREFIX + GIT_HEADS_PREFIX, Target) then
          DefaultBranch := Copy(Target, Length(GIT_SYMREF_PREFIX + GIT_HEADS_PREFIX) + 1,
            Length(Target));
        Continue;
      end;

      if EndsWith(GIT_PEELED_TAG_SUFFIX, RefName) then
        Continue;

      if StartsWith(GIT_HEADS_PREFIX, RefName) then
        Branches.Add(Copy(RefName, Length(GIT_HEADS_PREFIX) + 1, Length(RefName)))
      else if StartsWith(GIT_TAGS_PREFIX, RefName) then
        Tags.Add(Copy(RefName, Length(GIT_TAGS_PREFIX) + 1, Length(RefName)));
    end;

    // Pin the default branch at the top of the branch list (or master/main
    // if the remote didn't tell it)
    for i := Branches.Count - 1 downto 0 do
      if (Branches[i] = DefaultBranch) or ((DefaultBranch = '')
        and ((CompareText(Branches[i], 'master') = 0)
        or (CompareText(Branches[i], 'main') = 0))) then
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

  Log(Format('ParseRepositoryRefs: %d refs found, default branch "%s"', [
    Refs.Count, DefaultBranch]));
end;

// Fill the branch/tag list for the current URL from the background fetch
// (started now if needed); the list is cached until the URL is changed
function EnsureRepositoryRefsLoaded(const Index: Integer): TRepositoryRefsStatus;
var
  Url,
  SavedRef,
  DefaultBranch: String;
  Refs: TStringList;
  i: Integer;

begin
  Url := GetRepositoryUrl(Index);
  DefaultBranch := '';

  if RepositoryRefsLoaded[Index] and (RepositoryRefsLoadedUrls[Index] = Url) then
  begin
    Result := RepositoryRefsLoadStatus[Index];
    Exit;
  end;

  Refs := TStringList.Create;
  try
    WizardForm.Cursor := crHourGlass;
    try
      Result := rrsFailed;
      if (Url <> '') and StartRepositoryRefsFetch(Index) then
      begin
        Result := WaitRepositoryRefsFetch(Index);
        if (Result = rrsSucceeded) and (not ParseRepositoryRefs(
          GetRepositoryRefsFetchFileName(Index, GIT_LS_REMOTE_OUTPUT_FILE_NAME), Refs,
          DefaultBranch)) then
            Result := rrsFailed;
      end;
    finally
      WizardForm.Cursor := crDefault;
    end;

    // Still running: keep waiting for the same fetch on the next attempt
    if Result = rrsPending then
      Exit;

    with RepositoryRefComboBoxes[Index] do
    begin
      // Clearing the list clears the typed text as well
      SavedRef := Text;

      // Empty means "use the default branch": show which one it is (also
      // when it was shown for the previous URL)
      if (SavedRef = '') or (SavedRef = RepositoryDefaultBranches[Index]) then
        SavedRef := DefaultBranch;

      Items.Clear;
      for i := 0 to Refs.Count - 1 do
        Items.Add(Refs[i]);
      Text := SavedRef;
    end;
  finally
    Refs.Free;
  end;

  RepositoryDefaultBranches[Index] := DefaultBranch;

  RepositoryRefsLoaded[Index] := True;
  RepositoryRefsLoadedUrls[Index] := Url;
  RepositoryRefsLoadStatus[Index] := Result;
  RepositoryRefsFetchStarted[Index] := False;
end;

procedure ShowRepositoryRefsError(const Index: Integer; const Status: TRepositoryRefsStatus);
var
  MessageName: String;

begin
  if Status = rrsPending then
    MessageName := 'RepositoryPending'
  else
    MessageName := 'RepositoryUnreachable';
  MsgBox(FmtMessage(CustomMessage(MessageName), [GetRepositoryName(Index),
    GetRepositoryUrl(Index)]), mbError, MB_OK);
end;

// Start fetching the branch/tag list as soon as a URL is picked from the list
// (typed URLs are handled when leaving the field)
procedure RepositoryUrlComboBoxChange(Sender: TObject);
var
  UrlComboBox: TNewComboBox;

begin
  UrlComboBox := Sender as TNewComboBox;
  if UrlComboBox.Items.IndexOf(Trim(UrlComboBox.Text)) <> -1 then
    StartRepositoryRefsFetch(UrlComboBox.Tag);
end;

procedure RepositoryUrlComboBoxExit(Sender: TObject);
begin
  StartRepositoryRefsFetch((Sender as TNewComboBox).Tag);
end;

procedure RepositoryRefComboBoxDropDown(Sender: TObject);
begin
  EnsureRepositoryRefsLoaded((Sender as TNewComboBox).Tag);
end;

// Force reloading the branch/tag list, then show it to the user
procedure RepositoryRefreshButtonClick(Sender: TObject);
var
  Index: Integer;
  Status: TRepositoryRefsStatus;
  Succeeded: Boolean;

begin
  Index := (Sender as TNewButton).Tag;
  RepositoryRefsLoaded[Index] := False;

  // Reuse a fetch still running, but never the result of a finished one
  if RepositoryRefsFetchStarted[Index]
    and IsRepositoryRefsFetchFinished(Index, Succeeded) then
      RepositoryRefsFetchStarted[Index] := False;

  Status := EnsureRepositoryRefsLoaded(Index);
  if Status = rrsSucceeded then
  begin
    WizardForm.ActiveControl := RepositoryRefComboBoxes[Index];
    RepositoryRefComboBoxes[Index].DroppedDown := True;
  end
  else
    ShowRepositoryRefsError(Index, Status);
end;

// Called when the page is displayed: fetch all the lists at once
procedure RepositoriesPageInitialize;
begin
  StartRepositoryRefsFetches(0, REPOSITORIES_COUNT - 1);
end;

// A (possibly abbreviated) commit hash, as opposed to a branch or a tag name.
// It can't be checked here, as "git ls-remote" only lists branches and tags.
function IsCommitHash(const Ref: String): Boolean;
var
  i: Integer;

begin
  // Up to 64 characters for SHA-256 repositories
  Result := (Length(Ref) >= 7) and (Length(Ref) <= 64);
  if Result then
    for i := 1 to Length(Ref) do
      if Pos(Lowercase(Ref[i]), '0123456789abcdef') = 0 then
      begin
        Result := False;
        Exit;
      end;
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
  Status: TRepositoryRefsStatus;

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

    Status := EnsureRepositoryRefsLoaded(i);
    if Status <> rrsSucceeded then
    begin
      ShowRepositoryRefsError(i, Status);
      Result := False;
      Exit;
    end;

    if (Ref <> '') and (not IsRepositoryRefAvailable(i, Ref))
      and (not IsCommitHash(Ref)) then
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

      // The default branch is only shown for information: keep following
      // the default branch of the repository (i.e., empty)
      if (Ref = RepositoryDefaultBranches[i])
        and (RepositoryRefsLoadedUrls[i] = GetRepositoryUrl(i)) then
          Ref := '';
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
      OnChange := @RepositoryUrlComboBoxChange;
      OnExit := @RepositoryUrlComboBoxExit;
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

    // Branch/Tag/Commit, empty means the default branch of the repository
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
