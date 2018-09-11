### opensds/dashboard/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if opensds.dashboard.container.enabled %}

opensds dashboard container service stopped:
  docker_container.stopped:
    - name: {{ opensds.dashboard.service }}
    - error_on_absent: False

  {%- elif opensds.dashboard.container.composed %}

include:
  - opensds.stacks.dockercompose.clean


  {%- elif opensds.controller.provider|trim|lower in ('release', 'repo',) %}

include:
  - opensds.dashboard.clean

  {% endif %}
