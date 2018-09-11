### opensds/dashboard/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

   {%- if opensds.dashboard.container.enabled %}

opensds dashboard container service running:
  docker_container.running:
    - name: {{ opensds.dashboard.service }}
    - image: {{ opensds.dashboard.container.image }}
    - restart_policy: always
    - network_mode: host
    - unless: {{ opensds.dashboard.container.composed }}

  {%- elif opensds.dashboard.container.composed %}

include:
  - opensds.stacks.dockercompose

  {%- elif opensds.dashboard.provider|trim|lower in ('release', 'repo',) %}

include:
  - opensds.stacks
  - opensds.dashboard.{{ opensds.dashboard.provider|trim|lower }}   #i.e. release or repo

  {% endif %}
