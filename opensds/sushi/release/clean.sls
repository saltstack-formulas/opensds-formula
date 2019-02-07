###  opensds/sushi/release/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "opensds/map.jinja" import opensds with context %}

   {%- if opensds.deploy_project not in ('gelato',)  %}
       {%- for id in opensds.sushi.ids %}
           {%- if id in opensds.sushi.daemon and "release" in opensds.sushi.daemon[id]['strategy']|lower %} 

opensds sushi release {{ id }} download directory clean:
  file.absent:
    - name: {{ opensds.dir.sushi }}/{{ id }}

           {%- endif %}
       {%- endfor %}
  {%- endif %}
