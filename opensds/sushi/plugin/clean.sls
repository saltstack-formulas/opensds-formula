###  opensds/sushi/plugin/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds, driver with context %}


  {%- for instance in opensds.sushi.instances %}

         ##############################
         #### OpenSDS opensds.conf ####
         ##############################
     {%- if "opensdsconf" in opensds.sushi and instance in opensds.sushi.opensdsconf %}
        {%- set plugin = opensds.sushi.opensdsconf[ instance|string ] %}

        {%- for k, v in plugin.items() %}
opensds sushi plugin {{ instance }} ensure opensds config {{ instance }} {{ k }} absent:
  ini.options_absent:
    - name: {{ opensds.hotpot.conf }}
    - require:
      - file: opensds config ensure opensds conf exists
    - sections:
        {{ instance }}:
          - {{ k }}
    - separator: '='
        {%- endfor %}

opensds sushi plugin {{ instance }} ensure opensds config {{ instance }} section absent:
  ini.sections_absent:
    - name: {{ opensds.hotpot.conf }}
    - sections:
      - {{ instance }}
    - require:
      - file: opensds config ensure opensds conf exists
    - separator: '='

     {%- endif %}


          ###################################
          #### Plugin directory and file ####
          ###################################
     {%- if opensds.sushi.plugin and instance in opensds.sushi.plugin %}
        {%- set plugin = opensds.sushi.plugin[ instance|string ] %}

opensds sushi plugin {{ instance }} file absent:
  file.absent:
    - names:
      - {{ plugin['dir'] }}/opensds/{{ plugin['file'] }}
      - {{ plugin['dir'] }}/{{ plugin['file'] }}

     {%- endif %}
  {%- endfor %}
