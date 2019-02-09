###  opensds/dashboard/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{%- from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.deploy_project not in ('gelato',)  %}

include:
  - opensds.dashboard.release
  - opensds.dashboard.repo
  - opensds.dashboard.config
  - apache.uninstall    ### coming from stack.sh?
  - nginx.ng.service    ### used by dashboard service
  - opensds.dashboard.daemon

    {%- endif %}
