# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if opensds.controller.install_from|trim|lower in ('release', 'repo',) %}

include:
  - opensds.controller.install.{{ opensds.controller.install_from|trim|lower }}

  {%- endif %}
