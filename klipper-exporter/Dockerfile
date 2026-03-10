ARG BUILD_FROM

FROM golang:1.24-alpine AS builder

ARG EXPORTER_VERSION=v0.14.0

RUN apk add --no-cache git
RUN git clone --depth 1 --branch "${EXPORTER_VERSION}" https://github.com/scross01/prometheus-klipper-exporter.git /src

WORKDIR /src
RUN CGO_ENABLED=0 go build -o /usr/local/bin/prometheus-klipper-exporter ./main.go

FROM $BUILD_FROM

COPY --from=builder /usr/local/bin/prometheus-klipper-exporter /usr/local/bin/prometheus-klipper-exporter
COPY run.sh /run.sh

RUN chmod +x /run.sh

CMD ["/run.sh"]
