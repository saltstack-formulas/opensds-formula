###  dock/block/lvm/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds with context %}

include:
  - lvm.install
  - lvm.pv.create
  - lvm.vg.create
  - iscsi.target
  - opensds.dock.config

opensds dock block {{ opensds.dock.block.provider }} {{ opensds.dock.release.version }} k8s stop:
  cmd.run:
    - name: {{ opensds.k8s_stop }}
    - onlyif: {{ test -f opensds.k8s_stop }}
    - cwd:  {{ opensds.dock.dir[opensds.dock.block.provider] }}
    - output_loglevel: quiet
