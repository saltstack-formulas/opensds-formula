### opensds/sushi/plugin/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{%- from "opensds/map.jinja" import opensds with context %}

   {%- if opensds.deploy_project not in ('gelato',)  %}

include:
  - opensds.sushi.plugin.config
  - opensds.sushi.plugin.daemon

   {%- endif %}
