###  opensds/hotpot/repo/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

opensds hotpot repo remove directories:
  file.absent:
    - name: {{ opensds.dir.work }}/hotpot

