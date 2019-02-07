###  opensds/gelato/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{%- from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.deploy_project not in ('hotpot',)  %}

include:
  - opensds.gelato.daemon.clean
  - opensds.gelato.release.clean
  - opensds.gelato.repo.clean
  - opensds.gelato.config.clean

    {%- endif %}
