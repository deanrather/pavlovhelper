@echo off

::Basic Settings (Required)
::------------------------------------------------------------------------
::Where the SteamCMD.exe file is located
set steamcmd_binary=

::The PARENT folder of your "steamapps" folder where Pavlov is installed
set steam_root=

::Where your Unreal Engine binary is located
set ue_binary=

::How long you want to wait before starting Pavlov (may vary by system)
set delay=7

::Staging .pak path
set staging_path=

::UGC number
set ugc=
::------------------------------------------------------------------------

::Secondary Account Settings (Optional)
::------------------------------------------------------------------------
::Username
set username=

::Password
set password=
::------------------------------------------------------------------------

::--------------------------------------------------------------------------------
echo ==============================================================
echo  ____             _              _   _      _                 
echo |  _ \ __ ___   _| | _____   __ | | | | ___| |_ __   ___ _ __ 
echo | |_) / _` \ \ / / |/ _ \ \ / / | |_| |/ _ \ | '_ \ / _ \ '__|
echo |  __/ (_| |\ V /| | (_) \ V /  |  _  |  __/ | |_) |  __/ |   
echo |_|   \__,_| \_/ |_|\___/ \_/   |_| |_|\___|_| .__/ \___|_|   
echo                                              |_|              
echo ==============================================================
echo 1: Quick Rename
echo 2: Stage Map With Launch
echo 3: Download Latest Workshop Map With Launch

CHOICE /C 123 /N /M "Enter Choice"
IF ERRORLEVEL 3 GOTO 3
IF ERRORLEVEL 2 GOTO 2
IF ERRORLEVEL 1 GOTO 1
::--------------------------------------------------------------------------------


::--------------------------------------------------------------------------------
:1
echo Checking for new .pak file...
if exist "%staging_path%\Pavlov-WindowsNoEditor_P.pak" (
    echo New .pak file found!
) else (
    echo No new .pak file found, exiting script! && pause && goto eof
)

echo Checking for old .pak file...
if exist "%staging_path%\pakchunk-workshop.pak" (
    echo Old .pak file found, attempting to delete...
    del /f "%staging_path%\pakchunk-workshop.pak"
) else (
    echo No old .pak file found!
)

echo Renaming new pak file...
rename "%staging_path%\Pavlov-WindowsNoEditor_P.pak" pakchunk-workshop.pak
IF ERRORLEVEL 1 (
    echo Failed to rename pak, exiting script! && pause && goto eof
) else (
    echo File succesfully renamed!
)

pause
goto eof
::--------------------------------------------------------------------------------


::--------------------------------------------------------------------------------
:2
CHOICE /M "Are you SURE you saved ALL?  Forced Unreal shutdown will happen!"
IF ERRORLEVEL 2 echo Exiting script! && pause && goto eof
IF ERRORLEVEL 1 echo Moving on...

echo Checking for new .pak file...
if exist "%staging_path%\Pavlov-WindowsNoEditor_P.pak" (
    echo New .pak file found!
) else (
    echo No new .pak file found, exiting script! && pause && goto eof
)

echo Checking for old .pak file...
if exist "%staging_path%\pakchunk-workshop.pak" (
    echo Old .pak file found, attempting to delete...
    del /f "%staging_path%\pakchunk-workshop.pak"
) else (
    echo No old .pak file found!
)

echo Renaming new pak file...
rename "%staging_path%\Pavlov-WindowsNoEditor_P.pak" pakchunk-workshop.pak
IF ERRORLEVEL 1 (
    echo Failed to rename pak, exiting script! && pause && goto eof
) else (
    echo File succesfully renamed!
)

echo Killing Unreal Engine...
taskkill /F /IM UE4Editor.exe

echo Starting Pavlov in %delay% seconds!
timeout %delay%

echo Starting Pavlov...
start /WAIT steam://rungameid/555160

timeout 1
echo Starting Unreal Engine...
start %ue_binary%

pause
goto eof
::--------------------------------------------------------------------------------


::--------------------------------------------------------------------------------
:3
CHOICE /M "Are you SURE you saved ALL?  Forced Unreal shutdown will happen!"
IF ERRORLEVEL 2 echo Exiting script! && pause && goto eof
IF ERRORLEVEL 1 echo Moving on...

echo Killing Unreal Engine...
taskkill /F /IM UE4Editor.exe

echo Checking for old .pak file...
if exist "%staging_path%\pakchunk-workshop.pak" (
    echo Old .pak file found, attempting to delete...
    del /f "%staging_path%\pakchunk-workshop.pak"
) else (
    echo No old .pak file found!
)

start /WAIT %steamcmd_binary% +login anonymous +force_install_dir %steam_root% +workshop_download_item 555160 %ugc% +quit
IF ERRORLEVEL 1 (
    echo Workshop update failed! && pause && goto eof
) else (
    echo Workshop file successfully downloaded!
)

echo Starting Pavlov in %delay% seconds!
timeout %delay%

echo Starting Pavlov...
start /WAIT steam://rungameid/555160

timeout 1
echo Starting Unreal Engine...
start %ue_binary%

pause
goto eof
::--------------------------------------------------------------------------------
