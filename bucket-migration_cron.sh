#!/bin/bash

export MC_MAX_RETRIES=100
#path of script
SCRIPT_DIR="/root/bucket-data-migration"

#BUCKET NAME="bucket1 bucket2 bucket3"

#SYNC_FOLDER="bucket1"

SYNC_FOLDER=$1
SYNC_FOLDER_LOG=$(echo $SYNC_FOLDER | sed 's/\//_/g')
SRC_PATH="s3-bucket/${SYNC_FOLDER}"
DEST_PATH="ecos-bucket/8485-${SYNC_FOLDER}"

if pgrep -f "mc mirror.*${SRC_PATH}" > /dev/null; then
    echo "Sync for ${SYNC_FOLDER} is already running."
    exit 1
else

while true; do
    TIMESTAMP=$(date "+%Y%m%d-%H%M%S")
    LOG_FILE="${SCRIPT_DIR}/logs/${SYNC_FOLDER_LOG}_${TIMESTAMP}.log" 
    mc mirror --skip-errors --overwrite --retry "$SRC_PATH" "$DEST_PATH" > "${LOG_FILE}" 2>&1
    #mc mirror --overwrite --retry -a "$SRC_PATH" "$DEST_PATH" > "${LOG_FILE}" 2>&1
    LINE_COUNT=$(cat "$LOG_FILE" | wc -l)
    if [ "$LINE_COUNT" -eq 1 ]; then
        break
    fi
    sleep 5
done

fi
