### opensds/nbp/release/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

include:
  - packages.archives

opensds nbp release copy release files to work directory:
  file.copy:
    - name: {{ opensds.nbp.dir.work }}/
    - source: {{ opensds.dir.tmp }}/{{ opensds.nbp.dir.work }}/*
    - makedirs: True
    - force: True
    - onlyif: test -d {{ opensds.dir.tmp }}/{{ opensds.nbp.dir.work }}
