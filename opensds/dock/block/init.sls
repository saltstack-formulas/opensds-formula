###  opensds/dock/block/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

   {%- if opensds.dock.block.container.enabled %}
       {%- if opensds.dock.block.container.composed %}

include:
  - opensds.envs.docker

       {#- elif opensds.dock.block.container.build #}
       {%- elif opensds.dock.block.provider in ('lvm', 'ceph',) %}

opensds dock block {{ opensds.dock.block.provider }} container running:
  docker_container.running:
    - name: {{ opensds.dock.block.service }}
    - image: {{ opensds.dock.block.container.image }}
    - restart_policy: always
    - network_mode: host
         {%- if "volumes" in opensds.dock.block.container %}
    - binds: {{ opensds.dock.block.container.volumes }}
         {%- endif %}
         {%- if "ports" in opensds.dock.block.container %}
    - port_bindings: {{ opensds.dock.block.container.ports }}
         {%- endif %}

       {%- elif opensds.dock.block.provider == 'cinder' %}

include:
  - opensds.dock.block.cinder
  - opensds.dock.block.config

       {%- endif %}
   {%- else %}

include:
  - opensds.dock.block[ opensds.dock.block.provider ]
  - opensds.dock.block.config

   {%- endif %}
