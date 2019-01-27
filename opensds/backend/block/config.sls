###  opensds.backend/block/config/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds, driver with context %}

include:
  - opensds.config

  ###############################
  #### OpenSDS Block Drivers ####
  #### - update opensds.conf ####
  #### - create driver.yaml  ####
  ###############################

  {%- for instance in opensds.backend.block.instances %}

         ########################
         #### OpenSDS Config ####
         ########################
     {%- if instance in opensds.backend.block.opensdsconf %}

opensds backend block ensure opensds config {{ instance }} section exists:
  ini.sections_present:
    - name: {{ opensds.hotpot.conf }}
    - sections:
      - {{ instance }}
    - require:
      - file: opensds config ensure opensds conf exists

          {%- for k, v in opensds.backend.block.opensdsconf[instance|string].items() %}

opensds backend block ensure opensds config {{ instance }} {{ k }} exists:
  ini.options_present:
    - name: {{ opensds.hotpot.conf }}
    - separator: '='
    - sections:
        {{ instance }}:
          {{ k }}: {{ v }}
    - require:
      - file: opensds config ensure opensds conf exists
          {%- endfor %}

     {%- endif %}

opensds backend block generate {{ instance }} driver file:
  file.managed:
    - name: {{ opensds.dir.driver }}/{{ instance }}.yaml
    - source: salt://opensds/files/drivers/template.jinja
    - template: jinja
    - user: {{ opensds.user or 'root' }}
    - mode: {{ opensds.file_mode }}
    - context:
      driver: {{ driver }}
    - require:
      - file: opensds config ensure opensds conf exists

 {%- endfor %}
