###  opensds/sushi/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds with context %}


  {%- if opensds.deploy_project not in ('gelato',)  %}
    {%- if opensds.sushi.container.enabled %}

opensds sushi container service stopped:
  docker_container.stopped:
    - name: {{ opensds.sushi.service }}
    - error_on_absent: False

    {% else %}

include:
  - opensds.sushi.plugins.clean
  - iscsi.initiator.remove

    {% endif %}
  {%- elif opensds.sushi.plugin_type not in ('hotpot_only',) and opensds.sushi.provider = 'repo' %}

opensds sushi clean northbound plugin data:
  cmd.run:
    - names:
      - make clean
    - cwd: {{ golang.go_path }}/src/github.com/opensds/nbp

  {% endif %}
