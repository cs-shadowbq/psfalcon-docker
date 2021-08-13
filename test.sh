#!/usr/bin/env bash
set -e
# shellcheck source=image.config
source image.config

required_commands=( curl git docker sed )
for i in "${required_commands[@]}"
do
    command -v "$i" >/dev/null 2>&1 || { echo >&2 "Please install $i or set it in your path. Aborting."; exit 1; }
done

# Check if docker is running
if ! docker info >/dev/null 2>&1; then
    echo "Docker does not seem to be running, run it first and retry. Aborting."; exit 1
fi

if ! timeout -s SIGKILL 3s docker login index.docker.io >/dev/null 2>&1; then
    echo "Login to Docker Hub and retry. Aborting."; exit 1
fi

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

latest_module_release=$(get_latest_release 'crowdstrike/psfalcon')

echo "Latest 'crowdstrike/psfalcon' Release: $latest_module_release"


if [ "$PSFALCON" != "$latest_module_release" ]; then
    echo "****"
    echo "WARNING: Not building using the latest 'crowdstrike/psfalcon' release."
    echo "****"
fi

VERSION=$(<./VERSION)
echo "Configured to build: $PSFALCON-$VERSION"