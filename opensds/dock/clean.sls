###  opensds/dock/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if opensds.dock.container.enabled %}

opensds dock container service stopped:
  docker_container.stopped:
    - name: {{ opensds.dock.service }}
    - error_on_absent: False

  {%- elif opensds.dock.container.composed %}

include:
  - opensds.stacks.dockercompose.clean

  {% endif %}
  {%- if opensds.dock.block.enabled %}

include:
  - opensds.dock.block.clean

  {% endif %}
