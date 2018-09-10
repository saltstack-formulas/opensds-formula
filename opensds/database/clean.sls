### database/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if opensds.database.container.enabled %}

    {%- if opensds.database.container.custom %}
include:
  - {{ opensds.database.provider|trim|lower }}.docker.stopped    #i.e. etcd.docker.stopped

    {%- else %}
opensds database container service stopped:
  docker_container.stopped:
    - names:
       - {{ opensds.database.service }}
               {%- if opensds.database.container.compose and "osdsdb" in docker.compose %}
       - {{ docker.compose.osdsdb.container_name }}
               {%- endif %}
    - error_on_absent:False
    {%- endif %}

  {%- else %}
include:
  - {{ opensds.database.provider|trim|lower }}.service.stopped    #.ie. etcd.service.stopped

  {% endif %}
