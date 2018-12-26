###  opensds/dock/block/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds, docker with context %}

include:
  - opensds.dock.block.config


  {%- if opensds.dock.block.lvm.container.enabled %}
    {%- if opensds.dock.block.provider in ('lvm', 'ceph',) %}

opensds dock block {{ opensds.dock.block.provider }} container running:
  docker_container.running:
    - name: {{ opensds.dock.block.service }}
    - image: {{opensds.dock.block.container.image}}:{{opensds.dock.block.container.version}}
    - restart_policy: always
    - network_mode: host
         {%- if "volumes" in opensds.dock.block.container %}
    - binds: {{ opensds.dock.block.container.volumes }}
         {%- endif %}
         {%- if "ports" in opensds.dock.block.container %}
    - port_bindings: {{ opensds.dock.block.container.ports }}
         {%- endif %}
           {%- if docker.containers.skip_translate %}
    - skip_translate: {{ docker.containers.skip_translate or '' }}
           {%- endif %}
           {%- if docker.containers.force_present %}
    - force_present: {{ docker.containers.force_present }}
           {%- endif %}
           {%- if docker.containers.force_running %}
    - force_running: {{ docker.containers.force_running }}
           {%- endif %}

   {%- elif opensds.dock.block.provider == 'cinder' %}
  - opensds.dock.block.cinder

   {%- else %}
  - {{ 'opensds.dock.block.' ~ opensds.dock.block.provider  }}

    {%- endif %}
  {%- endif %}
