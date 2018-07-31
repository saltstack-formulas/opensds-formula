# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

include:
  - packages.archives

opensds controller copy {{ opensds.controller.release }} archive content to work directory:
  file.copy:
    name: {{ opensds.dir.work }}
    source: {{ opensds.dir.tmp }}/opt/opensds-linux-amd64 
    makedirs: True
    force: True
