###  let/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

 {%- if opensds.let.container.enabled %}

opensds let {{ opensds.controller.release }} container service stopped:
  docker_container.stopped:
    - names:
       - {{ opensds.let.service }}
      {%- if opensds.let.container.compose and "osdslet" in docker.compose %}
       - {{ docker.compose.osdslet.container_name }}
      {%- endif %}
    - error_on_absent:False

  {%- else %}

opensds let {{ opensds.controller.release }} kill daemon service:
  process.absent:
    - name: {{ opensds.let.service }}

  {% endif %}

