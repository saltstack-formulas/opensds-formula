# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if opensds.dashboard.container.enabled %}

opensds dashboard container service stopped:
  docker_container.stopped:
    - names:
       - {{ opensds.dashboard.service }}
      {%- if opensds.dashboard.container.compose and "osdsdash" in docker.compose %}
       - {{ docker.compose.osdsdash.container_name }}
      {%- endif %}
    - error_on_absent: False

  {% else %}

include:
  - opensds.dashboard.clean

  {% endif %}
