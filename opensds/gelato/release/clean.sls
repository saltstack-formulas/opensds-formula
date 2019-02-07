###  opensds/gelato/release/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from 'opensds/map.jinja' import opensds with context %}

   {%- if opensds.deploy_project not in ('hotpot',)  %}
       {%- for id in opensds.gelato.ids %}
           {%- if id in opensds.gelato.daemon and 'release' in opensds.gelato.daemon[id]['strategy']|lower %} 

opensds gelato release {{ id }} download directory clean:
  file.absent:
    - name: {{ opensds.dir.gelato }}/{{ id }}

           {%- endif %}
       {%- endfor %}
  {%- endif %}
