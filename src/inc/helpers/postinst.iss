[Code]
// Post-install steps (i.e., unpacking toolchains, installing KallistiOS,
// KallistiOS Ports and Dreamcast Tool), done by the post-install helper
// library (postinst.dll) while displaying the progress in the wizard.

const
  POST_INSTALL_POLL_INTERVAL = 100;
  POST_INSTALL_MEMO_MAX_LINES = 1000;
  POST_INSTALL_LOG_FILE_NAME = 'postinst.log';

var
  PostInstallAbortRequested,
  PostInstallCloseRequested: Boolean;

// Log file, i.e. "{code:GetApplicationSupportPath}\postinst.log"
function GetPostInstallLogFileName(const HomeDirectory: String): String;
begin
  Result := AddBackslash(HomeDirectory) + '{#AppSupportDirectoryName}\'
    + POST_INSTALL_LOG_FILE_NAME;
end;

procedure PostInstallAbortButtonClick(Sender: TObject);
begin
  if MsgBox(CustomMessage('PostInstallAbortConfirmation'), mbConfirmation,
    MB_YESNO or MB_DEFBUTTON2) = IDYES then
  begin
    PostInstallAbortRequested := True;
    TNewButton(Sender).Enabled := False;
  end;
end;

procedure PostInstallCloseButtonClick(Sender: TObject);
begin
  PostInstallCloseRequested := True;
end;

// True when the last line of the memo is visible, i.e. the user didn't scroll
// up to read the output
function PostInstallIsMemoScrolledToBottom(OutputMemo: TNewMemo): Boolean;
var
  LastVisibleLine: Integer;

begin
  // The line index is in the high-order word
  LastVisibleLine := (SendMessage(OutputMemo.Handle, EM_CHARFROMPOS, 0,
    (OutputMemo.ClientHeight - 1) shl 16) shr 16) and $FFFF;
  Result := LastVisibleLine >=
    SendMessage(OutputMemo.Handle, EM_GETLINECOUNT, 0, 0) - 1;
end;

// The memo follows the output only when it is scrolled to the bottom, so the
// user can scroll up (or right) to read the output without being disturbed
procedure PostInstallAddLines(const NewLines: String; OutputMemo: TNewMemo;
  OutputLog: TStringList);
var
  FollowOutput: Boolean;
  FirstVisibleLine,
  HorizontalPosition,
  SelectionStart,
  SelectionLength,
  DeletedLines,
  DeletedChars,
  TextLength: Integer;

begin
  if NewLines = '' then
    Exit;
  OutputLog.Add(NewLines);

  FollowOutput := PostInstallIsMemoScrolledToBottom(OutputMemo);
  FirstVisibleLine := SendMessage(OutputMemo.Handle, EM_GETFIRSTVISIBLELINE, 0, 0);
  HorizontalPosition := GetScrollPos(OutputMemo.Handle, SB_HORZ);
  SelectionStart := OutputMemo.SelStart;
  SelectionLength := OutputMemo.SelLength;

  // Adding or deleting lines moves the caret and scrolls the memo, so the
  // redraw is disabled until the scroll position is restored
  SendMessage(OutputMemo.Handle, WM_SETREDRAW, 0, 0);
  try
    OutputMemo.Lines.Add(NewLines);

    // Keep the memo small, the full output is in the log file
    DeletedLines := 0;
    DeletedChars := 0;
    while OutputMemo.Lines.Count > POST_INSTALL_MEMO_MAX_LINES do
    begin
      DeletedChars := DeletedChars + Length(OutputMemo.Lines[0]) + 2;
      OutputMemo.Lines.Delete(0);
      DeletedLines := DeletedLines + 1;
    end;

    if FollowOutput then
    begin
      TextLength := SendMessage(OutputMemo.Handle, WM_GETTEXTLENGTH, 0, 0);
      SendMessage(OutputMemo.Handle, EM_SETSEL, TextLength, TextLength);
      SendMessage(OutputMemo.Handle, EM_SCROLLCARET, 0, 0);
    end
    else
    begin
      // Keep the selection and the visible lines where the user left them
      SelectionStart := SelectionStart - DeletedChars;
      if SelectionStart < 0 then
      begin
        SelectionLength := SelectionLength + SelectionStart;
        if SelectionLength < 0 then
          SelectionLength := 0;
        SelectionStart := 0;
      end;
      OutputMemo.SelStart := SelectionStart;
      OutputMemo.SelLength := SelectionLength;

      FirstVisibleLine := FirstVisibleLine - DeletedLines;
      if FirstVisibleLine < 0 then
        FirstVisibleLine := 0;
      SendMessage(OutputMemo.Handle, EM_LINESCROLL, 0, FirstVisibleLine
        - SendMessage(OutputMemo.Handle, EM_GETFIRSTVISIBLELINE, 0, 0));
    end;

    // The horizontal position is always kept
    SendMessage(OutputMemo.Handle, WM_HSCROLL,
      SB_THUMBPOSITION or (HorizontalPosition shl 16), 0);
  finally
    SendMessage(OutputMemo.Handle, WM_SETREDRAW, 1, 0);
    RedrawWindow(OutputMemo.Handle, 0, 0,
      RDW_INVALIDATE or RDW_ERASE or RDW_FRAME);
  end;
