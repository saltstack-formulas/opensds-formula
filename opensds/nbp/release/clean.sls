###  opensds/nbp/release/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

opensds nbp release remove archive file from work directory:
  file.absent:
    - name: {{ opensds.dir.tmp }}/{{ opensds.nbp.dir.work }}
    - onlyif: test -d {{ opensds.dir.tmp }}/{{ opensds.nbp.dir.work }}
