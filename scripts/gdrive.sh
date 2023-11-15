#!/usr/bin/env bash

set -o allexport

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

rclone ls :drive:
# rclone ls \
#        --drive-client-id="$GDRIVE_CLIENT_ID" \
#        --drive-client-secret="$GDRIVE_CLIENT_SECRET" \
#        --drive-scope="drive" \
#        --drive-token="$GDRIVE_ACCESS_TOKEN" \
#        --drive-root-folder-id="$GDRIVE_ROOTDIR" \
#        :drive:
