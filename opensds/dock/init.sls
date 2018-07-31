# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if opensds.dock.block.enabled %}

include:
  - opensds.dock.block

  {%- endif %}
