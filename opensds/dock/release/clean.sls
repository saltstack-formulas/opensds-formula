###  opensds/dock/release/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "opensds/map.jinja" import opensds with context %}

   {%- if opensds.deploy_project not in ('gelato',)  %}
       {%- for id in opensds.dock.ids %}
           {%- if id in opensds.dock.daemon and "release" in opensds.dock.daemon[id]['strategy']|lower %} 

opensds dock release {{ id }} download directory clean:
  file.absent:
    - name: {{ opensds.dir.hotpot }}/{{ id }}

           {%- endif %}
       {%- endfor %}
  {%- endif %}
