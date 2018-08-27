# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if opensds.controller.container.enabled %}

opensds controller container service running:
  docker_container.running:
    - name: {{ opensds.controller.service }}
    - image: {{ opensds.controller.container.image }}
    - restart_policy: always
    - network_mode: host
    - unless: {{ opensds.controller.container.compose }}

  {%- else %}

include:
  - opensds.controller.install.{{ opensds.controller.install_from|trim|lower }}
  - opensds.env

  {% endif %}
