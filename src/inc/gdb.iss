[code]
var
  GdbPage: TWizardPage;
  RadioButtonNone,
  RadioButtonPython27,
  RadioButtonPython33,
  RadioButtonPython34,
  RadioButtonPython35,
  RadioButtonPython36,
  RadioButtonPython37,
  RadioButtonPython38,
  RadioButtonPython39,
  RadioButtonPython310,
  RadioButtonPython311: TNewRadioButton;

function RunSimpleCommandOnPython(CommandName, PythonFileName: String): String;
begin
  Result := RunCommand(
      ExpandConstant(
        Format('{tmp}\%s "%s"', [CommandName, PythonFileName])
      ),
      True
    );  
end;

function TestPythonVersion(Version: String): Boolean;
var
  i: Integer;
  Buffer,
  PythonFileName,
  PythonBitness,
  PythonFilePath,
  VersionWithoutDot: String;
  PythonFilePaths: TArrayOfString;
  
begin
  Result := False;
  Log(Format('TestPythonVersion: %s', [Version]));

  VersionWithoutDot := Version;
  StringChangeEx(VersionWithoutDot, '.', '', True);
  PythonFileName := Format('python%s.dll', [VersionWithoutDot]);    
  
  Buffer := RunSimpleCommandOnPython('whereis.exe', PythonFileName);
  Explode(PythonFilePaths, Buffer, sLineBreak);  
  
  for i := 0 to Length(PythonFilePaths) - 1 do
  begin
    PythonFilePath := PythonFilePaths[i];
    if FileExists(PythonFilePath) then
    begin
      Log(Format('Python %s is installed: %s', [Version, PythonFilePath]));
      PythonBitness := RunSimpleCommandOnPython('pecheck.exe', PythonFilePath);
      Result := Result or (PythonBitness = '32-bits'); // 32-bits only
      Log(Format('Python %s bitness is %s', [Version, PythonBitness]));
    end
    else
      Log(Format('Python %s is not installed', [Version]));
  end;
end;

function IsGdbPythonNone: Boolean;
begin
  Result := RadioButtonNone.Checked;
end;

function IsGdbPython27: Boolean;
begin
  Result := RadioButtonPython27.Checked;
end;

function IsGdbPython33: Boolean;
begin
  Result := RadioButtonPython33.Checked;
end;

function IsGdbPython34: Boolean;
begin
  Result := RadioButtonPython34.Checked;
end;

function IsGdbPython35: Boolean;
begin
  Result := RadioButtonPython35.Checked;
end;

function IsGdbPython36: Boolean;
begin
  Result := RadioButtonPython36.Checked;
end;

function IsGdbPython37: Boolean;
begin
  Result := RadioButtonPython37.Checked;
end;

function IsGdbPython38: Boolean;
begin
  Result := RadioButtonPython38.Checked;
end;

function IsGdbPython39: Boolean;
begin
  Result := RadioButtonPython39.Checked;
end;

function IsGdbPython310: Boolean;
begin
  Result := RadioButtonPython310.Checked;
end;

function IsGdbPython311: Boolean;
begin
  Result := RadioButtonPython311.Checked;
end;

function CreateGdbPythonButton(Version: String; ButtonLeft: Integer;
  var FromButton: TNewRadioButton; FirstRow: Boolean): TNewRadioButton;
var
  ButtonLabel: String;
  ScaleValue: Integer;

begin
  ButtonLabel := Version;
  StringChangeEx(ButtonLabel, '.', '', True);
  ButtonLabel := 'GdbPython' + ButtonLabel;
  
  ScaleValue := 4;
  if FirstRow then
    ScaleValue := 8;
      
  Result := TNewRadioButton.Create(GdbPage);
  Result.Parent := GdbPage.Surface;
  Result.Caption := CustomMessage(ButtonLabel);  
  Result.Top := FromButton.Top + FromButton.Height + ScaleY(ScaleValue);
  Result.Left := ButtonLeft;
  Result.Width := GdbPage.SurfaceWidth;
  Result.Enabled := TestPythonVersion(Version);  
