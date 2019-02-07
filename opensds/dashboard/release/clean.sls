###  opensds/dashboard/release/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from 'opensds/map.jinja' import opensds with context %}

   {%- if opensds.deploy_project not in ('gelato',)  %}
       {%- for id in opensds.dashboard.ids %}
           {%- if id in opensds.dashboard.daemon and 'release' in opensds.dashboard.daemon[id]['strategy'] %} 

opensds dashboard release {{ id }} download directory clean:
  file.absent:
    - name: {{ opensds.dir.dashboard }}/{{ id }}

           {%- endif %}
       {%- endfor %}
  {%- endif %}
