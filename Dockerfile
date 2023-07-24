FROM mcr.microsoft.com/azure-powershell:latest

ADD entrypoint.ps1 /entrypoint.ps1

ENTRYPOINT ["pwsh", "/entrypoint.ps1"]