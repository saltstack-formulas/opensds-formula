###  opensds/dock/container/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds, docker with context %}

include:
  - opensds.dock.config

opensds dock container ensure docker running:
  service.running:
    - name: docker
    - enable: True
  #cmd.run:
  #  - name: echo $DOCKER_PASS | docker login -u$DOCKER_USER --password-stdin $DOCKER_HOST


       ##############################
       #### START DOCK CONTAINER ####
       ##############################

  {%- for instance in opensds.dock.instances %}
    {%- if instance in opensds.dock.container %}
      {%- set container = opensds.dock.container[ instance|string ] %}

      {%- if container.enabled %}

opensds dock container {{ instance }} running:
  file.directory:
    - name: {{ opensds.dir.driver }}/container/{{ instance }}
    - makedirs: True
    - onlyif: {{ container.build }}
  cmd.run:
    - name: {{ opensds.dock.container[ instance|string ]['build_cmd'] }}
    - cwd: {{ opensds.dir.driver }}/container/{{ instance }}
    - require:
      - service: opensds dock container ensure docker running
      - file: opensds dock container {{ instance }} running
    - onlyif: {{ container.build }}
  docker_container.running:
    - name: {{ instance }}
    - image: {{ container['image'] }}:{{ container['version'] }}
    - restart_policy: always
    - network_mode: host
         {%- if "volumes" in container %}
    - binds: {{ container['volumes'] }}
         {%- endif %}
         {%- if "ports" in container %}
    - port_bindings: {{ container['ports'] }}
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
    - require:
      - service: opensds dock container ensure docker running

      {%- endif %}
    {%- endif %}
  {%- endfor %}
