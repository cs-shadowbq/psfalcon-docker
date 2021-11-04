#!/usr/bin/env bash
set -ex
# shellcheck source=image.config

_push_images() {
    docker images shadowbq/psfalcon --filter "label=org.opencontainers.image.version=$VERSION" --format "{{.Tag}}" | xargs -I {} docker push $USERNAME/$IMAGE:{}
}

_bump() {
    # bump version
    VERSION=$(<./VERSION)
    docker run --rm -it treeder/bump --input $VERSION bump > VERSION
    VERSION=$(<./VERSION)
    echo "building version: $PSFALCON-$VERSION"
}

_get_latest_release() {
    curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
        grep '"tag_name":' |                                          # Get tag line
        sed -E 's/.*"([^"]+)".*/\1/'                                  # Pluck JSON value
}

_check_against_latest_release() {
    latest_module_release=$(_get_latest_release 'crowdstrike/psfalcon')
    echo "Latest 'crowdstrike/psfalcon' Release: $latest_module_release"

    # strip 'v if included'
    clean_latest_module_release=$(echo "$latest_module_release" | sed 's/^[vV]//')

    if [ "$PSFALCON" != "$clean_latest_module_release" ]; then
        echo "****"
        echo "* LATEST: $clean_latest_module_release"
        echo "* WARNING: Not building using the latest 'crowdstrike/psfalcon' release."
        echo "****"
    fi
}

default_phase="all"
phase=${1:-$default_phase} # Defaults to /latest

if [ "$phase" == "all" ]; then

    # BUMP, REBUILD, COMMIT and PUBLISH with new version

    source image.config
    _check_against_latest_release

    git pull origin main
    _bump

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
    docker images shadowbq/psfalcon --filter "label=org.opencontainers.image.version=$VERSION" --format "{{.Tag}}" | awk 'BEGIN { FS = "-" } ; $1 == "latest" && NF > 1 {print $2}' | xargs -I {} docker tag $USERNAME/$IMAGE:latest-{} $USERNAME/$IMAGE:$PSFALCON-$VERSION-{}

    # push it
    _push_images

elif [ "$phase" == "repush" ]; then

    docker login docker.io
    source image.config
    VERSION=$(<./VERSION)
    _push_images

else

    echo "unknown phase $phase"
    exit 1

fi
