#r##  opensds/database/container/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds, etcd with context %}

  {%- for instance in opensds.database.instances %}
     {%- if instance in opensds.database.container and instance not in ('etcd',) %}
        {%- set container = opensds.database.container[instance|string] %}

        {%- if instance == 'etcd' and etcd.docker.enabled %}
           ##########################
           #### START CONTAINERS ####
           ##########################
include:
  - etcd.docker.stopped
  - etcd.remove

        {%- elif instance != 'etcd' and container.enabled %}

opensds database block {{ instance }} service container stopped:
  docker_container.stopped:
    - name: {{ instance }}
    - error_on_absent: False
    - unless: {{ container.build }}
  file.absent:
    - name: {{ opensds.dir.hotpot }}/container/{{ instance }}

        {%- endif %}
    {%- endif %}
  {%- endfor %}
