###  opensds/dock/block/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.dock.block.ceph.container.enabled %}
       {%- if opensds.dock.block.ceph.container.composed %}

include:
  - opensds.envs.docker.clean

       {#- elif opensds.dock.block.ceph.container.build #}
       {%- else %}

opensds dock ceph block service container stopped:
  docker_container.stopped:
    - names: {{ opensds.dock.block.ceph.service }}
    - error_on_absent: False

       {%- endif %}
    {%- else %}

include:
  - opensds.dock.block.ceph.clean

    {%- endif %}
