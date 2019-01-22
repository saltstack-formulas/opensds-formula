###  opensds/dashboard/container/build.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

include:
  - opensds.config

  {%- for instance in opensds.dashboard.instances %}
     {%- if instance in opensds.dashboard.container %}
        {%- set container = opensds.dashboard.container[ instance|string ] %}

        {%- if container.enabled and container.build %}
           ##########################
           #### BUILD CONTAINERS ####
           ##########################

opensds dashboard container {{ instance }} build:
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
      - file: opensds dashboard container {{ instance }} running
    - require:
      - service: opensds config ensure docker running

        {%- endif %}
     {%- endif %}
  {%- endfor %}
