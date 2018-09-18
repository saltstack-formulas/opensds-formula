###  opensds/dock/block/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

   {%- if opensds.dock.block.ceph.container.enabled %}
       {%- if opensds.dock.block.ceph.container.composed %}

include:
  - opensds.envs.docker

       {#- elif opensds.dock.block.ceph.container.build #}
       {%- else %}

opensds dock block ceph container running:
  docker_container.running:
    - name: {{ opensds.dock.block.ceph.service }}
    - image: {{ opensds.dock.block.ceph.container.image }}
    - restart_policy: always
    - network_mode: host
         {%- if "volumes" in opensds.dock.block.ceph.container %}
    - binds: {{ opensds.dock.block.ceph.container.volumes }}
         {%- endif %}
         {%- if "ports" in opensds.dock.block.ceph.container %}
    - port_bindings: {{ opensds.dock.block.ceph.container.ports }}
         {%- endif %}

       {%- endif %}
    {%- else %}

include:
  {{ '- epel' if grains.os_family in ('Redhat',) else '' }}
  - packages.pips
  - packages.pkgs
  - firewalld
  - ceph.repo
  - deepsea

    {%- endif %}

