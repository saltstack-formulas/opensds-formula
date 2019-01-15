###  opensds/gelato/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds, golang with context %}

  {%- if opensds.deploy_project not in ('hotpot',) %}

include:
  - opensds.gelato.config
  - opensds.gelato.container
  - opensds.gelato.container.build
  - opensds.gelato.daemon

  {%- endif %}
