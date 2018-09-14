### opensds/auth/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.auth.container.enabled %}
        {%- if opensds.auth.container.composed %}

include:
  - opensds.envs.docker.clean

        {#- elif opensds.auth.container.build #}
        {%- else %}

opensds auth container service stopped:
  docker_container.stopped:
    - name: {{ opensds.auth.service }}
    - error_on_removed: False

        {%- endif %}
    {%- elif opensds.auth.provider in ('keystone', 'devstack',) %}

include:
  - devstack.remove

    {% endif %}

opensds config ensure osdsauth section removed from opensds.conf:
  ini.sections_absent:
    - name: {{ opensds.controller.conf }}
    - sections:
      - {{ opensds.auth.service }}
