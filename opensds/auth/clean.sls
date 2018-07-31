# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if "auth" in docker.compose and docker.compose.auth.container_name is defined %}

opensds auth container service stopped:
  docker_container.stopped:
    - names:
       - docker.compose.auth.container_name

  {%- else %}

include:
  - opensds.auth.{{ opensds.auth.provider|trim|lower }}.clean

  {% endif %}
