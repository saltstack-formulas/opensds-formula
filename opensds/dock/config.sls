###  opensds/dock/config/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds with context %}


opensds dock config ensure driver directories exists:
  file.directory:
    - names:
      - {{ opensds.dir.hotpot }}/volumegroups
    - force: True
    - user: {{ opensds.user or 'root' }}
    - dir_mode: {{ opensds.dir_mode or '0755' }}
    - recurse:
      - user
      - mode

opensds dock config ensure opensds conf file exists:
  file.managed:
   - name: {{ opensds.hotpot.conf }}
   - makedirs: True
   - mode: {{ opensds.dir_mode }}
   - replace: False


  {%- for instance in opensds.dock.instances %}

         ########################
         #### OpenSDS Config ####
         ########################
     {%- if instance in opensds.dock.opensdsconf %}

opensds dock config ensure opensds conf {{ instance }} section exists:
  ini.sections_present:
    - name: {{ opensds.hotpot.conf }}
    - sections:
      - {{ instance }}

          {%- for k, v in opensds.dock.opensdsconf[instance|string].items() %}

opensds dock config ensure opensds conf {{ instance }} {{ k }} exists:
  ini.options_present:
    - name: {{ opensds.hotpot.conf }}
    - separator: '='
    - sections:
        {{ instance }}:
          {{ k }}: {{ v }}
    - require:
      - ini: opensds dock config ensure opensds conf {{ instance }} section exists
          {%- endfor %}

      {%- endif %}
  {%- endfor %}
