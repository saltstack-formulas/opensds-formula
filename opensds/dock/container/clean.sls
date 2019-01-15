#r##  opensds/dock/container/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml

{% from "opensds/map.jinja" import opensds with context %}

  {%- for instance in opensds.dock.instances %}
    {%- if instance in opensds.dock.container %}

opensds dock block {{ instance }} service container stopped:
  docker_container.stopped:
    - name: {{ instance }}
    - error_on_absent: False
  file.absent:
    - name: {{ opensds.dir.driver }}/container/{{ instance }}

    {%- endif %}
  {%- endfor %}
