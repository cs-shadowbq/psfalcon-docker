#!/usr/bin/env bash
set -ex
# shellcheck source=image.config
source image.config
VERSION=$(<./VERSION)

default_bases=(Dockerfile.ubuntu.20.04 Dockerfile.ubi8 Dockerfile.alpine)
temp_bases=${1:-"${default_bases[@]}"}
# Fix String to Array
IFS=' ' read -r -a bases <<<"$temp_bases"

function is_gnu_sed() {
    sed --version >/dev/null 2>&1
}

function sed_i_wrapper() {
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
    'Dockerfile') echo 'ubuntu.20.04' ;;
    'Dockerfile.ubuntu.20.04') echo 'ubuntu.20.04' ;;
    'Dockerfile.ubi8') echo 'ubi8' ;;
    'Dockerfile.alpine') echo 'alpine' ;;
    'Dockerfile.proxy') echo 'proxy' ;;
    *) echo '' ;;
    esac
}

for base in "${bases[@]}"; do

    echo "building version: latest"
    if [ "$base" == "Dockerfile" ]; then
        base='Dockerfile.ubuntu.20.04'
    fi
    ostarget=$(docker_kv "$base")

    sed_i_wrapper -i -E "s/(org.opencontainers.image.version=)(.*\")/\1\"${VERSION}\"/" "./$base"
    sed_i_wrapper -i -E "s/(com.github.cs-shadowbq.psfalcon=)(.*\")/\1\"${PSFALCON}\"/" "./$base"
    sed_i_wrapper -i "s/RequiredVersion [0-9\.]*/RequiredVersion ${PSFALCON}/" "./$base"

    docker build . --file "./$base" -t $USERNAME/$IMAGE:latest-"$ostarget" --build-arg IMAGE_CREATE_DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

    if [ "$ostarget" == "ubuntu.20.04" ]; then
        echo "Tagging version (default ubuntu.20.04): latest"
        docker tag $USERNAME/$IMAGE:latest-ubuntu.20.04 $USERNAME/$IMAGE:latest
    fi

done
