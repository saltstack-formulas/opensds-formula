###  opensds/dock/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{%- from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.deploy_project not in ('gelato',)  %}

include:
  - opensds.dock.daemon.clean
  - opensds.dock.release.clean
  - opensds.dock.repo.clean
  - opensds.dock.config.clean

    {%- endif %}
