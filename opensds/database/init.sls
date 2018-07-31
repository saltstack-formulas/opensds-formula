# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if not opensds.database.container.enabled %}

include:
  - {{ opensds.database.provider|trim|lower }}.service.running

  {%- elif opensds.database.container.compose %}

include:
  - {{ opensds.database.provider|trim|lower }}.docker.running

  {% endif %}
