### opensd/dock/block/lvm/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds with context %}

include:
  - lvm.files
  - lvm.pv.create
  - lvm.vg.create
  - lvm.pv.create
  - iscsi.target
