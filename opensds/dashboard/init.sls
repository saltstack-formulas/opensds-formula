###  opensds/dashboard/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{%- from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.deploy_project not in ('gelato',)  %}

include:
  - opensds.dashboard.release
  - opensds.dashboard.repo
  - opensds.dashboard.config
  - apache.uninstall    ### must be installed by stack.sh?
  - opensds.dashboard.daemon

    {%- endif %}
