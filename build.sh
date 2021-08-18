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

docker_kv() {
    case $1 in
        'Dockerfile') echo 'ubuntu.20.04';;
        'Dockerfile.ubuntu.20.04') echo 'ubuntu.20.04';;
        'Dockerfile.ubi8') echo 'ubi8';;
        'Dockerfile.alpine') echo 'alpine';;
        *) echo '';;
    esac
}


bases=( Dockerfile Dockerfile.ubi8 )
for base in "${bases[@]}"
do
    sed_i_wrapper -i "/LABEL org.opencontainers.image.version=/s/.*/LABEL org.opencontainers.image.version=\"${VERSION}\"/" "./$base"
    sed_i_wrapper -i "/LABEL com.github.cs-shadowbq.psfalcon=/s/.*/LABEL com.github.cs-shadowbq.psfalcon=\"${PSFALCON}\"/" "./$base"
    sed_i_wrapper -i "s/RequiredVersion [0-9\.]*/RequiredVersion ${PSFALCON}/" "./$base"

    echo "building version: latest"
    ostarget=$(docker_kv "$base")
    docker build . --file "./$base" -t $USERNAME/$IMAGE:latest-"$ostarget" --build-arg IMAGE_CREATE_DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

done


echo "Tagging version (default ubuntu.20.04): latest"
docker tag $USERNAME/$IMAGE:latest-ubuntu.20.04 $USERNAME/$IMAGE:latest
