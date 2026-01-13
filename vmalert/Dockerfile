FROM victoriametrics/vmalert:v1.108.0 AS vmalert

ARG BUILD_FROM
FROM $BUILD_FROM
COPY --from=vmalert /vmalert-prod /usr/local/bin/vmalert
COPY ./rules /defaults/rules
