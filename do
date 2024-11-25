#!/usr/bin/env bash
set -eu -o pipefail

SUDO=''
if [[ $EUID != 0 ]] && [[ "$USER" != "circleci" ]]; then
    SUDO='sudo'
fi

build() {
    if [[ -z "${IMAGE_DIR}" ]]; then
        echo "IMAGE_DIR env var must be set"
        exit
    fi

    $SUDO docker build --progress=plain -f images/${IMAGE_DIR}/Dockerfile --build-arg IMAGE_DIR=${IMAGE_DIR} -t joshhsoj1902/docker-linuxgsm-images:latest-${IMAGE_DIR} .

}

test() {
    HOST_IP=`hostname -I | awk '{print $1}'`
    # npm install gamedig -g
    $SUDO docker compose -f images/${IMAGE_DIR}/.tests/docker-compose.yml up -d

    source images/${IMAGE_DIR}/.tests/test.config

    sleep 10

    x=1
    while [ $x -le 60 ]
    do
        echo "Testing Gameserver. iteration $x"

        GAMENAME=`gamedig --type $GAMEDIG_TYPE $HOST_IP:$GAME_PORT $HOST_IP | jq -r .name`
        if [ "$GAMENAME" = "LinuxGSM" ];
        then
            echo "Gameserver is healthy."
            break
        else
            echo "($GAMENAME) != (LinuxGSM)"
        fi
        gamedig --type $GAMEDIG_TYPE $HOST_IP:$GAME_PORT $HOST_IP


        x=$(( $x + 1 ))
        sleep 10
    done

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
            $SUDO docker compose -f images/${IMAGE_DIR}/.tests/docker-compose.yml cp $f linuxgsm:/tmp/

            if ! $SUDO docker compose -f images/${IMAGE_DIR}/.tests/docker-compose.yml exec linuxgsm bash /tmp/$base_name
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

    $SUDO docker compose -f images/${IMAGE_DIR}/.tests/docker-compose.yml down


}

"$@"