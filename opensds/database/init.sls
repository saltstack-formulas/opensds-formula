# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if opensds.database.container.enabled %}

     {%- if opensds.database.container.custom %}
include:
  - {{ opensds.database.provider|trim|lower }}.docker.running    #i.e. 'etcd.docker.running'

     {%- else %}
opensds database container service running:
  docker_container.running:
    - name: {{ opensds.database.service }}
    - image: {{ opensds.database.container.image }}
    - restart_policy: always
    - network_mode: host
    - unless: {{ opensds.database.container.compose }}
    {%- endif %}

  {%- else %}
include:
  - {{ opensds.database.provider|trim|lower }}.service.running    #ie. 'etcd.service.running'

  {% endif %}
