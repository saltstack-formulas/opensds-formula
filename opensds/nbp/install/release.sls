# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

include:
  - packages.archives

opensds nbp copy {{ opensds.nbp.release }} archive file content to work directory:
  file.copy:
    name: {{ opensds.nbp.dir.work }}
    source: /tmp/opensds/opt/opensds-k8s-linux-amd64
    makedirs: True
    force: True
