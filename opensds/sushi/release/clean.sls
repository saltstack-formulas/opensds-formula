###  opensds/sushi/release/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

opensds sushi release remove archive file from work directory:
  file.absent:
    - name: {{ opensds.dir.tmp }}/{{ opensds.sushi.dir.work }}
    - onlyif: test -d {{ opensds.dir.tmp }}/{{ opensds.sushi.dir.work }}
