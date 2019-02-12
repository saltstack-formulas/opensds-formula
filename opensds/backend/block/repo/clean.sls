###  opensds/backend/block/repo/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "opensds/map.jinja" import opensds with context %}

  {%- if opensds.deploy_project not in ('gelato',)  %}
      {%- if opensds.backend.block.ids is iterable and opensds.backend.block.ids is string %}
          {%- set backends = opensds.backend.block.ids.split(', ') %}
      {%- else %}
          {%- set backends = opensds.backend.block.ids %}
      {%- endif %}
      {%- for id in backends %}

opensds backend block repo {{ id }} ensure directory removed:
  file.absent:
    - name: {{ opensds.dir.sushi + '/' + id }}

      {%- endfor %}
  {%- endif %}
