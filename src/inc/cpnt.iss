[Code]

const
  COMPONENTS_SEPARATOR = ';';
  COMPONENTS_CODES = 'addons\img4dc;addons\ipcreate;addons\mkisofs';
  COMPONENTS_MESSAGES = 'ComponentMessageWarning_img4dc;ComponentMessageWarning_ipcreate;ComponentMessageWarning_mkisofs'; 
 
function CheckComponents: Boolean;
var
  Codes,
  Messages: TArrayOfString;
  i: Integer;
  TextMessage,
  TextSeparator: string;

begin
  Result := True;

  Codes := Split(COMPONENTS_CODES, COMPONENTS_SEPARATOR);
  Messages := Split(COMPONENTS_MESSAGES, COMPONENTS_SEPARATOR);

  TextMessage := '';
  TextSeparator := '';  
  for i := Low(Codes) to High(Codes) do
  begin
    if not IsComponentSelected(Codes[i]) then
      TextMessage := TextMessage + TextSeparator + CustomMessage(Messages[i]);
    TextSeparator := sLineBreak;
  end;

  if TextMessage <> '' then
    Result := MsgBox(CustomMessage('ComponentMessageWarningStart') 
      + TextMessage + CustomMessage('ComponentMessageWarningEnd'), mbError, MB_YESNO) = IDYES;
end;
