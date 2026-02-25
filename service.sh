#!/system/bin/sh

BOT_TOKEN="345345345:453bv5v54" # replace both 
CHAT_ID="0000000000"

CURL=/system/bin/curl
API="https://api.telegram.org/bot${BOT_TOKEN}"

for i in {1..120}; do
  if ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

${CURL} -s -o /dev/null "${API}/sendMessage" -d chat_id="${CHAT_ID}" -d text="Service running...."

OFFSET=0

while true; do
  UPDATES=$(${CURL} -s "${API}/getUpdates?timeout=30&offset=${OFFSET}" 2>/dev/null)

  if [ -z "$UPDATES" ] || echo "$UPDATES" | grep -q '"ok":false'; then
    sleep 15
    continue
  fi

  LATEST_ID=$(echo "$UPDATES" | grep -o '"update_id":[0-9]*' | tail -1 | grep -o '[0-9]*')
  if [ -n "$LATEST_ID" ]; then
    OFFSET=$(expr $LATEST_ID + 1)
  fi

  if echo "$UPDATES" | grep -q '"text":"/brightness"'; then
    echo 4095 > /sys/class/backlight/panel0-backlight/brightness 2>/dev/null
    ${CURL} -s -o /dev/null "${API}/sendMessage" -d chat_id="${CHAT_ID}" -d text="Brightness MAX 4095 ✓"
  fi

  sleep 4
done
