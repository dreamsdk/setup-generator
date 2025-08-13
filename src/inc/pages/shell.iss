[code]
var
  RadioButtonShellWindows,
  RadioButtonShellMinTTY: TNewRadioButton;
  ComponentsListShellItemIndexWindows,
  ComponentsListShellItemIndexMinTTY: Integer;

procedure UpdateShell;
begin
  with WizardForm.ComponentsList do
  begin
    // Tick the correct Shell in the ComponentsList
    Checked[ComponentsListShellItemIndexWindows] := not IsShellMinTTY;
    Checked[ComponentsListShellItemIndexMinTTY] := IsShellMinTTY;

    // Force text refresh
    Invalidate;  
  end;

  // Force recalculation of disk space usage
  WizardForm.TypesCombo.OnChange(WizardForm.TypesCombo);
end;

procedure RadioButtonShellWindowsClick(Sender: TObject);
begin
  SetShell(skWindows);
  UpdateShell;
end;

procedure RadioButtonShellMinTTYClick(Sender: TObject);
begin
  SetShell(skMinTTY);
  UpdateShell;
end;

procedure InitializeShellLogic;
begin
  // This should matches in "inc/sections/components.iss"

  ComponentsListShellItemIndexWindows := WizardForm.ComponentsList.Items.IndexOf(
    ExpandConstant('{cm:ComponentShellWindows}')
  );
  ComponentsListShellItemIndexMinTTY := WizardForm.ComponentsList.Items.IndexOf(
    ExpandConstant('{cm:ComponentShellMinTTY}')
  );

  Log(Format('InitializeShellLogic: '
    + 'ComponentsListShellItemIndexWindows=%d, ComponentsListShellItemIndexMinTTY=%d', [
    ComponentsListShellItemIndexWindows,
    ComponentsListShellItemIndexMinTTY
  ]));

  // Initialize choice
  Log('InitializeShellLogic: Initialize choice');
  RadioButtonShellWindowsClick(nil);
end;

function CreateShellPage: Integer;
var
  ShellPage: TWizardPage;
  LabelShellIntroduction, 
  LabelShellDescription,
  LabelShellDescriptionMinTTY,
  LabelShellDescriptionWindows: TLabel;
  BtnImage: TBitmapImage;
  ShellWindowsName: string;

begin
  InitializeShellLogic;

  ShellPage := CreateCustomPage(
    wpSelectDir,
    CustomMessage('ShellTitlePage'), 
    CustomMessage('ShellSubtitlePage')
  );

  BtnImage := SetPageIcon('Shell', ShellPage);

  // Introduction label
  LabelShellIntroduction := TLabel.Create(ShellPage);
  LabelShellIntroduction.Parent := ShellPage.Surface;  
  LabelShellIntroduction.Caption := CustomMessage('LabelShellIntroduction');  
  LabelShellIntroduction.AutoSize := True;
  LabelShellIntroduction.WordWrap := True;
  LabelShellIntroduction.Top := (BtnImage.Height div 2) - (LabelShellIntroduction.Height div 2);
  LabelShellIntroduction.Left := BtnImage.Height + ScaleX(12);

  // Explanation of this page
  LabelShellDescription := TLabel.Create(ShellPage);
  LabelShellDescription.Parent := ShellPage.Surface;
  LabelShellDescription.Caption := CustomMessage('LabelShellDescription');  
  LabelShellDescription.Top := BtnImage.Top + BtnImage.Height + ScaleY(12);
  LabelShellDescription.Width := ShellPage.SurfaceWidth;
  SetMultiLinesLabel(LabelShellDescription, 4);
    
  // Define the name of Windows Shell  
  ShellWindowsName := CustomMessage('ShellWindows_Prompt');
  if IsWindowsTerminalInstalled then
    ShellWindowsName := CustomMessage('ShellWindows_Terminal');
  Log(Format('ShellWindowsName: %s', [ShellWindowsName]));

  // Windows Command Prompt / Windows Terminal     
  RadioButtonShellWindows := TNewRadioButton.Create(ShellPage);
  RadioButtonShellWindows.OnClick := @RadioButtonShellWindowsClick;
  RadioButtonShellWindows.Checked := True;
  RadioButtonShellWindows.Parent := ShellPage.Surface;
  RadioButtonShellWindows.Caption := Format(CustomMessage('ShellWindows'), [
    ShellWindowsName
  ]);
  RadioButtonShellWindows.Top := LabelShellDescription.Top 
    + LabelShellDescription.Height + ScaleY(4);
  RadioButtonShellWindows.Width := ShellPage.SurfaceWidth;
  RadioButtonShellWindows.Font.Style := [fsBold];

  LabelShellDescriptionWindows := TLabel.Create(ShellPage);
  LabelShellDescriptionWindows.Parent := ShellPage.Surface;
  LabelShellDescriptionWindows.Caption := Format(CustomMessage('LabelShellDescriptionWindows'), [
    ShellWindowsName,
    sEmptyStr
  ]);
  if IsWindowsTerminalInstalled then
    LabelShellDescriptionWindows.Caption := Format(CustomMessage('LabelShellDescriptionWindows'), [
      ShellWindowsName,
      CustomMessage('LabelShellDescriptionWindows_Terminal')
    ]);
  LabelShellDescriptionWindows.Top := RadioButtonShellWindows.Top + RadioButtonShellWindows.Height + ScaleY(4);
  LabelShellDescriptionWindows.Width := ShellPage.SurfaceWidth;
  SetMultiLinesLabel(LabelShellDescriptionWindows, 3);

  // MinTTY
  RadioButtonShellMinTTY := TNewRadioButton.Create(ShellPage);  
  RadioButtonShellMinTTY.OnClick := @RadioButtonShellMinTTYClick;
  RadioButtonShellMinTTY.Checked := not RadioButtonShellWindows.Checked;
  RadioButtonShellMinTTY.Parent := ShellPage.Surface;
  RadioButtonShellMinTTY.Caption := CustomMessage('ShellMinTTY');  
  RadioButtonShellMinTTY.Top := LabelShellDescriptionWindows.Top 
    + LabelShellDescriptionWindows.Height + ScaleY(8);
  RadioButtonShellMinTTY.Width := ShellPage.SurfaceWidth;
  RadioButtonShellMinTTY.Font.Style := [fsBold];

  LabelShellDescriptionMinTTY := TLabel.Create(ShellPage);  
  LabelShellDescriptionMinTTY.Parent := ShellPage.Surface;
  LabelShellDescriptionMinTTY.Caption := CustomMessage('LabelShellDescriptionMinTTY'); 
  LabelShellDescriptionMinTTY.Top := RadioButtonShellMinTTY.Top + RadioButtonShellMinTTY.Height + ScaleY(4);
  LabelShellDescriptionMinTTY.Width := ShellPage.SurfaceWidth;
  SetMultiLinesLabel(LabelShellDescriptionMinTTY, 3); 

  // Return Page ID
  Result := ShellPage.ID;
end;
