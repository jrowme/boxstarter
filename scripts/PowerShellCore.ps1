choco install -y dotnetcore-sdk
choco install -y powershell-core
choco install -y colortool
(Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/dracula/iterm/master/Dracula.itermcolors').Content | Out-File -FilePath 'C:\ProgramData\Chocolatey\lib\colortool\content\schemes\Dracula.itermcolors'