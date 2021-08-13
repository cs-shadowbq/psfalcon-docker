FROM mcr.microsoft.com/powershell:ubuntu-20.04

LABEL author="Scott MacGregor"
LABEL maintainer="shadowbq@gmail.com"
LABEL version="0.0.5"
LABEL psfalcon="2.0.8"

RUN apt-get update && apt-get upgrade -y
RUN pwsh -Command "Install-Module PSFalcon -Scope CurrentUser -RequiredVersion 2.0.8 -Force"

WORKDIR /data

RUN chsh -s /usr/bin/pwsh

ENTRYPOINT ["pwsh"]
CMD [ "-Help" ]
