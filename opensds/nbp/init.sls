# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if not opensds.nbp.container.enabled %}

include:
  - opensds.nbp.install.{{ opensds.nbp.install_from }}

  {%- endif %}
