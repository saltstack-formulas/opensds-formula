###  opensds/dock/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{%- from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.deploy_project not in ('gelato',)  %}

include:
  - opensds.dock.release
  - opensds.dock.repo
  - opensds.dock.config
  - opensds.dock.drivers
  - opensds.dock.daemon

    {%- endif %}
