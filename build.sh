#!/usr/bin/env bash
set -ex
USERNAME=shadowbq
IMAGE=psfalcon

docker build -t $USERNAME/$IMAGE:latest .