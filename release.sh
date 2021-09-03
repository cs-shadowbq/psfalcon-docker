#!/usr/bin/env bash
set -ex
# shellcheck source=image.config

default_phase="all"
phase=${1:-$default_phase}   # Defaults to /latest

if [ "$phase" == "all" ]; then

    source image.config
    get_latest_release() {
        curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
        grep '"tag_name":' |                                            # Get tag line
        sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
    }
    latest_module_release=$(get_latest_release 'crowdstrike/psfalcon')

    echo "Latest 'crowdstrike/psfalcon' Release: $latest_module_release"

    # strip 'v if included'
    clean_latest_module_release=$(echo "$latest_module_release" | sed 's/^[vV]//')

    if [ "$PSFALCON" != "$clean_latest_module_release" ]; then
        echo "****"
        echo "* LATEST: $clean_latest_module_release"
        echo "* WARNING: Not building using the latest 'crowdstrike/psfalcon' release."
        echo "****"
    fi


    git pull origin main

    # bump version
    docker run --rm -v "$PWD":/app treeder/bump patch
    VERSION=$(<./VERSION)
    echo "building version: $PSFALCON-$VERSION"

    # run build
    ./build.sh

    # tag it
    git add -A
    git commit -m "version $PSFALCON-$VERSION"
    git tag -a "$PSFALCON-$VERSION" -m "version $PSFALCON-$VERSION"
    git push origin main
    git push --tags origin main

    # Show Current Images of this VERSION
    docker images shadowbq/psfalcon --filter "label=org.opencontainers.image.version=$VERSION"
    docker images shadowbq/psfalcon --filter "label=org.opencontainers.image.version=$VERSION" --format "{{.Tag}}" | awk 'BEGIN { FS = "-" } ; $1 == "latest" && NF > 1 {print $2}' | xargs -I {}  docker tag $USERNAME/$IMAGE:latest-{} $USERNAME/$IMAGE:$PSFALCON-$VERSION-{}


    # push it
    docker images shadowbq/psfalcon --filter "label=org.opencontainers.image.version=$VERSION" --format "{{.Tag}}" | xargs -I {}  docker push $USERNAME/$IMAGE:{} 

elif [ "$phase" == "repush" ]; then

    docker login docker.io
    source image.config
    VERSION=$(<./VERSION)
    docker images shadowbq/psfalcon --filter "label=org.opencontainers.image.version=$VERSION" --format "{{.Tag}}" | xargs -I {}  docker push $USERNAME/$IMAGE:{} 

else 

    echo "unknown phase $phase"
    exit 1;

fi
