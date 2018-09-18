###  opensds/dock/block/config.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds with context %}

opensds dock block ensure opensds config file exists:
  file.managed:
   - name: {{ opensds.controller.conf }}
   - makedirs: True
   - mode: '0755'

    {% set provider = opensds.dock.block.provider %}
    {% for section, data in opensds.dock.block[provider].opensdsconf.items() %}

opensds dock block ensure opensds config {{ section }} section exists:
  ini.sections_present:
    - name: {{ opensds.controller.conf }}
    - sections:
      - {{ section }}

        {%- for k, v in data.items() %}

opensds dock block ensure opensds config {{ section }} {{ k }} exists:
  ini.options_present:
    - name: {{ opensds.controller.conf }}
    - separator: '='
    - strict: True
    - sections:
        {{ section }}:
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
    - source: salt://opensds/dock/drivers/template.jinja
    - template: jinja
    - context:
      swordfish: {{ opensds.swordfish }}
    - require:
      - opensds dock block ensure {{ provider }} driver directories exists

