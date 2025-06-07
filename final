@echo off
title Privatnost - Dubinsko Ciscenje
color 0a

:: Provera administratorskih privilegija
>nul 2>&1 net session || (
    echo Pokretanje kao administrator...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo.
echo [0/12] Brisanje USN Journal-a sa diska C: ...
fsutil usn deleteJournal /d C: >nul 2>&1

:: ======== Pamćenje originalnog vremena foldera ========
for %%F in (
  "%APPDATA%\Microsoft\Windows\Recent"
  "%TEMP%"
  "%LOCALAPPDATA%\Microsoft\Windows\Explorer"
  "%SystemDrive%\$Recycle.Bin"
) do (
  for /f "tokens=*" %%A in ('powershell -command "(Get-Item '%%~fF').LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss')"') do set "T_%%~nF=%%A"
)

echo.
echo [1/12] Brisanje clipboard-a...
echo off | clip

echo.
echo [2/12] Brisanje TEMP fajlova i prefetch-a...
mkdir empty_dir >nul 2>&1
robocopy empty_dir "%TEMP%" /MIR >nul
rd empty_dir >nul 2>&1
del /f /s /q "C:\Windows\Prefetch\*" >nul 2>&1

echo.
echo [3/12] Brisanje recent fajlova i jump listova...
del /f /q "%APPDATA%\Microsoft\Windows\Recent\*" >nul 2>&1
del /f /q "%APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations\*" >nul 2>&1
del /f /q "%APPDATA%\Microsoft\Windows\Recent\CustomDestinations\*" >nul 2>&1

echo.
echo [4/12] Brisanje thumbnail keš fajlova...
del /f /s /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1

echo.
echo [5/12] Ciscenje registra (RunMRU, ShellBags, UserAssist itd.)...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSavePidlMRU" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRU" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\Shell\BagMRU" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\Shell\Bags" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist" /f >nul 2>&1

echo.
echo [6/12] Praznjenje Recycle Bin-a...
rd /s /q "%SystemDrive%\$Recycle.Bin" >nul 2>&1

echo.
echo [7/12] Ciscenje Event Viewer logova...
for /F "tokens=*" %%1 in ('wevtutil el') do wevtutil cl "%%1" >nul 2>&1

echo.
echo [8/12] Brisanje DNS keša...
ipconfig /flushdns >nul 2>&1

echo.
echo [9/12] Blokiranje pisanja u %%APPDATA%%...
icacls %APPDATA% /deny Everyone:(W) >nul 2>&1

:: ======== Vraćanje vremenskih oznaka foldera ========
echo.
echo [10/12] Vracanje datuma foldera...
powershell -Command "$f=Get-Item '$env:APPDATA\Microsoft\Windows\Recent'; $f.LastWriteTime=[datetime]'%T_Recent%'" 2>nul
powershell -Command "$f=Get-Item '$env:TEMP'; $f.LastWriteTime=[datetime]'%T_TEMP%'" 2>nul
powershell -Command "$f=Get-Item '$env:LOCALAPPDATA\Microsoft\Windows\Explorer'; $f.LastWriteTime=[datetime]'%T_Explorer%'" 2>nul
powershell -Command "$f=Get-Item '$env:SystemDrive\$Recycle.Bin'; $f.LastWriteTime=[datetime]'%T_$Recycle.Bin%'" 2>nul

echo.
echo [11/12] Zavrsno ciscenje...
timeout /t 2 >nul

:: [12/12] Samounistavanje skripte
(
    echo @echo off
    echo timeout /t 1 >nul
    echo del "%%~f0"
) > "%temp%\delself.bat"
start "" /min "%temp%\delself.bat"
exit
