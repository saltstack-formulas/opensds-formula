###  opensds/nbp/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if opensds.nbp.container.enabled %}

opensds nbp {{ opensds.nbp.release }} container service running:
  docker_container.running:
    - name: {{ opensds.nbp.service }}
    - image: {{ opensds.nbp.container.image }}
    - restart_policy: always
    - network_mode: host
    - unless: {{ opensds.nbp.container.composed }}

  {%- elif opensds.nbp.container.composed %}

include:
  - opensds.stacks.dockercompose

  {%- else %}

include:
  - opensds.stacks
  - opensds.nbp.{{ opensds.nbp.install_from }}
  - opensds.nbp.provider

  {%- endif %}
