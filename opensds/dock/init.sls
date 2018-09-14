###  opensd/dock/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.dock.container.enabled %}
       {%- if opensds.dock.container.composed %}

include:
  - opensds.envs.docker

       {#- elif opensds.dock.container.build #}
       {%- else %}

opensds dock container service running:
  docker_container.running:
    - name: {{ opensds.dock.service }}
    - image: {{ opensds.dock.container.image }}
    - restart_policy: always
    - network_mode: host
          {%- if "volumes" in opensds.dock.container %}
    - binds: {{ opensds.dock.container.volumes }}
          {%- endif %}
          {%- if "ports" in opensds.dock.container %}
    - port_bindings: {{ opensds.dock.container.ports }}
          {%- endif %}

       {%- endif %}
    {%- endif %}
    {%- if opensds.dock.block.enabled %}

include:
  - opensds.dock.block

       #### update opensds.conf ####
       {% for section, conf in opensds.dock.opensds_conf.items() %}

opensds dock ensure opensds config {{ section }} section exists:
  ini.sections_present:
    - name: {{ opensds.contorller.conf }}
    - sections:
      - {{ opensds.dock.service }}

            {%- for k, v in conf.items() %}
opensds dock ensure opensds config {{ section }} {{ k }} exists:
  ini.options_present:
    - name: {{ opensds.controller.conf }}
    - separator: '='
    - strict: True
    - sections:
        {{ opensds.dock.service }}:
          {{ k }}: {{ v }}
    - require:
      - opensds dock ensure opensds config {{ section }} section exists
            {%- endfor %}

       {%- endfor %}
    {%- endif %}
