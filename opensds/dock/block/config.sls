###  opensds/dock/block/config.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds, driver with context %}

opensds dock block ensure opensds config file exists:
  file.managed:
   - name: {{ opensds.controller.conf }}
   - makedirs: True
   - mode: {{ opensds.dir_mode }}
   - replace: False

    {%- for provider in opensds.dock.block.providers %}

opensds dock block ensure opensds config {{ provider }} section exists:
  ini.sections_present:
    - name: {{ opensds.controller.conf }}
    - sections:
      - {{ provider }}

      {%- for k, v in opensds.dock.block[provider].opensdsconf.items() %}

opensds dock block ensure opensds config {{ provider }} {{ k }} exists:
  ini.options_present:
    - name: {{ opensds.controller.conf }}
    - separator: '='
    - sections:
        {{ provider }}:
          {{ k }}: {{ v }}
    - require:
      - opensds dock block ensure opensds config {{ provider }} section exists

      {%- endfor %}

opensds dock block ensure {{ provider }} driver directories exists:
  file.directory:
    - names:
      - {{ opensds.dir.config }}
      - {{ opensds.dir.work }}/volumegroups
    - force: True
    - user: {{ opensds.user or 'root' }}
    - dir_mode: {{ opensds.dir_mode or '0755' }}
    - recurse:
      - user
      - mode

opensds dock block generate {{ provider }} driver file:
  file.managed:
    - name: {{ opensds.dir.driver }}/{{ provider }}.yaml
    - source: salt://opensds/dock/drivers/template.jinja
    - template: jinja
    - context:
      driver: {{ driver }}
    - require:
      - opensds dock block ensure {{ provider }} driver directories exists

    {%- endfor %}
