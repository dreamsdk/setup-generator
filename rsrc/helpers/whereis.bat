@echo off

rem WhereIS by Claus
rem https://superuser.com/a/544988/436364

setlocal enabledelayedexpansion
set var_a=%1
call :sub %var_a%
if exist %var_b% goto exit
for %%i in ( .com .exe .cmd .bat) do (
 call :sub %var_a%%%i
 if exist !var_b! goto exit
)
set "var_a="
set "var_b="
exit /b 1

:sub
set var_b=%~$PATH:1
goto :EOF

:exit
echo %var_b%
set "var_a="
set "var_b="
exit /b 0
