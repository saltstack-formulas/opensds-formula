###  opensds/gelato/repo/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from 'opensds/map.jinja' import opensds with context %}

   {%- if opensds.deploy_project not in ('hotpot',)  %}
       {%- for id in opensds.gelato.ids %}

opensds gelato repo {{ id }} ensure directory removed:
  file.absent:
    - name: {{ opensds.dir.gelato + '/' + id }}

       {%- endfor %}
   {%- endif %}
