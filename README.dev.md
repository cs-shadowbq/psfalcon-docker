# README - DEVELOPER

`PSFalcon-Docker` is an open source project, not a formal CrowdStrike product, to assist users and developers to implement CrowdStrike's APIs within their application, or tools. As such it carries no formal support, express or implied.

This repo is designed for running the PowerShell PSFalcon Module in a Container with a Linux base.

* Ubuntu - 20.04 - This is the *Default* Dockerfile and is used with `latest` tags. 
* Alpine - Lightweight workload (3.x) (~250mb)
* UBI8 - RedHat Official Universal Container Build (8.x)

Additional, and bump versions of the `mcr.microsoft.com` versions are availble by pulling `curl -L https://mcr.microsoft.com/v2/powershell/tags/list`

## Building & Publishing

There a few files included in repo to assist with building and publishing the docker container.

* `image.config` - simple file with configurations for building/publishing the image.
* `test.sh` - Ensure your environment is ready to build/publish the docker image.
* `build.sh` - Build the `latest` image based on `image.config`. Build can take an argument with `Dockerfile name`.
* `release.sh` - Build the `version` based on the `image.config` and publish the image to docker.hub. Can take argument `repush` if authentication fails.
* `VERSION` - Current version of this container wrapper. (i.e. 0.0.2) The published container on docker.hub will have a paired version with psfalcon like (v1.0.8-0.0.2).

* `interactive` - Allows for running the PSFalcon Container in interactive mode with an argument for the *tag* defaulted to `latest`.

## Github Actions

* `docker-image.yml` runs `build.sh Dockerfile` which defaults to Ubuntu 20.04 for the CI test.

## Proxy PSFalcon

[README - MITM Proxy](proxy/README.mitm.md) - Intercepting PSFalcon Container communications.

## TBD

* Windows Server Based Containers.
