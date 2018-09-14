###  opensds/dock/block/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.dock.block.container.enabled %}
       {%- if opensds.dock.block.container.composed %}

include:
  - opensds.envs.docker.clean

       {#- elif opensds.dock.block.container.build #}
       {%- elif opensds.dock.block.provider in ('lvm', 'ceph',) %}

opensds dock block {{ opensds.dock.block.provider }} service container stopped:
  docker_container.stopped:
    - names: {{ opensds.dock.block.service }}
    - error_on_absent: False
           {%- if "volumes" in opensds.dock.block.container %}
    - binds: {{ opensds.dock.block.container.volumes }}
           {%- endif %}
           {%- if "ports" in opensds.dock.block.container %}
    - port_bindings: {{ opensds.dock.block.container.ports }}
           {%- endif %}

       {%- elif opensds.dock.block.provider == 'cinder' %}

include:
  - opensds.dock.block.cinder.clean

       {%- endif %}


