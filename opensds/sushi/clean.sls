###  opensds/sushi/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.deploy_project not in ('gelato',) %}

include:
  - opensds.sushi.daemon.clean
  - opensds.sushi.plugin.clean
  # iscsi.initiator.remove         ### https://github.com/saltstack-formulas/iscsi-formula/issues/12

    {%- endif %}
