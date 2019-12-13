:: BatchGotAdmin
@echo off
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------    
powershell -window hidden -command ""
:loop
if exist closecheckstate.txt exit
call :timeout.service 30
:: Core temperature
for /f "skip=1 tokens=2 delims==" %%A in ('wmic /namespace:\\root\wmi PATH MSAcpi_ThermalZoneTemperature get CurrentTemperature /value') do set /a "HunDegCel=(%%~A*10)-27315"
echo %HunDegCel:~0,-2%.%HunDegCel:~-2% > "%temp%\coretemp.txt"
set /p "coretemp="<"%temp%\coretemp.txt"
:: Installed OS
if exist closecheckstate.txt exit
Set _os_bitness=64
IF %PROCESSOR_ARCHITECTURE% == x86 (
  IF NOT DEFINED PROCESSOR_ARCHITEW6432 Set _os_bitness=32
  )
SET Connected=false
FOR /F "usebackq tokens=1" %%A IN (`PING github.com`) DO (
    REM Check the current line for the indication of a successful connection.
    IF /I "%%A"=="Reply" SET Connected=true
)
if exist closecheckstate.txt exit
REM Check if a connection was found.
IF "%Connected%"=="true" (
    SET Internet=connected to the internet.
) ELSE (
    SET Internet=not connected to the internet.
)
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{72631E54-78A4-11D0-BCF7-00AA00B7B32A}\0000" || goto giveinternet
:: Read the battery status
if exist closecheckstate.txt exit
FOR /F "tokens=*" %%A IN ('WMIC Path Win32_Battery Get EstimatedChargeRemaining /Format:List ^| FIND "="') DO SET %%A
FOR /F "tokens=*" %%A IN ('WMIC Path Win32_Battery Get BatteryStatus /Format:List ^| FIND "="') DO SET %%A
:: Check the battery status, and display a warning message if running on battery power
if exist closecheckstate.txt exit
IF "%BatteryStatus%"=="10" (
otlk "can't get the battery status."
notifu /m "can't get the battery status." /q /i parent /t warn /d 0 /p "claudscape briefing service"
goto giveinternet
)
IF "%BatteryStatus%"=="3" (
otlk "the battery is fully charged and you can unmount the charger."
notifu /m "the battery is fully charged and you can unmount the charger." /q /i parent /t info /d 0 /p "claudscape briefing service"
goto giveinternet
)
IF "%BatteryStatus%"=="6" (
call :Batterystatus.charging
goto giveinternet
)
IF "%BatteryStatus%"=="7" (
call :Batterystatus.charging
goto giveinternet
)
IF "%BatteryStatus%"=="2" (
call :Batterystatus.charging
goto giveinternet
)
IF "%BatteryStatus%"=="8" (
call :Batterystatus.charging
goto giveinternet
)
IF "%BatteryStatus%"=="9" (
call :Batterystatus.charging
goto giveinternet
)
IF "%BatteryStatus%"=="11" (
call :Batterystatus.charging
goto giveinternet
)
if exist closecheckstate.txt exit
IF "%BatteryStatus%"=="4" (
start tlk "Battery level low. You maybe want to mount a charger."
notifu /m "Battery level low. You maybe want to mount a charger." /q /i parent /t info /d 0 /p "claudscape briefing service"
goto giveinternet
)
IF "%BatteryStatus%"=="5" (
start tlk "Battery level critical. Mount a charger!"
notifu /m "Battery level critical. Mount a charger!" /q /i parent /t warn /d 0 /p "claudscape briefing service"
goto giveinternet
)
otlk "The laptop is currently running on its battery. The estimated battery charge remaining is %EstimatedChargeRemaining% percent."
notifu /m "The laptop is currently running on its battery. The estimated battery charge remaining is %EstimatedChargeRemaining%%%." /q /i parent /t info /d 0 /p "claudscape briefing service"
:giveinternet
if exist closecheckstate.txt exit
set currtime=%time:~0,-6%
otlk "The current time is %currtime% the date is %date%, your internet state is %internet% and Operating System is %_os_bitness% bit. Current processor core temperature is %coretemp% Degrees Celsius."
notifu /m "The current time is %currtime% the date is %date%," /q /i parent /t info /d 0 /p "claudscape briefing service"
call :timeout.service 10
notifu /m "your internet state is %internet% and Operating System is %_os_bitness% bit." /q /i parent /t info /d 0 /p "claudscape briefing service"
call :timeout.service 3
notifu /m "Current processor core temperature is %coretemp% Degrees Celsius." /q /i parent /t info /d 0 /p "claudscape briefing service"
if exist closecheckstate.txt exit
call :timeout.service 120
goto loop
:error
tlk "the claudscape briefing service just stopped working..."
exit
:timeout.service
set timetogo=%1
:timeout.loop
timeout /t 1
if exist closecheckstate.txt exit
set /a timetogo-=1
if %timetogo% LSS 1 (exit /b)
goto timeout.loop


:Batterystatus.charging
IF "%EstimatedChargeRemaining%"=="100" (
otlk "the battery is fully charged and you can unmount the charger."
notifu /m "the battery is fully charged and you can unmount the charger." /q /i parent /t info /d 0 /p "claudscape briefing service"
exit /b
)
IF %EstimatedChargeRemaining% GEQ 95 (
otlk "the battery is almost fully charged. It is %EstimatedChargeRemaining% percent right now."
notifu /m "The battery is almost fully charged. It is %EstimatedChargeRemaining%%% right now." /q /i parent /t info /d 0 /p "claudscape briefing service"
exit /b
)
otlk "The system has access to AC so no battery is being discharged. However, the battery is not necessarily charging. But if it is, your battery is charged to %EstimatedChargeRemaining% percent."
notifu /m "The system has access to AC so no battery is being discharged. However, the battery is not necessarily charging."  /q /i parent /t info /d 0 /p "claudscape briefing service"
call :timeout.service 3
notifu /m "But if it is, your battery is charged to %EstimatedChargeRemaining%%%." /q /i parent /t info /d 0 /p "claudscape briefing service"
call :timeout.service 30
exit /b
