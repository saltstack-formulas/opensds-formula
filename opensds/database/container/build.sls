###  opensds/database/container/build.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds, docker, etcd with context %}

  {%- for instance in opensds.database.instances %}
     {%- if instance in opensds.database.container %}
        {%- set container = opensds.database.container[ instance|string ] %}

            ##########################
            #### BUILD CONTAINERS ####
            ##########################
        {%- if container.enabled and container.build %}
            {%- if instance == 'etcd' and etcd.docker.enabled %}
include:
  - etcd.install
  - etcd.docker.running

            {%- elif instance != 'etcd' %}

opensds database container {{ instance }} build:
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
      - file: opensds database container {{ instance }} build

            {%- endif %}
        {%- endif %}

     {%- endif %}
  {%- endfor %}
