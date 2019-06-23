### opensds/telemetry/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{%- from "opensds/map.jinja" import opensds with context %}

include:
  - prometheus.clean
  - grafana.clean
