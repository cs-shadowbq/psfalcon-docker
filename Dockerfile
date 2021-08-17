FROM mcr.microsoft.com/powershell:ubuntu-20.04

LABEL org.opencontainers.image.authors ="Scott MacGregor <shadowbq@gmail.com>"
LABEL org.opencontainers.image.title = "psfalcon-docker"
LABEL org.opencontainers.image.description = "Crowdstrike PSFalcon for Powershell"
LABEL org.opencontainers.image.source = "https://github.com/cs-shadowbq/psfalcon-docker"
LABEL org.opencontainers.image.url = "https://hub.docker.com/r/shadowbq/psfalcon" `
LABEL org.opencontainers.image.base.name = "powershell:ubuntu-20.04"
LABEL org.opencontainers.image.version = "0.0.6"
LABEL com.github.cs-shadowbq.psfalcon = "2.0.8"

RUN apt-get update && apt-get upgrade -y
SHELL [ "pwsh", "-command" ]
RUN Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
RUN Install-Module Microsoft.PowerShell.SecretManagement, Microsoft.PowerShell.SecretStore
RUN Register-SecretVault -Name CrowdStrikeSecretStore -ModuleName Microsoft.PowerShell.SecretStore
RUN Install-Module PSFalcon -Scope CurrentUser -RequiredVersion 2.0.8 -Force

WORKDIR /data

RUN chsh -s /usr/bin/pwsh

ENTRYPOINT ["pwsh"]
CMD [ "-Help" ]
