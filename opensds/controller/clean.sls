### opensds/controller/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}


    {%- if opensds.controller.container.enabled %}

opensds controller container service stopped:
  docker_container.stopped:
    - name: {{ opensds.controller.service }}
    - error_on_absent: False

    {%- elif opensds.controller.provider|lower|trim in ('release', 'repo',) %}

opensds controller clean release files:
  file.absent:
    - names:
      - {{ opensds.dir.work }}
      - {{ opensds.dir.config }}
      - {{ opensds.dir.driver }}
      - {{ opensds.dir.log }}

    {% endif %}
