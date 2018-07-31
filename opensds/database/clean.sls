# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if not opensds.database.container.enabled %}

include:
  - {{ opensds.database.provider|trim|lower }}.service.stopped

  {%- elif opensds.database.container.compose %}

opensds database container service stopped:
  docker_container.stopped:
    - names:
       - docker.compose.database.container_name

  {%- else %}

include:
  - {{ opensds.database.provider|trim|lower }}.docker.stopped

  {% endif %}
