choco install Microsoft-Windows-Subsystem-Linux --source="'windowsfeatures'"

#--- Ubuntu ---
# TODO: Move this to choco install once --root is included in that package
Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1804 -OutFile ~/Ubuntu.appx -UseBasicParsing
Add-AppxPackage -Path ~/Ubuntu.appx
run the distro once and have it install locally with root user, unset password

Ubuntu1804 install --root
Ubuntu1804 run apt update
Ubuntu1804 run apt upgrade -y

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