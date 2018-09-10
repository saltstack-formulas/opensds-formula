###  dock/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if opensds.dock.container.enabled %}

opensds dock container service stopped:
  docker_container.stopped:
    - names:
       - {{ opensds.dock.service }}
      {%- if opensds.dock.container.compose and "osdsdock" in docker.compose %}
       - {{ docker.compose.osdsdock.container_name }}
      {%- endif %}
    - error_on_absent: False

  {% endif %}
  {%- if opensds.dock.block.enabled %}

include:
  - opensds.dock.block.clean

  {% endif %}
