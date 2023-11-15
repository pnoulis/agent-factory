#!/usr/bin/env bash

set -o allexport
set -o errexit
set -o pipefail


input=$1

if [[ "$input" == "" ]]; then
    echo "Usage: $0 input output"
    exit 1
elif ! realpath -e "$input" >/dev/null; then
    exit 1
elif [ -d "$input" ]; then
    echo "Directory encryption not supported yet!"
    exit 1
elif ! [ -r "$input" ]; then
    echo "Insufficient file permissions: read"
    exit 1
fi

gpg --symmetric $input
