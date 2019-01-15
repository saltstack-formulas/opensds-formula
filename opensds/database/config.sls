###  opensds/database/config.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds with context %}

include:
  - opensds.config

  {%- for instance in opensds.database.instances %}

         ########################
         #### OpenSDS Config ####
         ########################
     {%- if instance in opensds.database.opensdsconf %}

opensds database config ensure opensds conf {{ instance }} section exists:
  ini.sections_present:
    - name: {{ opensds.hotpot.conf }}
    - sections:
      - {{ instance }}

         {%- for k, v in opensds.database.opensdsconf[instance|string].items() %}

opensds database config ensure opensds conf {{ instance }} {{ k }} exists:
  ini.options_present:
    - name: {{ opensds.hotpot.conf }}
    - separator: '='
    - sections:
        {{ instance }}:
          {{ k }}: {{ v }}
    - require:
      - ini: opensds database config ensure opensds conf {{ instance }} section exists
         {%- endfor %}

     {%- endif %}
  {%- endfor %}
