###  opensds/dock/block/cinder/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.dock.block.cinder.container.enabled %}
       {%- if opensds.dock.block.cinder.container.composed %}

include:
  - opensds.envs.docker.clean

       {#- elif opensds.dock.block.cinder.container.build #}
       {%- else %}

opensds dock cinder block service container stopped:
  docker_container.stopped:
    - names: {{ opensds.dock.block.cinder.service }}
    - error_on_absent: False
           {%- if "volumes" in opensds.dock.block.cinder.container %}
    - binds: {{ opensds.dock.block.cinder.container.volumes }}
           {%- endif %}
           {%- if "ports" in opensds.dock.block.cinder.container %}
    - port_bindings: {{ opensds.dock.block.cinder.container.ports }}
           {%- endif %}

       {%- endif %}
    {%- else %}

include:
  - opensds.dock.block.cinder.clean

    {%- endif %}
