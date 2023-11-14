#!/usr/bin/env bash

if [ $# -eq 1 ]; then
    dir=$1
else
    dir=$PKGDIR_ABS
fi

if [[ "${dir}" == "" ]]; then
    echo "Usage: $0 dir"
    exit 1
fi

find $dir -iname '*:Zone.Identifier' -print0 \
    | xargs --null -I '{}' rm '{}'
