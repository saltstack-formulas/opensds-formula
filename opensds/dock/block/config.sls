###  dock/block/config.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds with context %}

{% set provider = opensds.dock.block.provider %}
  {% for section, conf in opensds.dock.block.conf.opensds.items() if provider %}

opensds dock block ensure opensds config {{ section }} section exists:
  ini.sections_present:
    - name: {{ opensds.conf }}
    - sections:
      - dock

      {%- for k, v in conf.items() %}
opensds dock block ensure opensds config {{ section }} {{ k }} exists:
  ini.options_present:
    - name: {{ opensds.conf }}
    - separator: '='
    - strict: True
    - sections:
        dock:
          {{ k }}: {{ v }}
    - require:
      - opensds dock block ensure opensds config {{ section }} section exists
      {%- endfor %}
  {%- endfor %}

opensds dock block ensure {{ provider }} driver directories exists:
  file.directory:
    - names:
      - {{ opensds.dir.config }}
      - {{ opensds.dir.work }}/volumegroups
    - force: True
    - user: {{ opensds.dir.user }}
    - dir_mode: {{ opensds.dir.mode }}
    - recurse:
      - user
      - mode

opensds dock block generate {{ provider }} driver file:
  file.managed:
    - name: {{ opensds.dir.driver }}/{{ provider }}.yaml
    - source: salt://opensds/dock/block/driver/template.jinja
    - template: jinja
    - context:
      swordfish: {{ opensds.swordfish }}
    - require:
      - opensds dock block ensure {{ provider }} driver directories exists

opensds dock block generate {{ provider }} volume group:
  script.run:
    - source: salt://opensds/files/lvm.sh
    - require:
      - opensds dock block generate the {{ provider }} driver file


