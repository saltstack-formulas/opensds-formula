##  opensds/backend/block/container/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds, docker with context %}

  {%- for instance in opensds.backend.block.instances %}
    {%- if instance in opensds.backend.block.container %}
       {%- set container = opensds.backend.block.container[ instance|string ] %}
       {%- if container.enabled and container.build %}

opensds backend.block container {{ instance }} service removed:
  docker_container.stopped:
    - name: {{ instance }}
    - error_on_absent: False
    - require:
      - service: opensds config ensure docker running
    - unless: {{ container.build }}
  file.absent:
    - name: {{ opensds.dir.hotpot }}/container/{{ instance }}

       {%- endif %}
    {%- endif %}
  {%- endfor %}
