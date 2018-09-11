### opensds/controller/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if opensds.controller.container.enabled %}
opensds controller container service running:
  docker_container.running:
    - name: {{ opensds.controller.service }}
    - image: {{ opensds.controller.container.image }}
    - restart_policy: always
    - network_mode: host
    - unless: {{ opensds.controller.container.composed }}


  {%- elif opensds.controller.container.composed %}
include:
  - opensds.stacks.dockercompose


  {%- elif opensds.controller.provider|trim|lower in ('release', 'repo',) %}
include:
  - opensds.stacks
  - opensds.controller.{{ opensds.controller.provider|trim|lower }}   #i.e. release or repo

  {% endif %}
