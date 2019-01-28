###  opensds/auth/daemon/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.deploy_project not in ('gelato',)  %}

include:
  # devstack.remove
  - opensds.auth.config.clean

    {%- endif %}
