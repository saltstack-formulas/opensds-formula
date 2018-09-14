### opensds/controller/release/init.sls
 # -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

include:
  - opensds.envs

opensds controller release {{ opensds.controller.release }} copy release files into work directory:
  file.copy:
    name: {{ opensds.dir.work }}/
    source: {{ opensds.dir.tmp }}/{{ opensds.dir.work }}/*
    makedirs: True
    force: True
    onlyif: test -d {{ opensds.dir.tmp }}/{{ opensds.dir.work }}
