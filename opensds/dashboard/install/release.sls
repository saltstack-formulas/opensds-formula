# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

include:
  - packages.archives
  - opensds.env

opensds nbp copy {{ opensds.nbp.release }} archive file content to work directory:
  file.copy:
    name: {{ opensds.nbp.dir.work }}
    source: {{ opensds.dir.tmp }}/{{ opensds.nbp.dir.work }}
    makedirs: True
    force: True
    onlyif: test -d {{ opensds.dir.tmp }}/{{ opensds.nbp.dir.work }}
