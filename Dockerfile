FROM mcr.microsoft.com/powershell:ubuntu-18.04

WORKDIR /app

RUN pwsh -Command "Install-Module -Name powershell-yaml -Repository PSGallery"

COPY . .

ENTRYPOINT ["pwsh", "/app/entrypoint.ps1"]