# opensds/backend/drivers/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "opensds/map.jinja" import opensds with context %}

  {%- set driver = {} %}
  {%- for id in opensds.backend.ids %}
      {%- if id in opensds.backend.drivers %}
          {%- set driver = opensds.backend.drivers[id] %}
          {#- if salt['file.file_exists']( tpldir ~ '/yaml/' ~ id ~ '.yaml') #}

              {%- import_yaml tpldir ~ '/yaml/' ~ id ~ '.yaml' as driver_yaml %}
              {%- do salt['defaults.merge'](driver_yaml, opensds.backend.drivers[id], merge_lists=True) %}
              {%- do driver.update( driver_yaml ) %}

        ##################
        ####  driver.conf
        ##################
opensds backend driver {{ id }} generate driver file:
  file.managed:
    - name: {{ opensds.dir.driver }}/{{ id }}.yaml
    - source: salt://opensds/dock/drivers/yaml/template.jinja
    - template: jinja
    - user: {{ opensds.user or 'root' }}
    - mode: {{ opensds.file_mode }}
    - context:
      driver: {{ driver|json }}

          {#- endif #}
      {%- endif %}
  {%- endfor %}
