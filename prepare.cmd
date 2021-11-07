rem @echo off
set APP_TITLE=Source Packages Preparer for DreamSDK Setup
title %APP_TITLE%
cls

rem Initialization
set BASE_DIR=%~dp0
set BASE_DIR=%BASE_DIR:~0,-1%

set LOG_FILE=%BASE_DIR%\prepare.log
if exist %LOG_FILE% del %LOG_FILE%

call :log %APP_TITLE%
call :log

rem Read Configuration
rem set CONFIG_FILE=%BASE_DIR%\release.ini
rem for /F "tokens=*" %%i in (%CONFIG_FILE%) do (
rem 	set %%i 2> nul
rem )

rem Sanitize configuration entries
rem call :trim PATCH
rem call :trim PYTHON
rem call :trim INPUT_DIR
rem call :trim OUTPUT_DIR

rem Utilities
set SEVENZIP="C:\Program Files\7-Zip\7z.exe"

set INPUT_DIR=%BASE_DIR%\..\setup-packages
set OUTPUT_DIR=%BASE_DIR%\.sources

:start
pushd
goto extract

:extract
echo Extracting all setup packages...

echo Extracting base components...

rem Extracting MinGW foundation base package
call :unpack mingw-base 20200829

rem Extracting Toolchains...
call :unpack arm-eabi arm-eabi-gcc-8.4.0-binutils-2.34 toolchain-experimental
call :unpack sh-elf sh-elf-gcc-9.3.0-binutils-2.34-newlib-3.3.0 toolchain-experimental
call :unpack arm-eabi arm-eabi-gcc-4.7.4-binutils-2.34 toolchain-stable
call :unpack sh-elf sh-elf-gcc-4.7.4-binutils-2.34-newlib-2.0.0 toolchain-stable

rem Extracting GNU Debugger (GDB)...
call :unpack sh-elf-gdb 10.2 no-python
call :unpack sh-elf-gdb 10.2 python-2.7
call :unpack sh-elf-gdb 10.2 python-3.3
call :unpack sh-elf-gdb 10.2 python-3.4
call :unpack sh-elf-gdb 10.2 python-3.5
call :unpack sh-elf-gdb 10.2 python-3.6
call :unpack sh-elf-gdb 10.2 python-3.7
call :unpack sh-elf-gdb 10.2 python-3.8
call :unpack sh-elf-gdb 10.2 python-3.9
call :unpack sh-elf-gdb 10.2 python-3.10
call :unpack sh-elf-gdb 10.2 python-3.11

rem Extracting Addons Commands
call :unpack elevate 1.3 addons-cmd
call :unpack pvr2png 1.01 addons-cmd
call :unpack txfutils 20011020 addons-cmd
call :unpack txfutils 20011020 addons-cmd txflib
call :unpack vmutool 1.0 addons-cmd

rem Extracting Addons GUI
call :unpack bdreams 1.0.6c addons-gui
call :unpack buildsbi 3.2 addons-gui
call :unpack checker 2.0.3a addons-gui
call :unpack ipwriter 0.1.6a addons-gui
call :unpack mrwriter 0.3 addons-gui
call :unpack sbinducr 5.0 addons-gui
call :unpack vmutool 1.0 addons-gui

goto end

:end
popd
pause
goto :EOF

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

:log
set tmplog=%*
if "%tmplog%"=="" goto logempty
echo %tmplog%
echo %tmplog%>> %LOG_FILE% 2>&1
goto :EOF
:logempty
echo.
echo.>> %LOG_FILE% 2>&1
goto :EOF

:unpack
set _base=%1
set _ver=%2
if not "_%3"=="_" set _base=%3\%_base%
set _input=%INPUT_DIR%\%_base%\%2\%1-bin.7z
if not exist %_input% set _input=%INPUT_DIR%\%_base%\%2\%3-%1-bin.7z
set _output=%OUTPUT_DIR%\%_base%
if not exist %_input% (
	set _input=%INPUT_DIR%\%1\%2\%1-%3-bin.7z
	set _output=%OUTPUT_DIR%\%1\%1-%3
	set _ver=%2-%3
)
if not "_%4"=="_" (
	echo ****HERE
	set _input=%INPUT_DIR%\%_base%\%2\%1-%4-bin.7z
	set _output=%OUTPUT_DIR%\%3\%1-%4
	set _ver=%2-%3
)
if exist %_input% (
	echo   Unpacking %1 ^(%_ver%^) ...
	%SEVENZIP% x "%_input%" -o"%_output%" -y >> %LOG_FILE% 2>&1
)
goto :EOF
