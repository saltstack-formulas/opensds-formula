###  opensds/backend/block/container/build.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

include:
  - opensds.backend.block.config

  {%- for instance in opensds.backend.block.instances %}
     {%- if instance in opensds.backend.block.container %}
        {%- set container = opensds.backend.block.container[ instance|string ] %}

           ##########################
           #### BUILD CONTAINERS ####
           ##########################
        {%- if container.enabled and container.build %}

opensds backend block container {{ instance }} build:
  file.directory:
    - name: {{ opensds.dir.hotpot }}/container/{{ instance }}
    - makedirs: True
    - force: True
    - user: {{ opensds.user or 'root' }}
    - dir_mode: {{ opensds.dir_mode or '0755' }}
    - recurse:
      - user
      - mode
  cmd.run:
    - name: {{ container.build_cmd }}
    - cwd: {{ opensds.dir.hotpot }}/container/{{ instance }}
    - require:
      - service: opensds config ensure docker running
      - file: opensds backend.block container {{ instance }} running
    - require:
      - service: opensds config ensure docker running
    - unless: {{ not container.build_cmd }}

        {%- endif %}
     {%- endif %}
  {%- endfor %}
