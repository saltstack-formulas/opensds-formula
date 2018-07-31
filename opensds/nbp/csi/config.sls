# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds with context %}

{% set conf_file = opensds.nbp.dir[opensds.nbp.plugin_type] ~ '/' ~ opensds.nbp[opensds.nbp.plugin_type]['configfile'] %}
  {% for k, v in opensds.nbp[opensds.nbp.plugin_type].conf %}

opensds nbp {{ opensds.nbp.release.version }} {{ opensds.nbp.plugin_type }} config replace {{ k }}:
  file.replace:
    - name: {{ conf_file }}
    - pattern: {{ '(^.*' ~ k ~ ').*$' }}
    - repl: {{ '\1: ' ~ v }}

opensds nbp {{ opensds.nbp.release.version }} {{ opensds.nbp.plugin_type }} config ensure {{ k }}:
  file.line:
    - name: {{ conf_file }}
    - match: {{ '(^.*' ~ k ~ ').*$' }}
    - mode: ensure
    - content: {{ '\1: ' ~ v }}
    - backup: True

  {%- endfor %}
