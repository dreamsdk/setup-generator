[Code]
// Thanks to Martin Prikryl
// https://stackoverflow.com/a/38292498

function IsWindowsVersionOrGreater(Major, Minor: Integer): Boolean;
var
  Version: TWindowsVersion;
begin
  GetWindowsVersionEx(Version);
  Result :=
    (Version.Major > Major) or
    ((Version.Major = Major) and (Version.Minor >= Minor));
end;

function IsWindowsXPOrGreater: Boolean;
begin
  Result := IsWindowsVersionOrGreater(5, 1);
end;

function IsWindowsVistaOrGreater: Boolean;
begin
  Result := IsWindowsVersionOrGreater(6, 0);
end;

function IsWindows7OrGreater: Boolean;
begin
  Result := IsWindowsVersionOrGreater(6, 1);
end;

function IsWindows8OrGreater: Boolean;
begin
  Result := IsWindowsVersionOrGreater(6, 2);
end;

function IsWindows10OrGreater: Boolean;
begin
  Result := IsWindowsVersionOrGreater(10, 0);
end;

// Windows 11 has the same major.minor as Windows 10.
// So it has to be distinguished by the Build.
// The IsWindows10OrGreater condition is actually redundant.
// Once we have to test for Windows 11 using the build number, we could actually
// unify and simplify all the tests above to use the build numbers only too.
function IsWindows11OrGreater: Boolean;
var
  Version: TWindowsVersion;
  
begin
  GetWindowsVersionEx(Version);
  Result := IsWindows10OrGreater and (Version.Build >= 22000);
end;
