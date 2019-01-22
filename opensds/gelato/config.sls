###  opensds/gelato/config.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds with context %}

include:
  - opensds.config

  {%- for instance in opensds.gelato.instances %}

         ########################
         #### OpenSDS Config ####
         ########################
     {%- if instance in opensds.gelato.opensdsconf %}

opensds gelato config ensure opensds conf {{ instance }} section exists:
  ini.sections_present:
    - name: {{ opensds.hotpot.conf }}
    - sections:
      - {{ instance }}

          {%- for k, v in opensds.gelato.opensdsconf[instance|string].items() %}

opensds gelato config ensure opensds conf {{ instance }} {{ k }} exists:
  ini.options_present:
    - name: {{ opensds.hotpot.conf }}
    - separator: '='
    - sections:
        {{ instance }}:
          {{ k }}: {{ v }}
    - require:
      - ini: opensds gelato config ensure opensds conf {{ instance }} section exists
          {%- endfor %}

      {%- endif %}
  {%- endfor %}
