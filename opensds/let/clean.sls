# -*- coding: utf-8 -*-
# vim: ft=sls
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if "let" in docker.compose and docker.compose.let.container_name is defined %}

opensds let container service stopped:
  docker_container.stopped:
    - names:
       - docker.compose.let.container_name

  {%- else %}

opensds let kill daemon service:
  process.absent:
    - name: {{ opensds.let.provider }}

  {% endif %}

