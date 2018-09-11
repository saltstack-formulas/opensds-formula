### database/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if opensds.database.container.enabled %}

opensds database container service running:
  docker_container.running:
    - name: {{ opensds.database.service }}
    - image: {{ opensds.database.container.image }}
    - restart_policy: always
    - network_mode: host
    - unless: {{ opensds.database.container.composed }}

  {%- elif opensds.database.container.composed %}

include:
  - opensds.stacks.dockercompose

  {%- elif opensds.database.provider|trim|lower == 'etcd' %}

include:
  - etcd.service.running

  {% endif %}
