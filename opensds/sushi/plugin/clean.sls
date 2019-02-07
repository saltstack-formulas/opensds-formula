###  opensds/sushi/plugin/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{%- from "opensds/map.jinja" import opensds with context %}

   {%- if opensds.deploy_project not in ('gelato',)  %}

include:
  - opensds.sushi.plugin.daemon.clean
  - opensds.sushi.plugin.config.clean

   {%- endif %}