end;

// Position is 0 to 100 when a percentage is detected in the output, or -1 when
// the progress is unknown, as done in DreamSDK Manager
procedure PostInstallUpdateProgressBar(ProgressPage: TOutputProgressWizardPage;
  const Position: Integer);
begin
  if Position < 0 then
  begin
    if ProgressPage.ProgressBar.Style <> npbstMarquee then
      ProgressPage.ProgressBar.Style := npbstMarquee;
  end
  else
  begin
    if ProgressPage.ProgressBar.Style <> npbstNormal then
      ProgressPage.ProgressBar.Style := npbstNormal;
    ProgressPage.SetProgress(Position, 100);
  end;
end;

// Keep the progress page displayed until the user clicks on the Close button,
// so the output can be read (as done in DreamSDK Manager)
procedure PostInstallWaitForClose(ProgressPage: TOutputProgressWizardPage;
  CloseButton: TNewButton; const StatusText: String);
begin
  PostInstallCloseRequested := False;
  CloseButton.Caption := CustomMessage('PostInstallCloseButton');
  CloseButton.OnClick := @PostInstallCloseButtonClick;
  CloseButton.Enabled := True;
  ProgressPage.ProgressBar.Style := npbstNormal;
  ProgressPage.SetProgress(0, 100);
  ProgressPage.SetText(StatusText, '');
  while not PostInstallCloseRequested do
  begin
    // This processes the window messages (e.g., CloseButton click)
    ProgressPage.SetText(StatusText, '');
    Sleep(POST_INSTALL_POLL_INTERVAL);
  end;
end;

// Run the post-install helper for the DreamSDK installation directory
// (HomeDirectory) and returns one of POST_INSTALL_STATUS_*.
// POST_INSTALL_STATUS_IDLE means that the helper couldn't be used at all.
function RunPostInstallHelper(const HomeDirectory: String): Cardinal;
var
  ProgressPage: TOutputProgressWizardPage;
  OutputMemo: TNewMemo;
  AbortButton: TNewButton;
  OutputLog: TStringList;
  ProgressText,
  PreviousProgressText,
  NewLines,
  StatusText: String;
  HelperLoaded,
  HelperInitialized,
  AbortSent: Boolean;

