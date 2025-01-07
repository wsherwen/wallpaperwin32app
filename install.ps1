Param(
	[Parameter(Mandatory=$true)]
	[ValidateSet("Install", "Uninstall")]
	[String[]]
	$Mode
	)
	# Author: Warren Sherwen
	# Verison: 1.0

	# Defines the log file location.
	$Logfile = "$env:systemdrive\Temp\Logs\companybranding.log"

	# LogWrite Function.
	Function LogWrite{
	   Param ([string]$logstring)
	   Add-content $Logfile -value $logstring
	   write-output $logstring
	}

	function Get-TimeStamp {
		return "[{0:dd/MM/yy} {0:HH:mm:ss}]" -f (Get-Date)
	}

	if (!(Test-Path "$env:systemdrive\Temp\Logs\"))
	{
	   mkdir $env:systemdrive\Temp\Logs
	   LogWrite "$(Get-TimeStamp): Company Branding script has started."
	   LogWrite "$(Get-TimeStamp): Log directory created."
	}
	else
	{
		LogWrite "$(Get-TimeStamp): Company Branding script has started."
		LogWrite "$(Get-TimeStamp): Log directory exists."
	}

$DesktopLocation = "$env:systemdrive\Background\Desktop.jpg"
$LockscreenLocation = "$env:systemdrive\Background\Lockscreen.jpg"

$WallpaperImage = "Desktop.jpg"
$LockscreenImage = "Lockscreen.jpg"

$RegistryKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"
$BackgroundPath = "DesktopImagePath"
$BackgroundStatus = "DesktopImageStatus"
$DesktopUrl = "DesktopImageUrl"
$LockScreenPath = "LockScreenImagePath"
$LockScreenStatus = "LockScreenImageStatus"
$LockScreenUrl = "LockScreenImageUrl"
$StatusValue = "1"

If ($Mode -eq "Install") {
    if (!(Test-Path "$env:systemdrive\Background")) {
	   mkdir $env:systemdrive\Background -Force
	}
	else{

	}

    New-Item -Path $RegistryKeyPath -Force -ErrorAction SilentlyContinue

    if (!$LockscreenImage -and !$WallpaperImage){
        LogWrite "$(Get-TimeStamp): Niether the lockscreen or background have values set."
    }
    else{

        if ($LockscreenImage){
            LogWrite "$(Get-TimeStamp): Copying lockscreen ""$($LockscreenImage)"" to ""$($LockscreenLocation)"""
            Copy-Item ".\Images\$LockscreenImage" $LockscreenLocation -Force
            LogWrite "$(Get-TimeStamp): Creating regkeys for lockscreen"
            New-ItemProperty -Path $RegistryKeyPath -Name $LockScreenStatus -Value $StatusValue -PropertyType DWORD -Force
            New-ItemProperty -Path $RegistryKeyPath -Name $LockScreenPath -Value $LockscreenLocation -PropertyType STRING -Force
            New-ItemProperty -Path $RegistryKeyPath -Name $LockScreenUrl -Value $LockscreenLocation -PropertyType STRING -Force
        }
        if ($WallpaperImage){
            LogWrite "$(Get-TimeStamp): Copying wallpaper ""$($WallpaperImage)"" to ""$($DesktopLocation)"""
            Copy-Item ".\Images\$WallpaperImage" $DesktopLocation -Force
            LogWrite "$(Get-TimeStamp): Creating regkeys for wallpaper"
            New-ItemProperty -Path $RegistryKeyPath -Name $BackgroundStatus -Value $StatusValue -PropertyType DWORD -Force
            New-ItemProperty -Path $RegistryKeyPath -Name $BackgroundPath -Value $DesktopLocation -PropertyType STRING -Force
            New-ItemProperty -Path $RegistryKeyPath -Name $DesktopUrl -Value $DesktopLocation -PropertyType STRING -Force
        }  
    }
    LogWrite "$(Get-TimeStamp): Script has been completed."
    exit
}

If ($Mode -eq "Uninstall") {
    if (!$LockscreenImage -and !$WallpaperImage){
    LogWrite "$(Get-TimeStamp): Niether the lockscreen or background have values set."
}
else{
        if ($LockscreenImage){
            LogWrite "$(Get-TimeStamp): Removing the registry keys and file for the lockscreen"
            Remove-ItemProperty -Path $RegistryKeyPath -Name $LockScreenStatus -Force
            Remove-ItemProperty -Path $RegistryKeyPath -Name $LockScreenPath -Force
            Remove-ItemProperty -Path $RegistryKeyPath -Name $LockScreenUrl -Force
            Remove-Item $LockscreenLocation -Force
        }
        if ($WallpaperImage){
            LogWrite "$(Get-TimeStamp): Removing the registry keys and file for the background"
            Remove-ItemProperty -Path $RegistryKeyPath -Name $BackgroundStatus -Force
            Remove-ItemProperty -Path $RegistryKeyPath -Name $BackgroundPath -Force
            Remove-ItemProperty -Path $RegistryKeyPath -Name $DesktopUrl -Force
            Remove-Item $DesktopLocation -Force
        }  
    }
    LogWrite "$(Get-TimeStamp): Script has been completed."
    exit
}