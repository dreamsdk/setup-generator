#define TestConnectionURL "http://dreamsdk.org/.update/version.txt"

[Code]

(* Used by the installer for checking if Internet is available
 * This should be HTTP only
 * See: https://stackoverflow.com/a/39291592/3726096 
 *)
function CheckInternetConnection: Boolean;
var
  WinHttpReq: Variant;
  Connected: Boolean;

begin
  Connected := False;
  repeat
    Log('Checking connection to the server');
    try
      WinHttpReq := CreateOleObject('WinHttp.WinHttpRequest.5.1');
      WinHttpReq.Open('GET', '{#TestConnectionURL}', False);
      WinHttpReq.Send('');
      Log(Format('Connected to the server; status: %s %s', [WinHttpReq.Status, WinHttpReq.StatusText]));
      Connected := True;
    except
      Log(Format('Error connecting to the server: %s', [GetExceptionMessage]));
      if WizardSilent then
      begin
        Log('Connection to the server is not available, aborting silent installation');
        Result := False;
        Exit;
      end
      else 
        case MsgBox(CustomMessage('InactiveInternetConnection'), mbError, MB_ABORTRETRYIGNORE) of
          IDRETRY:
            Log('Retrying');
          IDABORT:
            begin
              Log('Aborting');
              Result := False;
              Exit;
            end;
           IDIGNORE:
            begin
              Log('Ignoring');
              Result := True;
              Exit;
            end;
        end;
    end;
  until Connected;
  Result := True;
end;
