@echo off
::------------------------------------------------------------------------
::Created by: Marshall
::Version: 0.2
::Last updated: 4/14/2019
::Steamcmd URL: https://developer.valvesoftware.com/wiki/SteamCMD
::------------------------------------------------------------------------

::Basic Settings (Required)
::------------------------------------------------------------------------
::Where the SteamCMD.exe file is located
set steamcmd_binary=C:\Users\marsh\Desktop\SteamCMD\steamcmd.exe


::The PARENT folder of your "steamapps" folder where Pavlov is installed
set steam_root=E:\Steam

::Where your Unreal Engine binary is located
set ue_binary=E:\UE_4.21\Engine\Binaries\Win64\UE4Editor.exe

::How long you want to wait before starting Pavlov (may vary by system)
set delay=7

::Staging .pak path
set staging_path=E:\Steam\steamapps\common\PavlovVR\Pavlov\Content\Paks

::UGC number
set ugc=1709210547
::------------------------------------------------------------------------

::Secondary Account Settings (Optional - Must own Pavlov)
::------------------------------------------------------------------------
::Username
set username=blah

::Password
set password=blah
::------------------------------------------------------------------------

::--------------------------------------------------------------------------------
echo =================
echo //Pavlov Helper\\                                                                                         
echo =================
echo 1: Quick Rename (Staged Map)
echo 2: Stage Map With Launch
echo 3: Download Latest Workshop Map With Launch (Public)
echo 4: Download Latest Workshop Map With Launch (Private - Requires Second Account)
echo 9: Download SteamCMD Zip File

CHOICE /C 12349 /N /M "Enter Choice"
if errorlevel 5 goto 9
if errorlevel 4 goto 4
if errorlevel 3 goto 3
if errorlevel 2 goto 2
if errorlevel 1 goto 1
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
if errorlevel 1 (
    echo Failed to rename pak, exiting script! && pause && goto eof
) else (
    echo File succesfully renamed!
)

pause
goto eof
::--------------------------------------------------------------------------------


::--------------------------------------------------------------------------------
:2
choice /M "Are you SURE you saved ALL?  Forced Unreal shutdown will happen!"
if errorlevel 2 echo Exiting script! && pause && goto eof
if errorlevel 1 echo Moving on...

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
if errorlevel 1 (
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
choice /M "Are you SURE you saved ALL?  Forced Unreal shutdown will happen!"
if errorlevel 2 echo Exiting script! && pause && goto eof
if errorlevel 1 echo Moving on...

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
if errorlevel 1 (
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


::--------------------------------------------------------------------------------
:4
if %username%=="" echo Username not set! && pause && goto eof
if %password%=="" echo Password not set! && pause && goto eof

CHOICE /M "Are you SURE you saved ALL?  Forced Unreal shutdown will happen!"
if errorlevel 2 echo Exiting script! && pause && goto eof
if errorlevel 1 echo Moving on...

echo Killing Unreal Engine...
taskkill /F /IM UE4Editor.exe

echo Checking for old .pak file...
if exist "%staging_path%\pakchunk-workshop.pak" (
    echo Old .pak file found, attempting to delete...
    del /f "%staging_path%\pakchunk-workshop.pak"
) else (
    echo No old .pak file found!
)

start /WAIT %steamcmd_binary% +login %username% %password% +force_install_dir %steam_root% +workshop_download_item 555160 %ugc% +quit
if errorlevel 1 (
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

::--------------------------------------------------------------------------------
:9
echo Attempting to download steamcmd.zip to this location...
bitsadmin /transfer "steamcmd" https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip %~dp0steamcmd.zip
::--------------------------------------------------------------------------------
