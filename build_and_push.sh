#!/bin/sh

set -e

image_name="elmtai/docker-rust-kcov"
rust_toolchain="`grep RUST_TOOLCHAIN= Dockerfile | sed "s|.*RUST_TOOLCHAIN=\(.*\)|\1|g"`"
from_kcov_version="`grep "^FROM " Dockerfile | sed "s|.*:\(.*\)|\1|g"`"

tags=("latest"
      "`date +%Y%m%d`"
      "`date +%Y%m%d`-`git describe --tags --always`"
      "rust_${rust_toolchain}-kcov_${from_kcov_version}-`date +%Y%m%d`-`git describe --tags --always`"
)

# Build image
function docker_build() {
    for tag in ${tags[*]}; do
        docker build --tag ${image_name}:${tag} .
    done
}

# Push image and its tags
function docker_push() {
    for tag in ${tags[*]}; do
        docker push ${image_name}:${tag}
    done
}

if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    echo "Script ${BASH_SOURCE[0]} is being sourced, not doing anything."
else
    echo "Script ${BASH_SOURCE[0]} is NOT being sourced, executing..."
    docker_build
    docker_push
fi
