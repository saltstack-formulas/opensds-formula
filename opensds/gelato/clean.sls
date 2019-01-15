###  opensds/gelato/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

  {%- if opensds.deploy_project not in ('hotpot',) %}

include:
  - opensds.gelato.container.clean
  - opensds.gelato.daemon.clean

  {%- endif %}

