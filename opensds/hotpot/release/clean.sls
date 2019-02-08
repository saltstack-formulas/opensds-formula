###  opensds/hotpot/release/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "opensds/map.jinja" import opensds with context %}

   {%- if opensds.deploy_project not in ('gelato',)  %}
       {%- for id in opensds.hotpot.ids %}
           {%- if id in opensds.hotpot.daemon and 'release' in opensds.hotpot.daemon[id]['strategy']|lower %}

opensds hotpot release {{ id }} download directory clean:
  file.absent:
    - name: {{ opensds.dir.hotpot }}/{{ id }}

           {%- endif %}
       {%- endfor %}
  {%- endif %}
