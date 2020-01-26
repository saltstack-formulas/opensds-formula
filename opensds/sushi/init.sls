###  opensds/sushi/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{%- from "opensds/map.jinja" import opensds with context %}

   {%- if opensds.deploy_project not in ('gelato',)  %}

include:
  - iscsi.initiator
  - kubernetes.kubectl
  - opensds.sushi.release
  - opensds.sushi.repo
  - opensds.sushi.config
  - opensds.sushi.plugin

   {%- endif %}
