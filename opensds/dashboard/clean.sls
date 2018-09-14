### opensds/dashboard/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.dashboard.container.enabled %}
       {%- if opensds.dashboard.container.composed %}

include:
  - opensds.envs.docker.clean

       {#- elif opensds.dashboard.container.build #}
       {%- else %}

opensds dashboard container service stopped:
  docker_container.stopped:
    - name: {{ opensds.dashboard.service }}
    - error_on_absent: False

       {%- endif %}
    {%- elif opensds.dashboard.provider|trim|lower in ('release', 'repo',) %}

include:
  - opensds.dashboard.{{ opensds.dashboard.provider|trim|lower }}.clean

    {% endif %}
