### opensds/hotpot/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds, golang with context %}


  {%- if opensds.deploy_project not in ('gelato',)  %}
    {%- if opensds.hotpot.container.enabled %}

opensds hotpot container service stopped:
  docker_container.stopped:
    - name: {{ opensds.hotpot.service }}
    - error_on_absent: False

    {%- elif opensds.hotpot.provider|lower|trim in ('release', 'repo',) %}

opensds hotpot clean release files:
  file.absent:
    - names:
      - {{ opensds.dir.work }}
      - {{ opensds.dir.config }}
      - {{ opensds.dir.driver }}
      - {{ opensds.dir.log }}

    {% endif %}

  {%- elif opensds.deploy_project not in ('hotpot',) and opensds.hotpot.provider = 'repo' %}

opensds hotpot clean multi-cloud engine data:
  cmd.run:
    - names:
      - make clean
   - cwd: {{ golang.go_path }}/src/github.com/opensds/multi-cloud

  {% endif %}
