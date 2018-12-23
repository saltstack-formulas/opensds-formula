### opensds/database/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}


    {%- if opensds.database.container.enabled %}

include:
  - etcd.docker.running

    {%- elif opensds.database.provider|trim|lower == 'etcd' %}

include:
  - etcd.service.running

    {%- endif %}


### opensds.conf ###

opensds database ensure opensds dirs exist:
  file.directory:
    - names:
      {%- for k, v in opensds.dir.items() %}
      - {{ v }}
      {%- endfor %}
    - makedirs: True
    - force: True
    - user: {{ opensds.user or 'root' }}
    - dir_mode: {{ opensds.dir_mode or '0755' }}
    - recurse:
      - user
      - mode

opensds database ensure opensds config file exists:
  file.managed:
    - name: {{ opensds.controller.conf }}
    - makedirs: True
    - user: {{ opensds.user or 'root' }}
    - mode: {{ opensds.file_mode or '0644' }}
    - replace: False

        {% for section, data in opensds.database.opensdsconf.items() %}

opensds database ensure opensds config {{ section }} section exists:
  ini.sections_present:
    - name: {{ opensds.controller.conf }}
    - sections:
      - {{ section }}

           {%- for k, v in data.items() %}
opensds database ensure opensds config {{ section }} {{ k }} exists:
  ini.options_present:
    - name: {{ opensds.controller.conf }}
    - separator: '='
    - sections:
        {{ section }}:
          {{ k }}: {{ v }}
    - require:
      - opensds database ensure opensds config {{ section }} section exists
           {%- endfor %}

        {%- endfor %}
