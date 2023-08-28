#!/usr/bin/env bash

# /opt/container-scripts/entrypoint.d contains the entrypoint scripts
# all scripts in .d/root are executed as root
# all scripts in .d/ezdev are executed as ezdev

set -e

if [ -z "${ENTRYPOINT_QUIET_LOGS:-}" ]; then
    exec 3>&1
else
    exec 3>/dev/null
fi

#CONTAINER_ALREADY_STARTED="/tmp/CONTAINER_ALREADY_STARTED_PLACEHOLDER"
#if [ ! -e $CONTAINER_ALREADY_STARTED ]; then
#    touch $CONTAINER_ALREADY_STARTED
#    echo "-- First container startup --"
#else
#    echo "-- Second or later container startup --"
#fi
echo >&3 "$0: Started entrypoint as user `id -a`"

scripts_folder="/opt/container-scripts/entrypoint.d/root/"
if /usr/bin/find "${scripts_folder}" -mindepth 1 -maxdepth 1 -type f -print -quit 2>/dev/null | read v; then
    echo >&3 "$0: ${scripts_folder} is not empty, will attempt to perform configuration"

    echo >&3 "$0: Looking for shell scripts in ${scripts_folder}"
    FILE_LIST=$(find "${scripts_folder}" -follow -xtype f -print | sort -V )
    for f in $FILE_LIST; do
        #case "$f" in
        #    *.sh)
                #if [ -x "$f" ]; then
                    echo >&3 "$0: Launching $f";
                    source "$f"
                #else
                #    # warn on shell scripts without exec bit
                #    echo >&3 "$0: Ignoring $f, not executable";
                #fi
        #        ;;
        #    *) echo >&3 "$0: Ignoring $f";;
        #esac
    done

    echo >&3 "$0: Configuration complete; ready for start up"
else
    echo >&3 "$0: No files found in ${scripts_folder}, skipping configuration"
fi

set -- gosu ezdev /opt/container-scripts/entrypoint-ezdev.sh "$@"

exec "$@"