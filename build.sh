#!/usr/bin/env bash
set -ex
# shellcheck source=image.config
source image.config
VERSION=$(<./VERSION)

function is_gnu_sed(){
  sed --version >/dev/null 2>&1
}

function sed_i_wrapper(){
    if is_gnu_sed; then
        $(which sed) "$@"
    else
        a=()
        for b in "$@"; do
            [[ $b == '-i' ]] && a=("${a[@]}" "$b" "") || a=("${a[@]}" "$b")
        done
        $(which sed) "${a[@]}"
    fi
}

sed_i_wrapper -i "/LABEL version=/s/.*/LABEL version=\"${VERSION}\"/" ./Dockerfile
sed_i_wrapper -i "/LABEL psfalcon=/s/.*/LABEL psfalcon=\"${PSFALCON}\"/" ./Dockerfile
sed_i_wrapper -i "s/RequiredVersion [0-9\.]*/RequiredVersion ${PSFALCON}/" ./Dockerfile

echo "building version: latest"
docker build . --file ./Dockerfile -t $USERNAME/$IMAGE:latest