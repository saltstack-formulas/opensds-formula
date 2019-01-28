###  opensds/sushi/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{%- from "opensds/map.jinja" import opensds with context %}

   {%- if opensds.deploy_project not in ('gelato',)  %}

include:
  - opensds.sushi.plugin.clean
  - opensds.sushi.config.clean
  - opensds.sushi.release.clean
  - opensds.sushi.repo.clean
  # iscsi.initiator.remove     ### https://github.com/saltstack-formulas/iscsi-formula/issues/12

   {%- endif %}
