# Desktop & Lockscreen Application

Application designed, to allow the creation and setting of backgrounds and lockscreens for Windows 10 and 11 operating systems, via Microsoft Intune. 

## Background
As Micorosoft Intune, does not support defining the Lockscreen & Wallpaper images via policy unless you have enterprise based licensing; you can either:
- Define the images via a Intune Script,
- Win32 App

The drawback to using a script, is:
- they only run once, (remedidiation scripts can rerun, but require enhanced licneses)
- the offer poor reporting vs Intune Apps,
- the offer no verison controlling,
- the images have to be saved in a shared location, often Azure files leading to costs,
- As the script runs once, and often results in a copy to the local drive; simply updating the image isn't enough and the script needs rerun,
- or you could use remote load, but loss of internet connectivty conuld impact this.

The benefits to use a Win32 App, is that it addresses the above chllanges and offers greater control around delivery. 

## Requirements
- Windows 10 +
- 10MB of Disk Space (plus size of your images)
- Microsoft Intune

## Instructions

### Option 1 - Image File Update
Option 1, is the best apporach for instances where the whole organisation is using the same background/lockscreen image and wil remain rather static.

1. Extract the powershell script and assests folder for the background app to the C:\Win32Apps\Wallpaper\
2. Open the Images folder,
3. Replace the current Lockscreen.jpg & Desktop.jpg with your coporate background using the .jpg format as well the same names,
4. Package the application via the Microsoft Win32 Content Prep from https://go.microsoft.com/fwlink/?linkid=2065730
5. Extract the Microsoft Win32 Content Prep tool,
6. Open CMD using Administrator elevation
7. Open the Microsoft Win32 Content Prep tool via CMD,
8. Define the setup folder as "C:\Win32Apps\Wallpaper\",
9. Define the setup file as "CC:\Win32Apps\Wallpaper\install.ps1",
10. Define the output location to "C:\Win32Apps\Wallpaper\",
11. Open, intune.microsoft.com
12. Select Apps | Windows
13. Select add
14. Select Windows App (win32)
15. Select the intune package just created under C:\Win32Apps\Wallpaper\
16. Define the following settings:
-- Name: Company Branding
-- Description: Background & Lockscreen branding deployment application.
-- Publisher: Warren Sherwen
-- App Verison: 1.0 (increase by one, for each new package update) - this is important, so the app can run the uninstall and install commands correctly to apply any new updates.
17. Select next
18. Define the following values:
-- Install Command: %windir%\SysNative\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -file install.ps1 -Mode Install
-- Uninstall command: %windir%\SysNative\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -file uninstall.ps1 -Mode Install

*** It's important to note, for this installation to work powershell needs to run as 64bit, otherwise by default intune will run in 32bit context for 32bit apps and the registry keys will be saved in the wrong place, to achive this the "%windir%\SysNative\WindowsPowerShell\v1.0\powershell.exe" is very important ***

-- Installation time required (mins): 5
-- Allow available uninstall: No
-- Install behavior: System
-- Device restart behavior: Determine behavior based on return codes
20. Select next
21. Define the following values:
-- Operating system architecture: x86,x64
-- Minimum operating system: Windows 10 1607
-- Disk space required (MB): 10MB
22. Select next
23. Define the following values:
-- Rules format use a custom detection script
-- upload the check.ps1 file from the C:\Win32Apps\Wallpaper\ location.
24. Select next
25. Define the scope for delivery to All Devices (or amend to your requirements)
26. Review and finish

Note, where you have unique brands per team or department, I recommend changing the below values to something unique per team:
$WallpaperImage = "Desktop.jpg"
$LockscreenImage = "Lockscreen.jpg"

These will also need amending in the check.ps1 file to work as required; this way if a user changes team or department the branding follows them as required!
