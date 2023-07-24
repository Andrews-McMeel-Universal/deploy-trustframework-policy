FROM ubuntu:20.04

# install powershell for Ubuntu 20.04
RUN apt-get update \ 
    && apt-get install -y wget apt-transport-https software-properties-common \
    && wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb \
    && apt-get update \
    && dpkg -i packages-microsoft-prod.deb \
    && add-apt-repository universe \
    && apt-get update \
    && apt-get install libssl-dev -y \
    && apt-get install gss-ntlmssp -y \
    && apt-get install powershell -y

RUN pwsh -Command Install-Module -Name powershell-yaml -Force -Repository PSGallery

ADD entrypoint.ps1 /entrypoint.ps1

ENTRYPOINT ["pwsh", "/entrypoint.ps1"]