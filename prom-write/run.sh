#!/usr/bin/with-contenv bashio

set +e  # Allow command errors without killing the addon

HA_TOKEN=$(bashio::config 'ha_token')
ENDPOINT=$(bashio::config 'endpoint')
USERNAME=$(bashio::config 'username')
PASSWORD=$(bashio::config 'password')
INTERVAL=$(bashio::config 'interval')

bashio::log.info "Starting Prometheus exporter with interval ${INTERVAL}s"

while true; do
    bashio::log.info "Fetching /api/prometheus from Home Assistant"

    RESPONSE=$(curl -sSL -H "Authorization: Bearer ${HA_TOKEN}" \
        http://homeassistant:8123/api/prometheus)

    if [ $? -ne 0 ] || [ -z "$RESPONSE" ]; then
        bashio::log.error "Failed to fetch Prometheus data"
    else
        bashio::log.info "Sending data to vmalert endpoint"
        echo "$RESPONSE" | curl -sSL -u "${USERNAME}:${PASSWORD}" \
            -X POST "${ENDPOINT}" --data-binary @-

        if [ $? -ne 0 ]; then
            bashio::log.error "Failed to send data to vmalert endpoint"
        else
            bashio::log.info "Successfully sent data"
        fi
    fi

    sleep "$INTERVAL"
done
