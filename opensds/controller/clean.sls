### opensds/controller/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.controller.container.enabled %}
        {%- if opensds.controller.container.composed %}

include:
  - opensds.envs.docker.clean

        {#- elif opensds.controller.container.build #}
        {%- else %}

opensds controller container service stopped:
  docker_container.stopped:
    - name: {{ opensds.controller.service }}
    - error_on_absent: False

        {%- endif %}
    {%- elif opensds.controller.provider|lower|trim in ('release', 'repo',) %}

opensds controller {{ opensds.controller.release }} clean release files:
  file.absent:
    - names:
      - {{ opensds.dir.work }}
      - {{ opensds.dir.config }}
      - {{ opensds.dir.driver }}
      - {{ opensds.dir.log }}
      - {{ opensds.dir.tmp }}

    {% endif %}
