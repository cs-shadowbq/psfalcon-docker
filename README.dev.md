# README - DEVELOPER

This repo is designed for running the PowerShell PSFalcon Module in a Container with a Linux base.

* Alpine  
* UBI8
* Ubuntu

## Building & Publishing

There a few files included in repo to assist with building and publishing the docker container.

* `image.config` - simple file with configurations for building/publishing the image.
* `test.sh` - Ensure your environment is ready to build/publish the docker image.
* `build.sh` - Build the `latest` image based on `image.config`
* `release.sh` - Build the `version` based on the `image.config` and publish the image to docker.hub.
* `VERSION` - Current version of this container wrapper. (i.e. 0.0.2) The published container on docker.hub will have a paired version with psfalcon like (v1.0.8-0.0.2).

* `interactive` - Allows for running the PSFalcon Container in interactive mode with an argument for the *tag* defaulted to `latest`.

## Proxying the PSFalcon

[README - MITM Proxy](proxy/README.mitm.md) - Intercepting PSFalcon Container communications.

## TBD

* Windows Server Based Containers.
