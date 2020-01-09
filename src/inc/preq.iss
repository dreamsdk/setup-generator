[Code]

type
  TPrerequisiteApplication = (paGit, paPython, paSubversion);
  TPrerequisiteApplicationSet = set of TPrerequisiteApplication;
  
function PrerequisiteToCommand(const Prerequisite: TPrerequisiteApplication): String;
begin
  Result := '';
  case Prerequisite of
    paGit: 
      Result := 'git'; 
    paPython:
      Result := 'python';
    paSubversion:
      Result := 'svn';
  end;
end;

function PrerequisiteToString(const Prerequisite: TPrerequisiteApplication): String;
begin
  Result := '';
  case Prerequisite of
    paGit: 
      Result := 'PrerequisiteMissingGit'; 
    paPython:
      Result := 'PrerequisiteMissingPython';
    paSubversion:
      Result := 'PrerequisiteMissingSubversion';
  end;
  Result := CustomMessage(Result);
end;

function GetExtractionTag(const Prerequisite: TPrerequisiteApplication): String;
begin
  Result := '';
  case Prerequisite of
    paGit:
      Result := 'git version';                  
    paPython:
      Result := 'Python';
    paSubversion:
      Result := 'svn, version';
  end;
end;

// Retrieve installed prerequisite version
function GetPrerequisiteVersion(const Prerequisite: TPrerequisiteApplication): String;
var
  TmpFileName, CommandLine, PrerequisiteName, ExtractionTag: String;
  ExecBuffer: AnsiString;
  ResultCode: Integer; 

begin
  PrerequisiteName := PrerequisiteToCommand(Prerequisite);
  ExtractionTag := GetExtractionTag(Prerequisite);
      
  TmpFileName := Format('%s\%s.tmp', [ExpandConstant('{tmp}'), PrerequisiteName]);
  CommandLine := Format('/C %s --version > "%s" 2>&1', [PrerequisiteName, TmpFileName]);
  
  Exec(ExpandConstant('{cmd}'), CommandLine, '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  if LoadStringFromFile(TmpFileName, ExecBuffer) then
  begin
    ExecBuffer := AdjustLineBreaks(ExecBuffer);
    Result := Trim(ExtractStr(ExtractionTag, sLineBreak, ExecBuffer));
    Log(Format('Prerequisite %s version: %s.', [PrerequisiteName, Result]));
  end;
  
  if FileExists(TmpFileName) then
    DeleteFile(TmpFileName);
end;

function CheckPrerequisite(Prerequisites: TPrerequisiteApplicationSet;
  Prerequisite: TPrerequisiteApplication): Boolean;
begin
  Result := True;
  if Prerequisite in Prerequisites then
    Result := GetPrerequisiteVersion(Prerequisite) <> '';
end;

function CheckPrerequisites(Prerequisites: TPrerequisiteApplicationSet; 
  Mandatory: Boolean): Boolean;
var
  PrerequisitesList: TStringList;
  i: Integer;
  PrerequisitesText,  
  PrimaryMessage,
  PrimaryMessage1,  
  SecondaryMessage,
  SecondaryMessage1,
  SecondaryMessage2,
  FinalMessage,
  Separator: String;

begin
  Result := True;

  PrerequisitesText := '';
  PrerequisitesList := TStringList.Create;
  try
    // Note: Unable to iterate over a Set in Inno Setup (not found yet)...

    // Check Git
    if not CheckPrerequisite(Prerequisites, paGit) then
      PrerequisitesList.Add(PrerequisiteToString(paGit));    

    // Check Python
    if not CheckPrerequisite(Prerequisites, paPython) then
      PrerequisitesList.Add(PrerequisiteToString(paPython));

    // Check SVN
    if not CheckPrerequisite(Prerequisites, paSubversion) then
      PrerequisitesList.Add(PrerequisiteToString(paSubversion));

    // Computing the text
    if PrerequisitesList.Count > 0 then
    begin
      // Assemble all prerequisites together
      Separator := '';
      for i := 0 to PrerequisitesList.Count - 1 do
      begin
        PrerequisitesText := PrerequisitesText + Separator + PrerequisitesList[i];
        Separator := ', ';
      end;    

      // This is a cosmetic thing.
      // It will translate "A, B, C" to "A, B and C".
      if PrerequisitesList.Count > 1 then
        PrerequisitesText := ReplaceLastOccurrence(PrerequisitesText, ', ', 
          Format(' %s ', [CustomMessage('PrerequisiteMissingLink')]));
           
      // Verb and plural things.
      PrimaryMessage1 := CustomMessage('PrerequisiteMissingVerbSingle');
      SecondaryMessage1 := CustomMessage('PrerequisiteMissingHintLink1Single');
      SecondaryMessage2 := CustomMessage('PrerequisiteMissingHintLink2Single');
      if PrerequisitesList.Count > 1 then
      begin
        PrimaryMessage1 := CustomMessage('PrerequisiteMissingVerbMultiple');
        SecondaryMessage1 := CustomMessage('PrerequisiteMissingHintLink1Multiple');
        SecondaryMessage2 := CustomMessage('PrerequisiteMissingHintLink2Multiple');
      end;
    end;     
  finally
    PrerequisitesList.Free;
  end;

  if (PrerequisitesText <> '') then
  begin
    PrimaryMessage := Format(CustomMessage('PrerequisiteMissing'), [
      PrerequisitesText, PrimaryMessage1]);
    
    SecondaryMessage := CustomMessage('PrerequisiteMissingHintMandatory');
    if not Mandatory then
      SecondaryMessage := CustomMessage('PrerequisiteMissingHintOptional');
    SecondaryMessage := Format(SecondaryMessage, [
      SecondaryMessage1, SecondaryMessage2]);
    
    FinalMessage := Format('%s %s', [PrimaryMessage, SecondaryMessage]);
   
    Result := False; 
    if Mandatory then
      MsgBox(FinalMessage, mbError, MB_OK)
    else
      Result := MsgBox(FinalMessage, mbConfirmation, MB_YESNO) = IDYES;
  end;
end;

{ Online prerequisites }

// Online mandatory prerequisites
function CheckOnlinePrerequisitesMandatory: Boolean;
begin 
  Result := CheckPrerequisites([paGit], True);
end;

// Online optional prerequisites
function CheckOnlinePrerequisitesOptional: Boolean;
begin
  Result := CheckPrerequisites([paPython, paSubversion], False);
end;
{ Offline prerequisites }

function CheckOfflinePrerequisitesMandatory: Boolean;
begin
  Result := True; // no mandatory prerequisites for offline
end;

// Offline optional prerequisites 
function CheckOfflinePrerequisitesOptional: Boolean;
begin
  Result := CheckPrerequisites([paPython], True);
end;
