###  opensds/dashboard/config.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds with context %}

include:
  - nginx.ng    ### ensure nginx filesystem config exists
  - opensds.config

opensds dashboard config ensure apache dead:
  service.dead:
    - names:
      - apache2
      - nginx

opensds dashboard config ensure apache disabled:
  service.disabled:
    - name:
      - apache2
      - nginx

  {%- for instance in opensds.dashboard.instances %}

         ########################
         #### OpenSDS Config ####
         ########################
     {%- if instance in opensds.dashboard.opensdsconf %}

opensds dashboard config ensure opensds conf {{ instance }} section exists:
  ini.sections_present:
    - name: {{ opensds.hotpot.conf }}
    - sections:
      - {{ instance }}

          {%- for k, v in opensds.dashboard.opensdsconf[instance|string].items() %}

opensds dashboard config ensure opensds conf {{ instance }} {{ k }} exists:
  ini.options_present:
    - name: {{ opensds.hotpot.conf }}
    - separator: '='
    - sections:
        {{ instance }}:
          {{ k }}: {{ v }}
    - require:
      - ini: opensds dashboard config ensure opensds conf {{ instance }} section exists
          {%- endfor %}

      {%- endif %}
  {%- endfor %}
