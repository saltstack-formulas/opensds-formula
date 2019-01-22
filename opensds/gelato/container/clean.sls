#r##  opensds/gelato/container/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds, docker with context %}

  {%- if opensds.deploy_project not in ('hotpot',) %}

     {%- for instance in opensds.gelato.instances %}
       {%- if instance in opensds.gelato.container %}
          {%- set container = opensds.gelato.container[instance|string] %}
          {%- if container.enabled %}

opensds gelato container {{ instance }} service container stopped:
  docker_container.stopped:
    - name: {{ instance }}
    - error_on_absent: False
    - unless: {{ container.build }}
    - require:
      - service: opensds config ensure docker running
  file.absent:
    - name: {{ opensds.dir.hotpot }}/container/{{ instance }}
    - unless: {{ container.build }}

          {%- endif %}
       {%- endif %}
     {%- endfor %}
  {%- endif %}
