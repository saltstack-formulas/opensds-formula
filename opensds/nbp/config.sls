###  opensds/nbp/config.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds with context %}

  {% set plugintype = opensds.nbp.dir[opensds.nbp.provider] %}
  {% set conf_file = opensds.nbp.dir[plugintype] ~ '/' ~ opensds.nbp[plugintype]['configfile'] %}

  {% for k, v in opensds.nbp[plugintype].conf %}

opensds nbp csi {{ opensds.nbp.release.version }} replace {{ k }}:
  file.replace:
    - name: {{ conf_file }}
    - pattern: {{ '(^.*' ~ k ~ ').*$' }}
    - repl: {{ '\1: ' ~ v }}

opensds nbp {{ opensds.nbp.release.version }} ensure {{ k }}:
  file.line:
    - name: {{ conf_file }}
    - match: {{ '(^.*' ~ k ~ ').*$' }}
    - mode: ensure
    - content: {{ '\1: ' ~ v }}
    - backup: True

  {%- endfor %}

opensds nbp ensure correct endpoint in opensds k8s {{ plugintype }} plugin:
  file.line:
    - name: {{ opensds.dir.[plugin] }}/{{ opensds.nbp.plugin[plugin] }}
    - match: '^  opensdsendpoint'
    - content: '  opensdsendpoint: {{ opensds.auth.endpoint }}'
    - mode: ensure
    - backup: True

opensds nbp ensure correct auth strategy in opensds k8s {{ plugintype }} plugin:
  file.line:
    - name: {{ opensds.dir.[plugin] }}/{{ opensds.nbp.plugin[plugin] }}
    - match: '^  opensdsauthstrategy'
    - content: '  opensdsauthstrategy: {{ opensds.auth.provider }}'
    - mode: ensure
    - backup: True

opensds nbp ensure correct os auth url in opensds k8s {{ plugintype }} plugin:
  file.line:
    - name: {{ opensds.dir.[plugin] }}/{{ opensds.nbp.plugin[plugin] }}
    - match: '^  osauthurl'
    - content: '  osauthurl: {{ opensds.auth.conf.auth_url }}'
    - mode: ensure
    - backup: True
