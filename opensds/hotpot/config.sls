###  opensds/hotpot/config.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds with context %}

include:
  - opensds.config

  {%- for instance in opensds.hotpot.instances %}

         ########################
         #### OpenSDS Config ####
         ########################
     {%- if instance in opensds.hotpot.opensdsconf %}

opensds hotpot config ensure opensds conf {{ instance }} section exists:
  ini.sections_present:
    - name: {{ opensds.hotpot.conf }}
    - sections:
      - {{ instance }}

         {%- for k, v in opensds.hotpot.opensdsconf[instance|string].items() %}

opensds hotpot config ensure opensds conf {{ instance }} {{ k }} exists:
  ini.options_present:
    - name: {{ opensds.hotpot.conf }}
    - separator: '='
    - sections:
        {{ instance }}:
          {{ k }}: {{ v }}
    - require:
      - ini: opensds hotpot config ensure opensds conf {{ instance }} section exists
         {%- endfor %}

     {%- endif %}
  {%- endfor %}
