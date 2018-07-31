# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if opensds.dock.container.enabled and opensds.dock.container.compose %}

opensds dock container service stopped:
  docker_container.stopped:
    - names:
       - docker.compose.dock.container_name

  {% endif %}
  {%- if opensds.dock.block.enabled %}

include:
  - opensds.dock.block.clean

  {% endif %}
