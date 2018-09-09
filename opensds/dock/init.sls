# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if opensds.dock.container.enabled %}

opensds dock container service running:
  docker_container.running:
    - name: {{ opensds.dock.service }}
    - image: {{ opensds.dock.container.image }}
    - restart_policy: always
    - network_mode: host
    - unless: {{ opensds.dock.container.compose }}

  {%- endif %}
  {%- if opensds.dock.block.enabled %}

include:
  - opensds.dock.block

  {%- endif %}

