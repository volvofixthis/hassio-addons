ARG BUILD_FROM
FROM prom/alertmanager:v0.27.0 as alertmanager

FROM $BUILD_FROM

COPY --from=alertmanager /bin/alertmanager /usr/local/bin/alertmanager
COPY run.sh /run.sh
COPY alertmanager.yml /defaults/alertmanager.yml
COPY templates /defaults/templates

RUN chmod +x /run.sh
ENTRYPOINT ["/run.sh"]

