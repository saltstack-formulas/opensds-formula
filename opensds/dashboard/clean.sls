###  opensds/dashboard/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{%- from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.deploy_project not in ('gelato',)  %}

include:
  - opensds.dashboard.daemon.clean
  - opensds.dashboard.release.clean
  - opensds.dashboard.repo.clean
  - opensds.dashboard.config.clean

    {%- endif %}
