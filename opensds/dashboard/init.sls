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
  {{ '- epel' if grains.os_family in ('Redhat',) else '' }}
  - packages.pips
  - packages.pkgs
  - packages.archives
  - opensds.dashboard.{{ opensds.dashboard.provider|trim|lower }}

  #### update opensds.conf ####
opensds dashboard ensure opensds config file exists:
  file.managed:
   - name: {{ opensds.controller.conf }}
   - makedirs: True
   - mode: '0755'

        {% for section, data in opensds.dashboard.opensdsconf.items() %}

opensds dashboard config ensure dashboard {{ section }} section exists:
  ini.sections_present:
    - name: {{ opensds.controller.conf }}
    - sections:
      - {{ section }}

            {%- for k, v in data.items() %}

opensds dashboard config ensure dashboard {{ section }} {{ k }} exists:
  ini.options_present:
    - name: {{ opensds.controller.conf }}
    - separator: '='
    - strict: True
    - sections:
        {{ section }}:
          {{ k }}: {{ v }}
    - require:
      - opensds dashboard config ensure dashboard {{ section }} section exists

            {%- endfor %}
        {% endfor %}
    {% endif %}
