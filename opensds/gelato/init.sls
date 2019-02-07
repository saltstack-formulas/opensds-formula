###  opensds/gelato/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{%- from "opensds/map.jinja" import opensds with context %}

   {%- if opensds.deploy_project not in ('hotpot',)  %}

include:
  - opensds.gelato.release
  - opensds.gelato.repo
  - opensds.gelato.config
  - opensds.gelato.daemon

   {%- endif %}
