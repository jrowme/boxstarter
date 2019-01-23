# Description: Boxstarter script for henih2 workstation
# Author: henih2

Disable-UAC
# Set-MpPreference -DisableRealtimeMonitoring $true

#--- Browsers ---
choco install -y googlechrome firefox
RefreshEnv

# --- Chef Tools ---
choco install -y chefdk
RefreshEnv

# --- Dev Tools ---
choco install -y vscode
choco install -y git --package-parameters="'/GitAndUnixToolsOnPath /WindowsTerminal'"
RefreshEnv
choco install -y python 7zip.install sysinternals f.lux bleachbit dropbox windirstat

# --- Communication Tools ---
choco install -y hipchat slack microsoft-teams signal gitter
RefreshEnv

# --- Docker Tools ---
Enable-WindowsOptionalFeature -Online -FeatureName containers -All
choco install -y docker-for-windows
RefreshEnv

#--- Configuring Windows properties ---
#--- Windows Features ---
# Show hidden files, Show protected OS files, Show file extensions
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions

#--- File Explorer Settings ---
# will expand explorer to the actual folder you're in
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneExpandToCurrentFolder -Value 1
# adds things back in your left pane like recycle bin
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneShowAllFolders -Value 1
# opens PC to This PC, not quick access
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Value 1
# taskbar where window is open for multi-monitor
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name MMTaskbarMode -Value 2
# Hide People from taskbar
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People -Name PeopleBand -PropertyType DWORD -Value 0
# Hide Cortana from taskbar
New-Item -Path HKLM:\Software\Policies\Microsoft\Windows -Name 'Windows Search' -ItemType Directory -Force
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name AllowCortana -PropertyType DWORD -Value 0
RefreshEnv

# --- HashiCorp Tools ---
choco install -y packer vagrant
RefreshEnv

# --- HyperV ---
choco install Microsoft-Hyper-V-All --source="'WindowsFeatures'"

# --- Media Tools ---
choco install -y vlc spotify
RefreshEnv

