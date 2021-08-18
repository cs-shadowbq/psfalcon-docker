#!/usr/bin/env bash
set -ex
# shellcheck source=image.config
source image.config

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