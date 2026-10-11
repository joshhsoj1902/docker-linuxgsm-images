#!/usr/bin/env bash
set -eu -o pipefail

# Prefer the daemon the current user can already access. The old check skipped
# sudo only for the "gha" account; any other CI user hit a sudo password prompt
# with no tty. Fall back to passwordless sudo when the user is not in the docker group.
SUDO=''
if [[ "${EUID}" -ne 0 ]] && ! docker info >/dev/null 2>&1; then
    if sudo -n docker info >/dev/null 2>&1; then
        SUDO='sudo'
    else
        echo "Docker is not usable as ${USER:-$(id -un)}, and passwordless sudo is unavailable." >&2
        id >&2 || true
        exit 1
    fi
fi

build() {
    if [[ -z "${IMAGE_DIR}" ]]; then
        echo "IMAGE_DIR env var must be set"
        exit
    fi

    $SUDO docker build --progress=plain -f images/${IMAGE_DIR}/Dockerfile --build-arg IMAGE_DIR=${IMAGE_DIR} -t joshhsoj1902/docker-linuxgsm-images:latest-${IMAGE_DIR} .

}

run() {
    build
    $SUDO docker compose -f images/${IMAGE_DIR}/.tests/docker-compose.yml up
}

test() {
    HOST_IP=`hostname -I | awk '{print $1}'`
    # npm install gamedig -g
    $SUDO docker compose -f images/${IMAGE_DIR}/.tests/docker-compose.yml --profile testing up --force-recreate --remove-orphans -d

    source images/${IMAGE_DIR}/.tests/test.config

    QUERY_MODE="${QUERY_MODE:-gamdig}"
    QUERY_ITERATION_DELAY="${QUERY_ITERATION_DELAY:-5}"
    QUERY_POST_DELAY="${QUERY_POST_DELAY:-0}"
    FILE_TEST="${FILE_TEST:-()}"
    GAMEDIG_TYPE="${GAMEDIG_TYPE:-protocol-valve}"
    GAMEDIG_PORT="${GAMEDIG_PORT:-27015}"

    x=0
    while [ $x -le 60 ]
    do
        x=$(( $x + 1 ))
        echo "Testing Gameserver. iteration $x"
        if [[ "$x" != "1" ]];
        then
            sleep $QUERY_ITERATION_DELAY
        fi


        if [[ "$QUERY_MODE" == "disabled" ]];
        then
            echo "Game testing disabled for this game, skipping tests"
            break
        fi

        if [[ "$QUERY_MODE" == "gamedig" ]];
        then
            # The monitor uses the gamedig baked into the image. A copy on the
            # runner can be a different version and report a healthy server
            # while that monitor is failing.
            compose_file="images/${IMAGE_DIR}/.tests/docker-compose.yml"
            if ! raw=$($SUDO docker compose -f "$compose_file" exec -T linuxgsm gamedig --type "$GAMEDIG_TYPE" "${HOST_IP}:${GAMEDIG_PORT}" "$HOST_IP"); then
                echo "image gamedig query failed"
            fi
            printf '%s\n' "$raw"
            GAMENAME=$(printf '%s\n' "$raw" | jq -r '.name // empty' || true)

            if [ "$GAMENAME" = "LinuxGSM" ];
            then
                echo "Gameserver is healthy."
                break
            else
                echo "($GAMENAME) != (LinuxGSM)"
            fi
        fi

        if [[ "$QUERY_MODE" == "file" ]];
        then
            echo "Testing that files exist"
            missing=0
            for f in "${FILE_TEST[@]}"
            do
                if ! dockerExec "linuxgsm" "ls $f"
                then
                    missing=$(( $missing + 1 ))
                    continue
                fi

            done
            if [[ "$missing" == "0" ]];
            then
                echo "All files found, Test Passed"
                break
            fi
            # TODO: Consider checking monitor now since we expect the server is running and it wouldn't trigger a restart
        fi
    done

    sleep $QUERY_POST_DELAY

    echo "v=========================v"
    $SUDO docker compose -f images/${IMAGE_DIR}/.tests/docker-compose.yml logs --tail 25
    echo "^=========================^"

    if [ $x -ge 60 ];
    then
        echo "================================="
        echo "GAMESERVER DIDN'T START PROPERLY."
        echo "Running other tests anyway".
        echo "================================="
    fi

    echo "Gameserver is ready. Running tests"

    if [ -d "images/${IMAGE_DIR}/.tests/scripts/local" ]; then
        echo "Local tests found"

        for f in images/${IMAGE_DIR}/.tests/scripts/local/*.sh; do
        if ! bash "$f"
        then
            echo "Test Failed \"$f\""
            exit 1
        fi
        done
    fi

    if [ -d "images/${IMAGE_DIR}/.tests/scripts/docker" ]; then
        echo "Docker tests found"

        for f in images/${IMAGE_DIR}/.tests/scripts/docker/*.sh; do
            base_name=$(basename ${f})
            dockerCopyTo $f "linuxgsm" "/tmp/"

            if ! dockerExec "linuxgsm" "bash /tmp/$base_name"
            then
                echo "Test Failed \"$f\""
                exit 1
            fi
        done
    fi

    if [ $x -ge 60 ];
    then
        echo "Exit with failure because server never started."
        exit 1
    fi

    $SUDO docker compose -f images/${IMAGE_DIR}/.tests/docker-compose.yml --profile testing down
}

dockerCopyFrom() {
    srcService=$1
    srcPath=$2
    destPath=$3
    $SUDO docker compose -f images/${IMAGE_DIR}/.tests/docker-compose.yml cp $srcService:$srcPath $destPath
}

dockerCopyTo() {
    srcPath=$1
    destService=$2
    destPath=$3
    $SUDO docker compose -f images/${IMAGE_DIR}/.tests/docker-compose.yml cp $srcPath $destService:$destPath
}

dockerExec() {
    srcService=$1
    command=$2
    $SUDO docker compose -f images/${IMAGE_DIR}/.tests/docker-compose.yml exec $srcService $command
}

"$@"