# --- PowerShell Tools ---
choco install -y dotnetcore-sdk
RefreshEnv
choco install -y powershell-core
RefreshEnv
choco install -y colortool
(Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/dracula/iterm/master/Dracula.itermcolors').Content | Out-File -FilePath 'C:\ProgramData\Chocolatey\lib\colortool\content\schemes\Dracula.itermcolors' -Encoding unicode
RefreshEnv
ColorTool.exe Dracula.itermcolors

# --- PowerShell Modules ---
Install-Module psake -Force
Install-Module pester -Force -SkipPublisherCheck
Install-Module PSLogging -Force
Install-Module PackageManagement -Force
Install-Module PowerShellGet -Force
Install-Module PSWindowsUpdate -Force
Install-Module PendingReboot -Force
Install-Module PSScriptAnalyzer -Force
Install-Module Posh-Docker -Force
Install-Module PowerShellCookbook -Force

# --- Puppet Tools ---
choco install -y pdk puppet-bolt
RefreshEnv

# --- Remove Default Apps ---
#--- Uninstall unecessary applications that come with Windows out of the box ---
Write-Host "Uninstall some applications that come with Windows out of the box" -ForegroundColor "Yellow"

#Referenced to build script
# https://docs.microsoft.com/en-us/windows/application-management/remove-provisioned-apps-during-update
# https://github.com/jayharris/dotfiles-windows/blob/master/windows.ps1#L157
# https://gist.github.com/jessfraz/7c319b046daa101a4aaef937a20ff41f
# https://gist.github.com/alirobe/7f3b34ad89a159e6daa1
# https://github.com/W4RH4WK/Debloat-Windows-10/blob/master/scripts/remove-default-apps.ps1

function removeApp {
  Param ([string]$appName)
  Write-Output "Trying to remove $appName"
  Get-AppxPackage $appName -AllUsers | Remove-AppxPackage
  Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like $appName | Remove-AppxProvisionedPackage -Online
}

$applicationList = @(
  "Microsoft.BingFinance"
  "Microsoft.3DBuilder"
  "Microsoft.BingFinance"
  "Microsoft.BingNews"
  "Microsoft.BingSports"
  "Microsoft.BingWeather"
  "Microsoft.CommsPhone"
  "Microsoft.Getstarted"
  "Microsoft.WindowsMaps"
  "*MarchofEmpires*"
  "Microsoft.GetHelp"
  "Microsoft.Messaging"
  "*Minecraft*"
  "Microsoft.MicrosoftOfficeHub"
  "Microsoft.OneConnect"
  "Microsoft.WindowsPhone"
  "Microsoft.WindowsSoundRecorder"
  "*Solitaire*"
  "Microsoft.MicrosoftStickyNotes"
  "Microsoft.Office.Sway"
  "Microsoft.XboxApp"
  "Microsoft.XboxIdentityProvider"
  "Microsoft.ZuneMusic"
  "Microsoft.ZuneVideo"
  "Microsoft.NetworkSpeedTest"
  "Microsoft.FreshPaint"
  "Microsoft.Print3D"
  "*Autodesk*"
  "*BubbleWitch*"
  "king.com*"
  "G5*"
  "*Dell*"
  "*Facebook*"
  "*Keeper*"
  "*Netflix*"
  "*Twitter*"
  "*Plex*"
  "*.Duolingo-LearnLanguagesforFree"
  "*.EclipseManager"
  "ActiproSoftwareLLC.562882FEEB491" # Code Writer
  "*.AdobePhotoshopExpress"
  "Microsoft.WindowsMaps"
);

foreach ($app in $applicationList) {
  removeApp $app
}

# --- RSAT Tools ---
if ((Get-ComputerInfo | select -expandproperty OsVersion) -gt '10.0.17134') {
  Write-Host "Installing RSAT for Windows 1809"
  Get-WindowsCapability -Online -Name rsat* | Add-WindowsCapability -Online
  RefreshEnv
}
else {
  Write-Host "Installing RSAT for Windows 1803 or lower"
  choco install rsat -params '"/Server:2016"'
  RefreshEnv
}

# --- Windows Subsystem Linux ---
choco install Microsoft-Windows-Subsystem-Linux --source="'windowsfeatures'"
RefreshEnv

#--- Ubuntu ---
# TODO: Move this to choco install once --root is included in that package
# Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1804 -OutFile ~/Ubuntu.appx -UseBasicParsing
# Add-AppxPackage -Path ~/Ubuntu.appx
# run the distro once and have it install locally with root user, unset password

# RefreshEnv
# Ubuntu1804 install --root
# Ubuntu1804 run apt update
# Ubuntu1804 run apt upgrade -y

<#
NOTE: Other distros can be scripted the same way for example:

#--- SLES ---
# Install SLES Store app
Invoke-WebRequest -Uri https://aka.ms/wsl-sles-12 -OutFile ~/SLES.appx -UseBasicParsing
Add-AppxPackage -Path ~/SLES.appx
# Launch SLES
sles-12.exe

# --- openSUSE ---
Invoke-WebRequest -Uri https://aka.ms/wsl-opensuse-42 -OutFile ~/openSUSE.appx -UseBasicParsing
Add-AppxPackage -Path ~/openSUSE.appx
# Launch openSUSE
opensuse-42.exe
#>

# --- Kali Linux ---
# Invoke-WebRequest -Uri https://www.microsoft.com/store/apps/9PKR34TNCV07 -OutFile ~/Kali-Linux.appx -UseBasicParsing
# Add-AppxPackage -Path ~/Kali-Linux.appx
# run the distro once and have it install locally with root user, unset password
# 
# kali install --root
# kali run apt update
# kali run apt upgrade -y

#--- ReEnable Critical Items ---
# Set-MpPreference -DisableRealtimeMonitoring $false
Enable-UAC
# Enable-MicrosoftUpdate
# Install-WindowsUpdate -acceptEula