###  opensds/dashboard/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.deploy_project not in ('gelato',)  %}

include:
  - opensds.dashboard.container.clean
  - opensds.dashboard.daemon.clean

    {%- endif %}
