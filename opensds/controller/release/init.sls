### opensds/controller/release/init.sls
 # -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

include:
  - opensds.stacks

opensds controller release {{ opensds.controller.release }} copy archive content to work directory:
  file.copy:
    name: {{ opensds.dir.work }}
    source: {{ opensds.dir.tmp }}/{{ opensds.dir.work }}
    makedirs: True
    force: True
    onlyif: test -d {{ opensds.dir.tmp }}/{{ opensds.dir.work }}
