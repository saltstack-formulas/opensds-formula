###  opensds/dock/block/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.dock.block.ceph.container.enabled %}

opensds dock ceph block service container stopped:
  docker_container.stopped:
    - name: {{ opensds.dock.block.ceph.service }}
    - error_on_absent: False

    {%- else %}

include:
  - opensds.dock.block.ceph.clean

    {%- endif %}
