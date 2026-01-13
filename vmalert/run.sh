#!/usr/bin/with-contenv bashio

set -xe  # Allow command errors without killing the addon

NOTIFIER_ENDPOINT=$(bashio::config 'notifier_endpoint')
VICTORIAMETRICS_ENDPOINT=$(bashio::config 'victoriametrics_endpoint')
EXTRA_ARGS=$(bashio::config 'extra_args')
RULES_DIR="/data/rules"

bashio::log.info "Starting vmalert"

if [ ! -d "${RULES_DIR}" ]; then
  cp -R /defaults/rules "${RULES_DIR}"
fi

/usr/local/bin/vmalert --datasource.url=${VICTORIAMETRICS_ENDPOINT} \
    --remoteRead.url=${VICTORIAMETRICS_ENDPOINT} \
    --remoteWrite.url=${VICTORIAMETRICS_ENDPOINT} \
    --notifier.url=${NOTIFIER_ENDPOINT} \
    ---rule=/data/rules/*.yml \
    ${EXTRA_ARGS}
