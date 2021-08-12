FROM mcr.microsoft.com/powershell:ubuntu-20.04

LABEL author="Scott MacGregor"
LABEL maintainer="shadowbq@gmail.com"
LABEL version="0.1"

RUN apt-get update && apt-get upgrade -y
RUN pwsh -Command "Install-Module PSFalcon -Scope CurrentUser -Force"

WORKDIR /data
#COPY ./data /data

RUN chsh -s /usr/bin/pwsh

ENTRYPOINT ["pwsh"]
CMD [ "-Help" ]