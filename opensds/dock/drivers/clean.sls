# opensds/backend/drivers/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "opensds/map.jinja" import opensds with context %}

  {%- for id in opensds.backend.ids %}
      {%- if id in opensds.backend.drivers %}

        ################
        # <driver>.yaml
        ################
opensds backend drivers {{ id }} remove driver file:
  file.absent:
    - name: {{ opensds.dir.driver }}/{{ id }}.yaml

      {%- endif %}
  {%- endfor %}