begin
  Result := POST_INSTALL_STATUS_IDLE;
  PostInstallAbortRequested := False;
  HelperLoaded := False;
  HelperInitialized := False;
  AbortSent := False;
  PreviousProgressText := '';

  ProgressPage := CreateOutputProgressPage(CustomMessage('PostInstallTitle'),
    CustomMessage('PostInstallDescription'));

  // AbortButton
  AbortButton := TNewButton.Create(ProgressPage);
  AbortButton.Caption := CustomMessage('PostInstallAbortButton');
  AbortButton.Width := ScaleX(75);
  AbortButton.Height := ScaleY(23);
  AbortButton.Left := ProgressPage.SurfaceWidth - AbortButton.Width;
  AbortButton.Top := ProgressPage.SurfaceHeight - AbortButton.Height;
  AbortButton.OnClick := @PostInstallAbortButtonClick;
  AbortButton.Parent := ProgressPage.Surface;

  // The second message is never used, so the progress bar takes its place to
  // give more room to the output
  ProgressPage.Msg2Label.Visible := False;
  ProgressPage.ProgressBar.Top := ProgressPage.Msg2Label.Top;

  // OutputMemo
  OutputMemo := TNewMemo.Create(ProgressPage);
  OutputMemo.Top := ProgressPage.ProgressBar.Top
    + ProgressPage.ProgressBar.Height + ScaleY(8);
  OutputMemo.Width := ProgressPage.SurfaceWidth;
  OutputMemo.Height := AbortButton.Top - OutputMemo.Top - ScaleY(8);
  OutputMemo.ScrollBars := ssBoth;
  OutputMemo.ReadOnly := True;
  OutputMemo.WordWrap := False;
  OutputMemo.Color := clWindow;
  // Same font as the DreamSDK Manager progress window
  OutputMemo.Font.Name := 'Courier New';
  OutputMemo.Font.Size := 8;
  OutputMemo.Parent := ProgressPage.Surface;

  // Marquee until a percentage is detected in the output
  ProgressPage.ProgressBar.Style := npbstMarquee;

  OutputLog := TStringList.Create;
  ProgressPage.Show;
  // The progress bar is displayed only when SetProgress is called
  ProgressPage.SetProgress(0, 100);
  try
    try
      // The library is loaded on the first call (delayload)
      HelperInitialized := PostInstallInitialize(HomeDirectory);
      HelperLoaded := True;
      if HelperInitialized and PostInstallStart() then
      begin
        repeat
          Result := PostInstallPoll();

          ProgressText := PostInstallGetProgressText();
          if ProgressText <> PreviousProgressText then
          begin
            Log('Post-install: ' + ProgressText);
            PreviousProgressText := ProgressText;
          end;

          PostInstallAddLines(PostInstallGetNewLines(), OutputMemo, OutputLog);
          PostInstallUpdateProgressBar(ProgressPage, PostInstallGetProgressPosition());

          if PostInstallAbortRequested and (not AbortSent) then
          begin
            Log('Post-install: abort requested');
            PostInstallAbort();
            AbortSent := True;
          end;

          // This processes the window messages (e.g., AbortButton click)
          ProgressPage.SetText(ProgressText, '');

          if Result = POST_INSTALL_STATUS_RUNNING then
            Sleep(POST_INSTALL_POLL_INTERVAL);
        until Result <> POST_INSTALL_STATUS_RUNNING;

        // Get the remaining lines
        repeat
          NewLines := PostInstallGetNewLines();
          PostInstallAddLines(NewLines, OutputMemo, OutputLog);
        until NewLines = '';
      end
      else
        Log('Post-install: unable to initialize or start the helper');
    except
      Log('Post-install: helper exception: ' + GetExceptionMessage);
      if Result = POST_INSTALL_STATUS_RUNNING then
        Result := POST_INSTALL_STATUS_FAILED;
    end;

    case Result of
      POST_INSTALL_STATUS_FAILED:
        StatusText := CustomMessage('PostInstallFailedStatus');
      POST_INSTALL_STATUS_ABORTED:
        StatusText := CustomMessage('PostInstallAbortedStatus');
    else
      StatusText := '';
    end;
    if StatusText <> '' then
      PostInstallAddLines('*** ' + StatusText, OutputMemo, OutputLog);
  finally
    if HelperLoaded then
    begin
      try
        PostInstallFinalize();
      except
        Log('Post-install: finalize exception: ' + GetExceptionMessage);
      end;
      PostInstallUnload();
    end;

    if OutputLog.Count > 0 then
      try
        ForceDirectories(ExtractFileDir(GetPostInstallLogFileName(HomeDirectory)));
        OutputLog.SaveToFile(GetPostInstallLogFileName(HomeDirectory));
      except
        Log('Post-install: unable to save the log file: ' + GetExceptionMessage);
      end;
    OutputLog.Free;

    // Let the user read the output when something went wrong (the wizard is
    // hidden when running silently, so nobody could click on Close)
    if (Result = POST_INSTALL_STATUS_FAILED) and (not WizardSilent) then
      PostInstallWaitForClose(ProgressPage, AbortButton, StatusText);

    ProgressPage.Hide;
  end;

  Log(Format('Post-install: status: %d', [Result]));
end;
