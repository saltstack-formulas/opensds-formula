###  opensds/auth/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{%- from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.deploy_project not in ('gelato',)  %}

include:
  - opensds.auth.daemon.clean
  - opensds.auth.config.clean

    {%- endif %}
