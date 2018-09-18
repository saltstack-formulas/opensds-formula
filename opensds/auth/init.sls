### opensds/auth/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.auth.container.enabled %}
        {%- if opensds.auth.container.composed %}

include:
  - opensds.envs.docker

        {#- elif opensds.auth.container.build #}
        {%- else %}

opensds auth container service running:
  docker_container.running:
    - name: {{ opensds.auth.service }}
    - image: {{ opensds.auth.container.image }}
    - restart_policy: always
    - network_mode: host
         {%- if "volumes" in opensds.auth.container %}
    - binds: {{ opensds.auth.container.volumes }}
         {%- endif %}
         {%- if "ports" in opensds.auth.container %}
    - port_bindings: {{ opensds.auth.container.ports }}
         {%- endif %}

       {%- endif %}
    {% else %}

include:
  - devstack.user          #https://github.com/saltstack-formulas/devstack-formula
  - devstack.install
  - devstack.cli

    {% endif %}

    #### update opensds.conf ####
opensds auth ensure opensds config file exists:
  file.managed:
   - name: {{ opensds.controller.conf }}
   - mode: '0755'

    {% for section, data in opensds.auth.opensdsconf.items() %}

opensds auth config ensure osdsauth {{ section }} section exists:
  ini.sections_present:
    - name: {{ opensds.controller.conf }}
    - sections:
      - {{ section }}

        {%- for k, v in data.items() %}

opensds auth config ensure osdsauth {{ section }} {{ k }} exists:
  ini.options_present:
    - name: {{ opensds.controller.conf }}
    - separator: '='
    - strict: True
    - sections:
        {{ section }}:
          {{ k }}: {{ v }}
    - require:
      - opensds auth config ensure osdsauth {{ section }} section exists

        {%- endfor %}
    {% endfor %}
