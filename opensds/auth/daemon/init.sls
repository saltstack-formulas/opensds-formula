###  opensds/auth/daemon/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.deploy_project not in ('gelato',)  %}

include:
  - opensds.auth.config
        {%- if "keystone" in opensds.hotpot.opensdsconf.osdslet.auth_strategy|lower %}
  - devstack.cli
        {%- endif %}

    {%- endif %}
