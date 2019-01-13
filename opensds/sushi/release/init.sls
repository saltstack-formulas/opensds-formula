### opensds/sushi/release/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

include:
  - packages.archives

opensds sushi release copy release files to work directory:
  file.copy:
    - name: {{ opensds.sushi.dir.work }}/
    - source: {{ opensds.dir.tmp }}/{{ opensds.sushi.dir.work }}/*
    - makedirs: True
    - force: True
    - onlyif: test -d {{ opensds.dir.tmp }}/{{ opensds.sushi.dir.work }}
