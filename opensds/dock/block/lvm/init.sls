###  opensds/dock/block/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

   {%- if opensds.dock.block.lvm.container.enabled %}
       {%- if opensds.dock.block.lvm.container.composed %}

include:
  - opensds.envs.docker

       {%- else %}

opensds dock block lvm container running:
  docker_container.running:
    - name: {{ opensds.dock.block.lvm.service }}
    - image: {{ opensds.dock.block.lvm.container.image }}
    - restart_policy: always
    - network_mode: host
         {%- if "volumes" in opensds.dock.block.lvm.container %}
    - binds: {{ opensds.dock.block.lvm.container.volumes }}
         {%- endif %}
         {%- if "ports" in opensds.dock.block.lvm.container %}
    - port_bindings: {{ opensds.dock.block.lvm.container.ports }}
         {%- endif %}

       {%- endif %}
    {%- elif opensds.dock.block.lvm.build %}

    {%- else %}

include:
  - lvm.install
  - lvm.files.create
  - lvm.pv.create
  - lvm.vg.create
  - lvm.lv.create
  - iscsi.target

    {%- endif %}

