FROM ghcr.io/rajbos/actions-marketplace/powershell:7

WORKDIR /app

COPY entrypoint.ps1 ./

ENTRYPOINT pwsh /app/entrypoint.ps1