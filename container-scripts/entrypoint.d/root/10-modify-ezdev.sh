#!/usr/bin/env bash

cuname=ezdev
cgname=ezdev

huid=$(stat -c '%u' "${PWD}")
hgid=$(stat -c '%g' "${PWD}")

echo "$0: Changing the uid:gid to ${huid}:${hgid}"

usermod -u $huid ${cuname} 2> /dev/null && {
  groupmod -g $hgid ${cgname} 2> /dev/null || usermod -a -G $hgid ${cuname}
}

echo "$0: `id -a ezdev`"
