### auth/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if opensds.auth.container.enabled %}

opensds auth container service running:
  docker_container.running:
    - name: {{ opensds.auth.service }}
    - image: {{ opensds.auth.container.image }}
    - restart_policy: always
    - network_mode: host
    - unless: {{ opensds.auth.container.compose }}

  {% else %}

include:
  - opensds.stacks.devstack
  - opensds.auth.config

  {% endif %}
