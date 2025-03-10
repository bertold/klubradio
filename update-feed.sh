#!/bin/bash

# Broadcast schedule: 7:00AM, 10:00AM, 12:00PM, 4:00PM, 6:00PM Central European Time
# Source: https://www.klubradio.hu/musorok/a-lenyeg-3

HOUR=$(date +%H)

FILE_PREFIX=""
case $HOUR in
  17 | 18 | 19 | 20 | 21 | 22 | 23)
    FILE_PREFIX="18"
    ;;
  14 | 15 | 16)
    FILE_PREFIX="16"
    ;;
  11 | 12 | 13)
    FILE_PREFIX="12"
    ;;
  09 | 10)
    FILE_PREFIX="10"
    ;;
  01 | 02 | 03 | 04 | 05 | 06 | 07 | 08)
    FILE_PREFIX="07"
    ;;
esac

if [ -z "$FILE_PREFIX" ]; then
  echo "Could not determine file prefix for hour ${HOUR}"
  exit 1
fi

STREAM_URL="https://www.klubradio.hu/data/hanganyagok/$(date +%Y/%-m/%-d)/archivum_alenyeg_${FILE_PREFIX}_$(date +%y%m%d).mp3"
USER_AGENT=$(curl -s https://raw.githubusercontent.com/jnrbsn/user-agents/refs/heads/main/user-agents.json | jq '.[1]')
if [ -z "$USER_AGENT" ]; then
  USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36"
fi

CURRENT_URL=$(jq -r '.streamUrl' < klubradio.json)

if [ "${CURRENT_URL}" == "${STREAM_URL}" ]; then
  echo "Stream URL has not changed. Exiting."
  exit 0
fi

# Check to see if stream exists using a HEAD call
curl --output /dev/null --header "User-Agent: ${USER_AGENT}" --silent --head --fail "${STREAM_URL}"
RC=$?
if [ ${RC} -ne 0 ]; then
  echo "No updated stream found at either ${STREAM_URL}. Status code: ${RC}"
  exit 0
fi

UUID=$(uuidgen)
UPDATED=$(date +%Y-%m-%dT%H:%M:%S%:z)

cat <<EOF > /tmp/update.json
{
  "uid": "urn:uuid:${UUID}",
  "updateDate": "${UPDATED}",
  "titleText": "Latest news from Klub Radio",
  "mainText": "",
  "streamUrl": "${STREAM_URL}",
  "redirectionUrl": "https://www.klubradio.hu/"
}
EOF

mv /tmp/update.json ./klubradio.json

exit 0
