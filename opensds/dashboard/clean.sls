###  opensds/dashboard/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{%- from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.deploy_project not in ('gelato',)  %}

include:
  - opensds.dashboard.daemon.clean
  - apache.uninstall      ### manages port 80
  # nginx.ng.clean        ### https://github.com/saltstack-formulas/nginx-formula/issues/214
  - opensds.dashboard.release.clean
  - opensds.dashboard.repo.clean
  - opensds.dashboard.config.clean

    {%- endif %}
