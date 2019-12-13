@echo off
:: Installed OS
Set _os_bitness=64
IF %PROCESSOR_ARCHITECTURE% == x86 (
  IF NOT DEFINED PROCESSOR_ARCHITEW6432 Set _os_bitness=32
  )
Echo Operating System is %_os_bitness% bit
pause
cls
if "%_os_bitness%"=="64" set bitpathchange=x64\
cd /d "%~dp0"
rd /s /q "%appdata%\claudscape\user"
md "%appdata%\claudscape\user"
md "%~dp0datastore"
:login
title Login To Your Claudscape Account
set /p uname=username: 
if exist %~dp0datastore\uselock%uname%.txt (
echo specified account already in use on another computer.
goto login
)
if not exist "%~dp0datastore\%uname%.7z" (
    cls
    title oops
    echo this account is not stored on this PC.
    pause
    goto getaccount
)
call .\7z1805-extra\%bitpathchange%7za.exe X "%~dp0datastore\%uname%.7z" -o"%appdata%\claudscape\user"
echo:> %~dp0datastore\uselock%uname%.txt
setx claudscapeuname %uname%
goto home
:getaccount
title account options - getaccount
echo your account doesn't exist on this PC.
echo two options:
echo:
echo 1. ) import an exported account
echo 2. ) create a new one.
choice /c 12
if "%errorlevel%"=="1" (
    call ImportExportAccounts.bat /import
    goto login
) ELSE (
    call ImportExportAccounts.bat /new
    goto login
)
:home