[Code]
const
  sLineBreak = #13#10;
  
// Thanks Michel (Phidels.com)
function Left(SubStr, S: String): String;
begin
  result:=copy(s, 1, pos(substr, s)-1);
end;

// Thanks Michel (Phidels.com)
function Right(SubStr, S: String): String;
begin
  if pos(substr,s)=0 then result:='' else
    result:=copy(s, pos(substr, s)+length(substr), length(s)-pos(substr, s)+length(substr));
end;

// Thanks Michel (Phidels.com)
function ExtractStr(LeftSubStr, RightSubStr, S: String): String;
begin
  Result := Left(RightSubStr, Right(LeftSubStr, S));
end;

function IsInString(const SubStr, S: string): Boolean;
begin
  Result := Pos(LowerCase(SubStr), LowerCase(S)) > 0;
end;

function AdjustLineBreaks(const S: String): String;
begin
  Result := S;
  StringChangeEx(Result, #10, sLineBreak, True);
end;

// https://stackoverflow.com/a/1282143/3726096
function StartsWith( const AMatchStr, ATestStr : string ) : Boolean;
begin
  Result := AMatchStr = Copy( ATestStr, 1, Length( AMatchStr ));
end;

// Replace a string in a existing file
function PatchFile(const FileName, OldValue, NewValue: String): Boolean;
var
  Temp: String;
  Buffer: TStringList;

begin
  Result := False;
  if FileExists(FileName) then
  begin
    Buffer := TStringList.Create;
    try
      Buffer.LoadFromFile(FileName);
      Temp := Buffer.Text;
      StringChangeEx(Temp, OldValue, NewValue, True);
      Buffer.Text := Temp;
      Buffer.SaveToFile(FileName);
      Result := True;
    finally
      Buffer.Free;
    end;
  end;
end;