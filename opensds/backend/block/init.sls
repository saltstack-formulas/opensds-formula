### opensds/backend/block/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{%- from "opensds/map.jinja" import opensds with context %}

   {%- if opensds.deploy_project not in ('gelato',)  %}

include:
      {%- if grains.os_family not in ('Suse',) %}
  - ceph.repo
      {%- endif %}
  - lvm.install
  - lvm.files.create
  - lvm.pv.create
  - lvm.vg.create
  - lvm.lv.create
  - iscsi.target
  - opensds.backend.block.release
  - opensds.backend.block.repo
  - opensds.backend.block.box
  - opensds.backend.block.daemon

   {%- endif %}
