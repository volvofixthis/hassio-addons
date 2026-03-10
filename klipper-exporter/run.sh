#!/usr/bin/with-contenv bashio

set -euo pipefail

WEB_LISTEN_ADDRESS=$(bashio::config 'web_listen_address')
LOGGING_LEVEL=$(bashio::config 'logging_level')
MOONRAKER_APIKEY=$(bashio::config 'moonraker_apikey')
EXTRA_ARGS=$(bashio::config 'extra_args')

bashio::log.info "Starting Prometheus Klipper Exporter"

MOONRAKER_ARG=""
if [[ -n "${MOONRAKER_APIKEY}" ]]; then
  MOONRAKER_ARG="--moonraker.apikey=${MOONRAKER_APIKEY}"
fi

exec /usr/local/bin/prometheus-klipper-exporter \
  --web.listen-address="${WEB_LISTEN_ADDRESS}" \
  --logging.level="${LOGGING_LEVEL}" \
  ${MOONRAKER_ARG} \
  ${EXTRA_ARGS}
