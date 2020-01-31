[Code]

const
  COMPONENTS_SEPARATOR = ';';
  COMPONENTS_CODES = 'helpers\img4dc;helpers\ipcreate;helpers\mkisofs';
  COMPONENTS_MESSAGES = 'ComponentMessageWarning_img4dc;ComponentMessageWarning_ipcreate;ComponentMessageWarning_mkisofs'; 
 
function CheckComponents: Boolean;
var
  Codes,
  Messages: TArrayOfString;
  i: Integer;
  TextMessage: string;
  Buffer: TStringList;

begin
  Result := True;

  Codes := Split(COMPONENTS_CODES, COMPONENTS_SEPARATOR);
  Messages := Split(COMPONENTS_MESSAGES, COMPONENTS_SEPARATOR);

  Buffer := TStringList.Create;
  try 
    for i := Low(Codes) to High(Codes) do
    begin
      if not IsComponentSelected(Codes[i]) then
        Buffer.Add(CustomMessage(Messages[i]));
    end;
    TextMessage := Buffer.Text;
  finally
    Buffer.Free;
  end;

  if TextMessage <> '' then
    Result := MsgBox(CustomMessage('ComponentMessageWarningStart') 
      + TextMessage + CustomMessage('ComponentMessageWarningEnd'), mbError, MB_YESNO) = IDYES;
end;
