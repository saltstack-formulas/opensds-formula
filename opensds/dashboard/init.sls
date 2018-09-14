### opensds/dashboard/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.dashboard.container.enabled %}
       {%- if opensds.dashboard.container.composed %}

include:
  - opensds.envs.docker

       {#- elif opensds.dashboard.container.build #}
       {%- else %}

opensds dashboard container service running:
  docker_container.running:
    - name: {{ opensds.dashboard.service }}
    - image: {{ opensds.dashboard.container.image }}
    - restart_policy: always
    - network_mode: host
         {%- if "volumes" in opensds.dashboard.container %}
    - binds: {{ opensds.dashboard.container.volumes }}
         {%- endif %}
         {%- if "ports" in opensds.dashboard.container %}
    - port_bindings: {{ opensds.dashboard.container.ports }}
         {%- endif %}

       {%- endif %}
    {%- elif opensds.dashboard.provider|trim|lower in ('release', 'repo',) %}

include:
  - packages.pips
  - packages.pkgs
  - packages.archives
  - opensds.dashboard.{{ opensds.dashboard.provider|trim|lower }}

  #### update opensds.conf ####
        {% for section, configuration in opensds.dashboard.opensds_conf.items() %}

opensds dashboard config ensure dashboard {{ section }} section exists:
  ini.sections_present:
    - name: {{ opensds.controller.conf }}
    - sections:
      - {{ opensds.dashboard.service }}

            {%- for k, v in configuration.items() %}

opensds dashboard config ensure dashboard {{ section }} {{ k }} exists:
  ini.options_present:
    - name: {{ opensds.controller.conf }}
    - separator: '='
    - strict: True
    - sections:
        {{ opensds.dashboard.service }}:
          {{ k }}: {{ v }}
    - require:
      - opensds dashboard config ensure dashboard {{ section }} section exists

            {%- endfor %}
        {% endfor %}
    {% endif %}
