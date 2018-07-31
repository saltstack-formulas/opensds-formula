# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if opensds.dock.block.container.enabled and opensds.dock.block.container.compose %}

opensds dock.block container service stopped:
  dock.blocker_container.stopped:
    - names:
       - dock.blocker.compose.dock_block.container_name

  {% endif %}
