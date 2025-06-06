@echo off
:: Check for administrative privileges
:: If not running as administrator, re-run the script as administrator
if not "%1"=="am_admin" (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~f0' -ArgumentList 'am_admin' -Verb RunAs"
    exit /b
)

echo Starting cleanup process...

:: Delete all UserAssist registry keys
echo Deleting UserAssist registry keys...
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist" /f >nul 2>&1

:: Clear specified Event Viewer logs
echo Clearing specified Event Viewer logs...
for %%G in (
    "Application"
    "Setup"
    "System"
    "ForwardedEvents"
) do (
    echo Clearing log %%G...
    wevtutil cl %%G >nul 2>&1
)

:: Delete all files from Prefetch folder
echo Deleting Prefetch files...
takeown /f "C:\Windows\Prefetch" /r /d y >nul 2>&1
icacls "C:\Windows\Prefetch" /grant administrators:F /t >nul 2>&1
del /Q /F "C:\Windows\Prefetch\*.*" >nul 2>&1

:: Delete everything from \AppData\Roaming\Microsoft\Windows\Recent\
echo Deleting Recent files...
del /Q /F "%APPDATA%\Microsoft\Windows\Recent\*.*" >nul 2>&1

:: Delete every task run log in MyLastActivity (assuming the path is known)
echo Deleting MyLastActivity logs...
del /Q /F "C:\Path\To\MyLastActivity\Logs\*.*" >nul 2>&1

:: Delete every registry key from HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU
echo Deleting BagMRU registry keys...
reg delete "HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU" /f >nul 2>&1

:: Delete every registry key from HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Uninstall
echo Deleting Uninstall registry keys...
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Uninstall" /f >nul 2>&1

:: Delete software installation keys
echo Deleting software installation keys from registry...
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /f >nul 2>&1
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Uninstall" /f >nul 2>&1

:: Delete Task Scheduler run activity logs
echo Clearing Task Scheduler activity logs...
wevtutil cl Microsoft-Windows-TaskScheduler/Operational >nul 2>&1

:: Delete all registry keys from HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSavePidlMRU
echo Deleting OpenSavePidlMRU registry keys...
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSavePidlMRU" /f >nul 2>&1

:: Delete all registry keys from HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs
echo Deleting RecentDocs registry keys...
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /f >nul 2>&1

echo Cleanup complete!
pause
