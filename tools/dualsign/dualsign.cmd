@echo off

rem Initialization
set BASE_DIR=%~dp0
set BASE_DIR=%BASE_DIR:~0,-1%
set TARGET_FILE=%1

:init
rem Global boolean variable used in various locations
set FUNC_RESULT=0

rem Global boolean variable indicating if SignTool was performed successfully
set SIGN_SUCCESS=0

rem Read Configuration
set CONFIG_FILE=%BASE_DIR%\dualsign.ini
if not exist "%CONFIG_FILE%" goto err_config
for /f "tokens=*" %%i in (%CONFIG_FILE%) do (
  set %%i 2> nul
  rem Sanitize configuration entry
  for /f "tokens=1 delims==" %%j in ("%%i") do (
    call :trim %%j
  )
)

:check_signtool
call :checkfile FUNC_RESULT %SIGNTOOL%
if "+%FUNC_RESULT%"=="+0" goto err_binary_signtool

:check_cert
call :checkfile FUNC_RESULT %CERTIFICATE_FILE%
if "+%FUNC_RESULT%"=="+0" goto err_certificate

:check_ts_url
if "%TIMESTAMP_SERVER_URL%$"=="$" goto err_timestamp_server

:check_input
if "%TARGET_FILE%$"=="$" goto err_inputfile
if not exist %TARGET_FILE% goto err_inputfile

:start
pushd .

:exec
%SIGNTOOL% sign /f %CERTIFICATE_FILE% /fd sha1 /tr %TIMESTAMP_SERVER_URL% /td sha256 /p %CERTIFICATE_PASSWORD% /v %TARGET_FILE%
%SIGNTOOL% sign /f %CERTIFICATE_FILE% /fd sha256 /tr %TIMESTAMP_SERVER_URL% /td sha256 /p %CERTIFICATE_PASSWORD% /v /as %TARGET_FILE%

:finish
call %SIGNTOOL% verify /pa %TARGET_FILE% && ( set SIGN_SUCCESS=1 ) || ( goto err_sign )
goto end

:end
popd
if "%SIGN_SUCCESS%"=="0" exit /b 1
goto :EOF

rem ## Errors ##################################################################

:err_config
echo The configuration file was not found.
echo File: "%CONFIG_FILE%"
goto end

:err_inputfile
echo The input file was not found.
if not "%TARGET_FILE%$"=="$" echo File: "%TARGET_FILE%"
goto end

:err_certificate
echo The certificate file was not found.
if not "%CERTIFICATE_FILE%$"=="$" echo File: "%CERTIFICATE_FILE%"
goto end

:err_binary_signtool
echo Sign Tool was not found.
echo File: "%SIGNTOOL%"
goto end

:err_timestamp_server
echo Timestamp Server URL is not defined.
goto end

:err_sign
echo Some errors were detected when signing, please check your configuration file.
goto end

rem ## Utilities ###############################################################

:trim
rem Thanks to: https://stackoverflow.com/a/19686956/3726096
setlocal EnableDelayedExpansion
call :trimsub %%%1%%
endlocal & set %1=%tempvar%
goto :EOF
:trimsub
set tempvar=%*
goto :EOF

:check_command
rem Thanks Joey: https://superuser.com/a/175831
rem Warning: _exec should be the name of the executable to check WITH its extension (e.g., ".exe")
setlocal EnableDelayedExpansion
set _exec=%1
set _cmdfound=0
for %%x in (%_exec%) do if not [%%~$PATH:x]==[] set _cmdfound=1
if "%_cmdfound%"=="1" goto check_command_exit
rem Try with the ".exe" extension
set _exec=%_exec%.exe
for %%x in (%_exec%) do if not [%%~$PATH:x]==[] set _cmdfound=1
:check_command_exit
endlocal & set "%~2=%_cmdfound%"
goto :EOF

:checkfile
setlocal EnableDelayedExpansion
set _filepath=%2
set _fileexist=0
if [%_filepath%]==[] goto checkfile_exit
if exist %_filepath% set _fileexist=1
if "$%_fileexist%"=="$0" (
  call :check_command %_filepath% _fileexist
)
:checkfile_exit
endlocal & set "%~1=%_fileexist%"
goto :EOF
