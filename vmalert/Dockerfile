ARG BUILD_FROM
FROM victoriametrics/vmalert:v1.108.0 AS vmalert

FROM $BUILD_FROM
COPY --from=vmalert /vmalert-prod /usr/local/bin/vmalert
COPY ./rules /defaults/rules
