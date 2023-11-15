#!/usr/bin/env bash

input=$1

if [[ "$input" == "" ]]; then
    echo "Usage: $0 input"
    exit 1
fi

gpg --decrypt --quiet "$input"
