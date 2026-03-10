## About
This is my custom Home Assistant (Hass.io) addons.
### Prom write
This addon scrapes metrics from Home Assistant and sends them  
to vmagent using the Prometheus import endpoint at /api/v1/import/prometheus.  

For example, you can enable the system monitor and add some sensors.  
In my case, the Home Assistant configuration looks like this:
```yaml
prometheus:
  namespace: hass
  filter:
    include_entity_globs:
      - sensor.weather_*
      - sensor.system_*
      - sensor.qingping_air_monitor_lite_*
```
After that, you need to create a long-lived access token in Home Assistant
and add it to the addon configuration.

My import endpoint is password-protected, so I also added a username and password.

### Prometheus Klipper Exporter
This addon runs `prometheus-klipper-exporter` for Klipper/Moonraker.

By default it listens on `0.0.0.0:9101` and exposes metrics endpoints used by Prometheus.
If your Moonraker instance requires API key authentication, set `moonraker_apikey`
in the add-on configuration.
