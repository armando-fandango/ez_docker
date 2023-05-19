#!/usr/bin/env bash

set -e

# Change uid and gid of node user so it matches ownership of current dir
#if [ "$MAP_NODE_UID" != "no" ]; then
#    if [ ! -d "$MAP_NODE_UID" ]; then
#        MAP_NODE_UID=$PWD
#    fi

    export duid=$(stat -c '%u' "$PWD")
    export dgid=$(stat -c '%g' "$PWD")
    export uname=ezdev
    export gname=ezdev
    export from=ghcr.io/armando-fandango/ez/ez:0.4-ai-lm-conda-bullseye-slim
   #sudo usermod -u $DUID ezdev 2> /dev/null && {
   #   sudo groupmod -g $DGID ezdev 2> /dev/null || sudo usermod -a -G $DGID ezdev
   # }

#fi


#echo "**** GOSU ezdev $@ ..."

#exec /usr/sbin/gosu ezdev "$@"

docker compose -f fixid-docker-compose.yml build fixid1  --progress plain --no-cache \
  --build-arg from=${from} \
  --build-arg duid=${duid} \
  --build-arg dgid=${dgid} \
  --build-arg user=${user} \
  --build-arg group=${group}
