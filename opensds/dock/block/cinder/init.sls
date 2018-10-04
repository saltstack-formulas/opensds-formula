###  opensds/dock/block/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds, docker with context %}
{% from "opensds/files/macros.jinja" import getlist with context %}

    {%- if opensds.dock.block.cinder.container.enabled %}
       {%- if opensds.dock.block.cinder.container.composed %}

include:
  - opensds.envs.docker

       {%- elif opensds.dock.block.cinder.container.build %}

include:
  - packages.archives
  - opensds.dock.block.lvm

opensds dock block cinder loci packages:
  pkg.installed:
    - pkgs: {{ getlist(opensds.pkgs, true) }}

opensds dock block cinder loci ensure docker service running:
  service.running:
    - name: docker
    - enable: True

opensds dock block cinder loci build from source:
  file.directory:
    - name: {{ opensds.dir.tmp }}/{{ opensds.dir.work }}/cinder
    - makedirs: True
  cmd.run:
    - cwd: {{ packages.archives.wanted.cinder.dest }}
    - name: {{ opensds.dock.block.cinder.container.build }}
    - onlyif: echo $DOCKER_PASS | docker login -u$DOCKER_USER --password-stdin $DOCKER_HOST

       {%- else %}

opensds dock block cinder container running:
  docker_container.running:
    - name: {{ opensds.dock.block.cinder.service }}
    - image: {{ opensds.dock.block.cinder.container.image }}
    - restart_policy: always
    - network_mode: host
         {%- if "volumes" in opensds.dock.block.cinder.container %}
    - binds: {{ opensds.dock.block.cinder.container.volumes }}
         {%- endif %}
         {%- if "ports" in opensds.dock.block.cinder.container %}
    - port_bindings: {{ opensds.dock.block.cinder.container.ports }}
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

       {%- endif %}
    {#- else #}
    {%- endif %}
