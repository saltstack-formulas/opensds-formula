# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

include:
  - opensds.salt
     {%- if opensds.dashboard.container.enabled %}
  - docker.compose-ng
     {%- else %}
  - opensds.dashboard
     {%- endif %}
