@echo off
cd /d %~dp0
:login
title Logoff And Save Changes To Your Claudscape Account.
set /p uname=username: 
:: Installed OS
Set _os_bitness=64
IF %PROCESSOR_ARCHITECTURE% == x86 (
  IF NOT DEFINED PROCESSOR_ARCHITEW6432 Set _os_bitness=32
  )
Echo Operating System is %_os_bitness% bit
if "%_os_bitness%"=="64" set bitpathchange=x64\
call .\7z1805-extra\%bitpathchange%7za.exe a "%~dp0datastore\%uname%.7z" "%appdata%\claudscape\user\*" -p -mhe -sdel
del %~dp0datastore\uselock%uname%.txt
echo encrypted account.
setx claudscapeuname ""
pause
exit /b