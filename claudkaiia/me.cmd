chcp
md "%~dp0assets"
cd /d "%~dp0assets"
xcopy %~dp0..\system\scripts\*.* %~dp0assets /y
del /f /q closecheckstate.txt
start checkstate.cmd
:login
powershell -window normal -command ""
set uname=%claudscapeuname%
if "%claudscapeuname%"=="" call "%~dp0..\system\LoginToClaudscapeAccounts.cmd"
:home
powershell -window hidden -command ""
cd /d "%~dp0assets"
otlk "Please type something to me."
title Kaiia Command Box
call :inputbox "Please type something to me:" "Kaiia"
set str=%input%
set "ucom="
if /i not "x%str:who are you=%"=="x%str%" (
otlk.vbs  "i am kaiia, with the internal claudscape name 'claudkaiia'."
otlk.vbs  "I am part of the claudscape project, build to serve good people."
otlk.vbs  "Marnix Bloeiman conceived and started the claudscape project."
otlk.vbs  "The claudscape project is a project that revolves around smart artificial intelligence, and making it."
otlk.vbs  "These artificial intelligences are here to help humanity."
otlk.vbs  "I am one of them."
otlk.vbs  "Does that answer your question?"
echo i am kaiia, with the internal claudscape name 'claudkaiia'.
echo I am part of the claudscape project, build to serve good people.
echo Marnix Bloeiman conceived and started the claudscape project.
echo The claudscape project is a project that revolves around smart artificial intelligence, and making it.
echo These artificial intelligences are here to help humanity.
echo I am one of them.
echo Does that answer your question?
rem added at Sun 08/19/2018 time 12:32:11.08 from MARPC1
set ucom=found
goto go
)
if /i not "x%str:Pause yourself=%"=="x%str%" (
cls
type nul>closecheckstate.txt
pause
set ucom=found
exit /b
)

if /i not "x%str:How are you?=%"=="x%str%" (
otlk I'm fine.
set ucom=found
exit
)
if /i not "x%str:bye kaiia=%"=="x%str%" (
type nul>closecheckstate.txt
otlk See you, %uname%!
set ucom=found
exit
)
if /i not "x%str:encrypt=%"=="x%str%" (
type nul>closecheckstate.txt
otlk bye %uname%...
Call "%~dp0..\system\LogoffAndSaveChangesToClaudscapeAccounts.cmd"
    set ucom=found
goto login
)
:go
powershell -window normal -command ""
call "%appdata%\claudscape\user\kaiia.cmd"
if /i "%ucom%"=="" (

    tlk "could you help me with that?"
rem    echo is this 1^) a command or 2^) a chattything
rem    choice /c 12
rem    if "%errorlevel%"=="1" (
rem            call :addcommand
rem        ) ELSE (
rem            call :addchattything
rem        )
(
    echo if /i not "x%%str:%str%=%%"=="x%%str%%" ^(
    echo cls
)>> "%appdata%\claudscape\user\kaiia.cmd"
    echo type your batch commands. press [Ctrl]+[Z] folowed by [ENTER] on a blank line to end user input. 
    type con >> "%appdata%\claudscape\user\kaiia.cmd"
    (
        echo rem added at %date% time %time% from %computername%
        echo set ucom=found
        echo exit /b
        echo ^)
    ) >> "%appdata%\claudscape\user\kaiia.cmd"
    goto go
)
powershell -window hidden -command ""
goto home
:inputbox
set input=
set heading=%~2
set message=%~1
echo wscript.echo inputbox(WScript.Arguments(0),WScript.Arguments(1)) >"%temp%\input.vbs"
for /f "tokens=* delims=" %%a in ('cscript //nologo "%temp%\input.vbs" "%message%" "%heading%"') do set input=%%a
if "%input%"=="" goto inputbox
exit /b
:addchattything
(
    echo if /i not "x%%str:%str%%%random%%=%%"=="x%%str%%" ^(
    echo cls
)>> "%appdata%\claudscape\user\kaiia.cmd"
exit /b
:addcommand
(
    echo if "%str%"=="%%str%%" ^(
    echo cls
)>> "%appdata%\claudscape\user\kaiia.cmd"
exit /b
goto skipthesnippets
echo if /i not "x%%str:%str%=%%"=="x%%str%%" ^(


:skipthesnippets