@echo off
cd /d %~dp0
title import and export manager for claudscape accounts - welcome
if "%1"=="/import" goto import
if "%1"=="/export" goto export
if "%1"=="/new" goto newac
:menu
echo import and export manager for claudscape accounts - welcome to the menu
set /p uname=username: 
rem echo two options:
rem echo:
rem echo 1. ) import an exported account.
rem echo 2. ) export an imported account.
rem choice /c 12
rem if "%errorlevel%"=="1" (
if not exist "%~dp0datastore\%uname%.7z" (
    goto import
) ELSE (
    goto export
)
exit /b
:import
set /p uloc=path to exported file's folder:
md "%~dp0datastore" 
move "%uloc%\%uname%.7z" "%~dp0datastore\%uname%.7z"
pause
exit /b
:export
set /p uloc=folder to save the exported file to:  
md "%uloc%"
move "%~dp0datastore\%uname%.7z" "%uloc%\%uname%.7z"
pause
exit /b
:newac
cls
type NUL>claudscapeuseraccountadditionalinfo.txt
set /p upass=your new password: 
call .\7z1805-extra\%bitpathchange%7za.exe U "%~dp0datastore\%uname%.7z" claudscapeuseraccountadditionalinfo.txt -p"%upass%" -mhe
del /f /q claudscapeuseraccountadditionalinfo.txt
exit /b