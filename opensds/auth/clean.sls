# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if opensds.auth.container.enabled %}

opensds auth container service stopped:
  docker_container.stopped:
    - names:
       - {{ opensds.auth.service }}
      {%- if opensds.auth.container.compose and "osdsauth" in docker.compose %}
       - {{ docker.compose.osdsauth.container_name }}
      {%- endif %}
    - error_on_absent:False

  {%- else %}

include:
  - opensds.auth.{{ opensds.auth.provider|trim|lower }}.clean

  {% endif %}
