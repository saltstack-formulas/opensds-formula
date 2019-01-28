###  opensds/backend/block/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

   {%- if opensds.deploy_project not in ('gelato',)  %}

include:
  - ceph.repo
  - lvm.install
  - lvm.files.create
  - lvm.pv.create
  - lvm.vg.create
  - lvm.lv.create
  - iscsi.target
  - opensds.backend.block.config
  - opensds.backend.block.daemon
  - opensds.backend.block.container.build
  - opensds.backend.block.container.init

   {%- endif %}
