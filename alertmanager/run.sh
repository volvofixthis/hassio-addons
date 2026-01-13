#!/usr/bin/with-contenv bashio
set -xe

TEMPLATES_DIR="/config/templates"
LISTEN_ADDRESS=$(bashio::config 'listen_address')
CONFIG_FILE=$(bashio::config 'config_file')
EXTRA_ARGS=$(bashio::config 'extra_args')

# Seed default config on first run (do not overwrite user changes)
if [ ! -f "${CONFIG_FILE}" ]; then
  cp /defaults/alertmanager.yml "${CONFIG_FILE}"
fi

if [ ! -d "${TEMPLATES_DIR}" ]; then
  cp -R /defaults/templates "${TEMPLATES_DIR}"
fi

exec /usr/local/bin/alertmanager \
  --web.listen-address="${LISTEN_ADDRESS}" \
  --config.file="${CONFIG_FILE}" \
  --storage.path=/data/storage \
  ${EXTRA_ARGS}