end;

function CreateGdbPage: Integer;
var
  LabelGdbIntroduction, 
  LabelGdbDescription: TLabel;
  BtnImage: TBitmapImage;
  RowLeft1, RowLeft2: Integer;

begin
  GdbPage := CreateCustomPage(wpSelectComponents, 
    CustomMessage('GdbTitlePage'), 
    CustomMessage('GdbSubtitlePage'));
  
  ExtractTemporaryFile('whereis.exe');
  ExtractTemporaryFile('pecheck.exe');
 
  RowLeft1 := 0;
  RowLeft2 := GdbPage.SurfaceWidth div 2;

  BtnImage := SetPageIcon('gdb', GdbPage);

  // Introduction label
  LabelGdbIntroduction := TLabel.Create(GdbPage);
  LabelGdbIntroduction.Parent := GdbPage.Surface;  
  LabelGdbIntroduction.Caption := CustomMessage('LabelGdbIntroduction');  
  LabelGdbIntroduction.AutoSize := True;
  LabelGdbIntroduction.WordWrap := True;
  LabelGdbIntroduction.Top := (BtnImage.Height div 2) - (LabelGdbIntroduction.Height div 2);
  LabelGdbIntroduction.Left := BtnImage.Height + ScaleX(12);

  // Explanation of this page
  LabelGdbDescription := TLabel.Create(GdbPage);
  LabelGdbDescription.Parent := GdbPage.Surface;
  LabelGdbDescription.Caption := CustomMessage('LabelGdbDescription'); 
  LabelGdbDescription.AutoSize := True;
  LabelGdbDescription.WordWrap := True;  
  LabelGdbDescription.Top := BtnImage.Top + BtnImage.Height + ScaleY(12);
  LabelGdbDescription.Width := GdbPage.SurfaceWidth;
  SetMultiLinesLabel(LabelGdbDescription, 4);
    
  // No Python
  RadioButtonNone := TNewRadioButton.Create(GdbPage);
  RadioButtonNone.Parent := GdbPage.Surface;
  RadioButtonNone.Caption := CustomMessage('GdbPythonNone');  
  RadioButtonNone.Top := LabelGdbDescription.Top 
    + LabelGdbDescription.Height + ScaleY(4);
  RadioButtonNone.Width := GdbPage.SurfaceWidth;
  RadioButtonNone.Font.Style := [fsBold];
  RadioButtonNone.Checked := True;

  // Row 1

  // Python 2.7
  RadioButtonPython27 := CreateGdbPythonButton('2.7', RowLeft1, RadioButtonNone, True);

  // Python 3.3
  RadioButtonPython33 := CreateGdbPythonButton('3.3', RowLeft1, RadioButtonPython27, False);

  // Python 3.4
  RadioButtonPython34 := CreateGdbPythonButton('3.4', RowLeft1, RadioButtonPython33, False);

  // Python 3.5
  RadioButtonPython35 := CreateGdbPythonButton('3.5', RowLeft1, RadioButtonPython34, False);

  // Python 3.6
  RadioButtonPython36 := CreateGdbPythonButton('3.6', RowLeft1, RadioButtonPython35, False);

  // Row 2

  // Python 3.7
  RadioButtonPython37 := CreateGdbPythonButton('3.7', RowLeft2, RadioButtonNone, True);

  // Python 3.8
  RadioButtonPython38 := CreateGdbPythonButton('3.8', RowLeft2, RadioButtonPython27, False);

  // Python 3.9
  RadioButtonPython39 := CreateGdbPythonButton('3.9', RowLeft2, RadioButtonPython33, False);

  // Python 3.10
  RadioButtonPython310 := CreateGdbPythonButton('3.10', RowLeft2, RadioButtonPython34, False);

  // Python 3.11
  RadioButtonPython311 := CreateGdbPythonButton('3.11', RowLeft2, RadioButtonPython35, False);

  Result := GdbPage.ID;
end;
