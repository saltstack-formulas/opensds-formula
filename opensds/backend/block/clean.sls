###  opensds/backend/block/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{%- from "opensds/map.jinja" import opensds with context %}

   {%- if opensds.deploy_project not in ('gelato',)  %}

include:
  - opensds.backend.block.daemon.clean
  - opensds.backend.block.box.clean
  - opensds.backend.block.release.clean
  - opensds.backend.block.repo.clean
  # iscsi.target.remove        #https://github.com/saltstack-formulas/iscsi-formula/issues/12
  - lvm.lv.remove
  - lvm.vg.remove
  - lvm.pv.remove
  - lvm.files.remove

   {%- endif %}
