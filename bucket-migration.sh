#!/bin/bash

export MC_MAX_RETRIES=100
SCRIPT_DIR=`pwd`

#BUCKET NAME="getitnow-prod squarenow-production pookadai-production paisanow-production"

#SYNC_FOLDER="squarenow-production"
#SYNC_FOLDER="pookadai-production"
#SYNC_FOLDER="paisanow-production"
SYNC_FOLDER="getitnow-prod"

SRC_PATH="s3-bucket/${SYNC_FOLDER}"
DEST_PATH="ecos-bucket/8485-${SYNC_FOLDER}"

while true; do
    TIMESTAMP=$(date "+%Y%m%d-%H%M%S")
    LOG_FILE="${SCRIPT_DIR}/logs/${SYNC_FOLDER}_${TIMESTAMP}.log" 
    mc mirror --skip-errors --dry-run "$SRC_PATH" "$DEST_PATH" > "${LOG_FILE}" 2>&1
    #mc mirror --overwrite --retry -a "$SRC_PATH" "$DEST_PATH" > "${LOG_FILE}" 2>&1
    LINE_COUNT=$(cat "$LOG_FILE" | wc -l)
    if [ "$LINE_COUNT" -eq 1 ]; then
        break
    fi
    sleep 5
done
