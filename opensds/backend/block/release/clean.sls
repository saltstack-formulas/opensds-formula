###  opensds/backend/block/release/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "opensds/map.jinja" import opensds with context %}

  {%- if opensds.deploy_project not in ('gelato',)  %}
     {%- for id in opensds.backend.block.ids %}
         {%- if id in opensds.backend.block.daemon and "release" in opensds.backend.block.daemon[id]['strategy']%} 

opensds backend block release {{ id }} download directory clean:
  file.absent:
    - name: {{ opensds.dir.sushi }}/{{ id }}

         {%- endif %}
     {%- endfor %}
  {%- endif %}
