@echo off
:: ===============================
:: FULL PRIVACY CLEANUP TOOL v1.0
:: ===============================

:: Step 1 – Elevate privileges
if not "%1"=="am_admin" (
    echo Requesting administrator rights...
    powershell -Command "Start-Process '%~f0' -ArgumentList 'am_admin' -Verb RunAs"
    exit /b
)

echo [*] Running full cleanup...

:: Step 2 – Clear clipboard
echo. | clip

:: Step 3 – Clear recent folders, jump lists
del /f /q "%APPDATA%\Microsoft\Windows\Recent\*.*" >nul 2>&1
del /f /q "%APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations\*.*" >nul 2>&1
del /f /q "%APPDATA%\Microsoft\Windows\Recent\CustomDestinations\*.*" >nul 2>&1

:: Step 4 – Temp folders
del /s /q /f "%TEMP%\*.*" >nul 2>&1
del /s /q /f "C:\Users\%USERNAME%\AppData\Local\Temp\*.*" >nul 2>&1

:: Step 5 – Prefetch & logs
takeown /f "C:\Windows\Prefetch" /r /d y >nul 2>&1
icacls "C:\Windows\Prefetch" /grant administrators:F /t >nul 2>&1
del /f /q "C:\Windows\Prefetch\*.*" >nul 2>&1

del /f /q "C:\Windows\Logs\CBS\CBS.log" >nul 2>&1
del /f /q "C:\Windows\Logs\CBS\FilterList.log" >nul 2>&1
echo. > "C:\Windows\Logs\CBS\CBS.log"
echo. > "C:\Windows\Logs\CBS\FilterList.log"

:: Step 6 – Clear thumbnail cache
del /f /s /q "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1

:: Step 7 – Clear Windows search / File Explorer / Run MRU
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\WordWheelQuery" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /f >nul 2>&1

:: Step 8 – ShellBags (folder history)
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU" /f >nul 2>&1
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /f >nul 2>&1

:: Step 9 – MUICache, AppCompat, UserAssist
reg delete "HKCU\Software\Microsoft\Windows\ShellNoRoam\MUICache" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Persisted" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist" /f >nul 2>&1

:: Step 10 – Open/Save Dialog MRU
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSavePidlMRU" /f >nul 2>&1

:: Step 11 – Uninstall keys
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /f >nul 2>&1

:: Step 12 – Clear Event Viewer logs
for %%L in (Application Security Setup System ForwardedEvents) do (
    wevtutil cl %%L >nul 2>&1
)

:: Step 13 – Clear Task Scheduler log
wevtutil cl Microsoft-Windows-TaskScheduler/Operational >nul 2>&1

:: Step 14 – Flush DNS
ipconfig /flushdns >nul

:: Step 15 – MyLastActivity (if applicable)
del /q /f "C:\Path\To\MyLastActivity\Logs\*.*" >nul 2>&1

:: Step 16 – Disable telemetry
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1

:: Step 17 – Block writing to AppData (optional, aggressive)
icacls %APPDATA% /deny Everyone:(W) >nul 2>&1

:: Step 18 – Copy shortcut (e.g. Discord)
set pfad=%cd%
cd "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Discord Inc" >nul 2>&1
copy Discord.lnk %pfad% >nul 2>&1

:: Step 19 – Create WordAutoSave and hide script there
cd "C:\Users\%USERNAME%\Documents"
md WordAutoSave >nul 2>&1
move %0 "C:\Users\%USERNAME%\Documents\WordAutoSave\Homework_05.03.2021.docx" >nul 2>&1

:: Step 20 – Self delete (burn after running)
echo del "%%~f0" > "%TEMP%\delself.bat"
start /min "" cmd /c "%TEMP%\delself.bat"

echo.
echo [*] All done. Press any key to exit.
pause >nul