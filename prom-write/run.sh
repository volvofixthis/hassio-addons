#!/usr/bin/with-contenv bashio

HA_TOKEN=$(bashio::config 'ha_token')
ENDPOINT=$(bashio::config 'endpoint')
USERNAME=$(bashio::config 'username')
PASSWORD=$(bashio::config 'password')
INTERVAL=$(bashio::config 'interval')

echo "[INFO] Starting Prometheus exporter with interval ${INTERVAL}s"

while true; do
  echo "[INFO] Fetching /api/prometheus from Home Assistant"

  RESPONSE=$(curl -sSL -H "Authorization: Bearer ${HA_TOKEN}" \
    http://homeassistant:8123/api/prometheus)


  if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to fetch Prometheus data"
  else
    echo "[INFO] Sending data to vmalert endpoint"
    echo "$RESPONSE" | curl -sSL -u "${USERNAME}:${PASSWORD}" \
      -X POST "${ENDPOINT}" --data-binary @-
  fi

  sleep "$INTERVAL"
done
