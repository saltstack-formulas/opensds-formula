# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

include:
  - opensds.dashboard.install.{{ opensds.dashboard.install_from|trim|lower }}
