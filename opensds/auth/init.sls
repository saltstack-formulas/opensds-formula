# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if not opensds.auth.container.enabled %}

include:
  - opensds.auth.{{ opensds.auth.provider|trim|lower }}

  {% endif %}
