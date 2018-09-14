### opensds/database/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.database.container.enabled %}
        {%- if opensds.database.container.composed %}

include:
  - opensds.envs.database

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

        #### update opensds.conf ####
        {% for section, conf in opensds.database.opensds_conf.items() %}

opensds database ensure opensds config {{ section }} section exists:
  ini.sections_present:
    - name: {{ opensds.controller.conf }}
    - sections:
      - {{ opensds.database.service }}

           {%- for k, v in conf.items() %}

opensds database ensure opensds config {{ section }} {{ k }} exists:
  ini.options_present:
    - name: {{ opensds.controller.conf }}
    - separator: '='
    - strict: True
    - sections:
        {{ opensds.database.service }}:
          {{ k }}: {{ v }}
    - require:
      - opensds database ensure opensds config {{ section }} section exists

           {%- endfor %}
        {%- endfor %}
    {% endif %}
