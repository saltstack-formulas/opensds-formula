###  opensds/dock/block/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.dock.block.lvm.container.enabled %}

opensds dock lvm block service container stopped:
  docker_container.stopped:
    - name: {{ opensds.dock.block.lvm.service }}
    - error_on_absent: False

    {%- elif opensds.dock.block.lvm.build %}

include:
  - lvm.lv.remove
  - lvm.vg.remove
  - lvm.pv.remove
  - lvm.files.remove
  - iscsi.target.remove

    {%- endif %}
