### opensds/auth/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

include:
  - opensds.auth.config

  {%- if opensds.auth.container.enabled %}

opensds auth container service running:
  docker_container.running:
    - name: {{ opensds.auth.service }}
    - image: {{ opensds.auth.container.image }}
    - restart_policy: always
    - network_mode: host
    - unless: {{ opensds.auth.container.compose }}

  {% elif opensds.auth.container.composed %}
  - opensds.stacks

  {%- else %}
  - opensds.stacks.devstack

  {% endif %}
