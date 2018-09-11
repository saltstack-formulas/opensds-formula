###  opensds/dock/block/ceph/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

include:
  - deepsea.remove
