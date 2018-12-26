###  opensds/dock/block/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.dock.block.container.enabled %}
       {%- if opensds.dock.block.provider in ('lvm', 'ceph',) %}

opensds dock block {{ opensds.dock.block.provider }} service container stopped:
  docker_container.stopped:
    - nams: {{ opensds.dock.block.service }}
    - error_on_absent: False

       {%- elif opensds.dock.block.provider == 'cinder' %}

include:
  - opensds.dock.block.cinder.clean

       {%- endif %}
    {%- endif %}
