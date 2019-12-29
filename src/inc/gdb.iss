[code]
var
  RadioButtonNone,
  RadioButtonPython27,
  RadioButtonPython34,
  RadioButtonPython35,
  RadioButtonPython36,
  RadioButtonPython37,
  RadioButtonPython38: TNewRadioButton;

function RunSimpleCommandOnPython(CommandName, PythonFileName: String): String;
begin
  Result := Trim(
    RunCommand(
      ExpandConstant(
        Format('{tmp}\%s "%s"', [CommandName, PythonFileName])
      )
    )
  );  
end;

function TestPythonVersion(Version: string): Boolean;
var
  PythonFileName, PythonBitness, PythonFilePath, VersionWithoutDot: String;

begin
  Result := False;

  VersionWithoutDot := Version;
  StringChangeEx(VersionWithoutDot, '.', '', True);
  PythonFileName := Format('python%s.dll', [VersionWithoutDot]);    
  PythonFilePath := RunSimpleCommandOnPython('whereis.bat', PythonFileName);
  
  if FileExists(PythonFilePath) then
  begin
    Log(Format('Python %s is installed: %s', [Version, PythonFilePath]));
    PythonBitness := RunSimpleCommandOnPython('pecheck.exe', PythonFilePath);
    Result := PythonBitness = '32-bits'; // 32-bits only
    Log(Format('Python %s bitness is %s', [Version, PythonBitness]));
  end
  else
    Log(Format('Python %s is not installed', [Version]));

//  Result := StartsWith(Version, PythonVersion) and Result;
end;

function IsGdbPythonNone: Boolean;
begin
  Result := RadioButtonNone.Checked;
end;

function IsGdbPython27: Boolean;
begin
  Result := RadioButtonPython27.Checked;
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

function CreateGdbPage: Integer;
var
  GdbPage: TWizardPage;
  LabelGdbIntroduction, 
  LabelGdbDescription: TLabel;
  BtnImage: TBitmapImage;

begin
  GdbPage := CreateCustomPage(wpSelectComponents, 
    CustomMessage('GdbTitlePage'), 
    CustomMessage('GdbSubtitlePage'));
  
  ExtractTemporaryFile('whereis.bat');
  ExtractTemporaryFile('pecheck.exe');

  ExtractTemporaryFile('python.bmp');  
  BtnImage := TBitmapImage.Create(WizardForm);
  with BtnImage do
  begin
    Parent := GdbPage.Surface;
    Bitmap.LoadFromFile(ExpandConstant('{tmp}') + '\python.bmp');
    Bitmap.AlphaFormat := afPremultiplied; 
    AutoSize := True;
    Left := 0;
    Top := 0;
  end;

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
  LabelGdbDescription.Height := ScaleY(LabelGdbIntroduction.Height * 3); // Hack to have 3 lines label... LabelGdbIntroduction.Height is only 1 line... This is BAD
    
  // No Python
  RadioButtonNone := TNewRadioButton.Create(GdbPage);
  RadioButtonNone.Parent := GdbPage.Surface;
  RadioButtonNone.Caption := 'None'  
  RadioButtonNone.Top := LabelGdbDescription.Top 
    + LabelGdbDescription.Height + ScaleY(4);
  RadioButtonNone.Width := GdbPage.SurfaceWidth;
  RadioButtonNone.Checked := True;
  
  // Python 2.7
  RadioButtonPython27 := TNewRadioButton.Create(GdbPage);
  RadioButtonPython27.Parent := GdbPage.Surface;
  RadioButtonPython27.Caption := 'Python 2.7'  
  RadioButtonPython27.Top := RadioButtonNone.Top 
    + RadioButtonNone.Height + ScaleY(4);
  RadioButtonPython27.Width := GdbPage.SurfaceWidth;
  RadioButtonPython27.Enabled := TestPythonVersion('2.7');

  // Python 3.4
  RadioButtonPython34 := TNewRadioButton.Create(GdbPage);
  RadioButtonPython34.Parent := GdbPage.Surface;
  RadioButtonPython34.Caption := 'Python 3.4'  
  RadioButtonPython34.Top := RadioButtonPython27.Top 
    + RadioButtonPython27.Height + ScaleY(4);
  RadioButtonPython34.Width := GdbPage.SurfaceWidth;
  RadioButtonPython34.Enabled := TestPythonVersion('3.4');

  // Python 3.5
  RadioButtonPython35 := TNewRadioButton.Create(GdbPage);
  RadioButtonPython35.Parent := GdbPage.Surface;
  RadioButtonPython35.Caption := 'Python 3.5'  
  RadioButtonPython35.Top := RadioButtonPython34.Top 
    + RadioButtonPython34.Height + ScaleY(4);
  RadioButtonPython35.Width := GdbPage.SurfaceWidth;
  RadioButtonPython35.Enabled := TestPythonVersion('3.5');

  // Python 3.6
  RadioButtonPython36 := TNewRadioButton.Create(GdbPage);
  RadioButtonPython36.Parent := GdbPage.Surface;
  RadioButtonPython36.Caption := 'Python 3.6'  
  RadioButtonPython36.Top := RadioButtonPython35.Top 
    + RadioButtonPython35.Height + ScaleY(4);
  RadioButtonPython36.Width := GdbPage.SurfaceWidth;
  RadioButtonPython36.Enabled := TestPythonVersion('3.6');

  // Python 3.7
  RadioButtonPython37 := TNewRadioButton.Create(GdbPage);
  RadioButtonPython37.Parent := GdbPage.Surface;
  RadioButtonPython37.Caption := 'Python 3.7'  
  RadioButtonPython37.Top := RadioButtonPython36.Top 
    + RadioButtonPython36.Height + ScaleY(4);
  RadioButtonPython37.Width := GdbPage.SurfaceWidth;
  RadioButtonPython37.Enabled := TestPythonVersion('3.7');

  // Python 3.8
  RadioButtonPython38 := TNewRadioButton.Create(GdbPage);
  RadioButtonPython38.Parent := GdbPage.Surface;
  RadioButtonPython38.Caption := 'Python 3.8'  
  RadioButtonPython38.Top := RadioButtonPython37.Top 
    + RadioButtonPython37.Height + ScaleY(4);
  RadioButtonPython38.Width := GdbPage.SurfaceWidth;
  RadioButtonPython38.Enabled := TestPythonVersion('3.8');

  Result := GdbPage.ID;
end;
