### opensds/database/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.database.container.enabled %}
        {%- if opensds.database.container.composed %}

include:
  - opensds.envs.docker

        {%- elif opensds.database.container.build %}

include:
  - etcd.docker.running

        {%- else %}

opensds database container service running:
  database_container.running:
    - name: {{ opensds.database.service }}
    - image: {{ opensds.database.container.image }}
    - restart_policy: always
    - network_mode: host
           {%- if "volumes" in opensds.database.container %}
    - binds: {{ opensds.database.container.volumes }}
           {%- endif %}
           {%- if "ports" in opensds.database.container %}
    - port_bindings: {{ opensds.database.container.ports }}
           {%- endif %}

        {%- endif %}
    {%- elif opensds.database.provider|trim|lower == 'etcd' %}

include:
  - etcd.service.running

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

        #### update opensds.conf ####
opensds database ensure opensds config file exists:
  file.managed:
    - name: {{ opensds.controller.conf }}
    - makedirs: True
    - user: {{ opensds.user or 'root' }}
    - mode: {{ opensds.file_mode or '0644' }}

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
    {% endif %}
