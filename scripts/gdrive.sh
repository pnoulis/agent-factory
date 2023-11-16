#!/usr/bin/env bash

# Rclone is a command line program that manages files in cloud storage
# spaces. It aims to present a uniform CLI to all CSP (cloud storage
# providers) including google drive. Each provider refered to as a
# storage system or remote in `man clone` make its services available
# to clients through a public API, rclone being one such client. In
# order to allow clients access to their public API, providers employ
# authentication methods to verify the identity of the client after
# which, access is granted and the client is free to use the API.

# Regardless of the underlying authentication scheme specific to each
# provider; the user of rclone must supply the Credentials which
# rclone then forwards to the Provider for Authentication in one of 3
# ways:

# 1) `rclone config`
#     interactive TUI widget that guide the user through a Provider
#     configuration
# 2) command line paramaters
#     --drive-client-id
# 3) environment variables
#     RCLONE_DRIVE_CLIENT_ID

# This script for the moment makes use of the 3rd method.

# Rclone's google drive bridge is authenticated using the OATH2
# protocol and as such requires the first 3 parameter. The rest are
# optional. These paramaeters are found in the execution environment
# placed there by `make run file=script/gdrive.sh`
# More info about the google drive bridge: https://rclone.org/drive/

# If instead of using method 3 i wanted to use method 2 i would have used
# the following command line options

# --drive-client-id="$GDRIVE_CLIENT_ID"
# --drive-client-secret="$GDRIVE_CLIENT_SECRET"
# --drive-scope="drive"
# --drive-token="$GDRIVE_ACCESS_TOKEN"
# --drive-root-folder-id="$GDRIVE_ROOTDIR"


set -o allexport


# Arguments
command=$1
source=$2
destination=$3
if [ "$command" == "" ]; then
    echo "Usage: $0 command [<source>] [<destination>]"
    exit 1
fi

# Verify Credentials have been found in the execution environment.
RCLONE_DRIVE_CLIENT_ID="$GDRIVE_CLIENT_ID"
RCLONE_DRIVE_CLIENT_SECRET="$GDRIVE_CLIENT_SECRET"
RCLONE_DRIVE_TOKEN="$GDRIVE_TOKEN"
RCLONE_DRIVE_ROOT_FOLDER_ID="$GDRIVE_ROOT_FOLDER_ID"
RCLONE_DRIVE_SCOPE="drive"
for key in RCLONE_DRIVE_CLIENT_ID \
               RCLONE_DRIVE_CLIENT_SECRET \
               RCLONE_DRIVE_TOKEN \
               RCLONE_DRIVE_ROOT_FOLDER_ID; do
    if [[ "${!key}" == "" ]]; then
        echo "Empty value required: $key"
        exit 1
    fi
done

# Verify the package root directory has been found in the execution environment
if [ "${pkgdir_abs:-}" == "" ]; then
    echo "Required empty variable: \$pkgdir_abs"
    exit 1
fi

case $command in
    push)
        printf "Pushing %s -> remote/%s ... \n" $source $destination
        for arg in command source destination; do
            if [ "${!arg}" == "" ]; then
                echo "Usage: $0 <command> <source> <destination>"
                exit 1
            fi
        done
        rclone copy --no-traverse --quiet --update --progress \
               $source :drive:$destination
        if [ $? -gt 0 ]; then
	          echo 'FAILED'
	      else
	          echo 'DONE'
	      fi
	      echo '------------------------------'
        ;;
    pull)
        printf "Pulling remote/%s -> %s ... \n" $source $destination
        for arg in command source destination; do
            if [ "${!arg}" == "" ]; then
                echo "Usage: $0 <command> <source> <destination>"
                exit 1
            fi
        done
        rclone copy --no-traverse --quiet --update --progress \
               :drive:$source $pkgdir_abs/$destination
        if [ $? -gt 0 ]; then
	          echo 'FAILED'
	      else
	          echo 'DONE'
	      fi
	      echo '------------------------------'
        ;;
    list | ls)
        rclone --quiet ls :drive:
        ;;
    *)
        echo "Unknown command: $command"
        exit 1
        ;;
esac
