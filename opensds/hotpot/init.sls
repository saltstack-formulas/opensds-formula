###  opensds/hotpot/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{%- from "opensds/map.jinja" import opensds with context %}

   {%- if opensds.deploy_project not in ('gelato',)  %}

include:
  - opensds.hotpot.release
  - opensds.hotpot.repo
  - opensds.hotpot.config
  - opensds.hotpot.daemon

   {%- endif %}
