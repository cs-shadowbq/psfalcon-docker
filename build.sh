#!/usr/bin/env bash
set -ex
# shellcheck source=image.config
source image.config
VERSION=$(<./VERSION)

sed -i '' "/LABEL version=/s/.*/LABEL version=\"${VERSION}\"/" Dockerfile
sed -i '' "/LABEL psfalcon=/s/.*/LABEL psfalcon=\"${PSFALCON}\"/" Dockerfile
sed -i '' "s/RequiredVersion [0-9\.]*/RequiredVersion ${PSFALCON}/" Dockerfile

echo "building version: latest"
docker build -t $USERNAME/$IMAGE:latest .