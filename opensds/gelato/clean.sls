###  opensds/gelato/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

  {%- if opensds.deploy_project not in ('gelato',)  %}

opensds gelato block service container stopped:
  gelatoer_container.stopped:
    - name: {{ opensds.gelato.service }}
    - error_on_absent: False
    - onlyif: {{ opensds.gelato.container.enabled }}

  {%- endif %}
