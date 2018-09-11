### opensds/controller/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if opensds.controller.container.enabled %}

opensds controller container service stopped:
  docker_container.stopped:
    - name: {{ opensds.controller.service }}
    - error_on_absent: False


  {%- elif opensds.controller.container.composed %}

include:
  - opensds.stacks.dockercompose.clean


  {%- elif opensds.controller.provider|lower|trim in ('release', 'repo',) %}

opensds controller {{ opensds.controller.release }} clean release files:
  file.absent:
    - names:
      - {{ opensds.dir.work }}
      - {{ opensds.dir.driver }}
      - {{ opensds.dir.config }}
      - {{ opensds.dir.log }}
      - {{ opensds.dir.tmp }}

  {% endif %}
