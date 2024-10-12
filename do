#!/usr/bin/env bash
set -eu -o pipefail

build-game() {
    if [[ -z "${IMAGE_DIR}" ]]; then
        echo "IMAGE_DIR env var must be set"
        exit
    fi

    docker build --progress=plain -f images/${IMAGE_DIR}/Dockerfile --build-arg IMAGE_DIR=${IMAGE_DIR} -t joshhsoj1902/docker-linuxgsm-images:latest-${IMAGE_DIR} .

}

"$@"