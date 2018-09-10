### controller/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if opensds.controller.container.enabled %}

opensds controller container service stopped:
  docker_container.stopped:
    - names:
       - {{ opensds.controller.service }}
      {%- if opensds.controller.container.compose and "osdsctlr" in docker.compose %}
       - {{ docker.compose.osdsctlr.container_name }}
      {%- endif %}
    - error_on_absent: False

opensds controller {{ opensds.controller.release }} clean release files:
  file.absent:
    - names:
      - {{ opensds.dir.work }}
      - {{ opensds.dir.driver }}
      - {{ opensds.dir.config }}
      - {{ opensds.dir.log }}
      - {{ opensds.dir.tmp }}
      - {{ opensds.dir.devstack }}

  {%- else %}

include:
  - opensds.controller.{{ opensds.controller.provider|trim|lower }}.clean

  {% endif %}
