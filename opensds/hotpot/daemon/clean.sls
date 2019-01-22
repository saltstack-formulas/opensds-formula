###  opensds/hotpot/daemon/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds, golang with context %}

  {%- for instance in opensds.hotpot.instances %}
    {%- if instance in opensds.hotpot.daemon and opensds.hotpot.daemon[ instance|string ] is mapping %}
        {%- set daemon = opensds.hotpot.daemon[ instance|string ] %}

opensds hotpot daemon {{ instance }} systemd service removed:
  service.dead:
    - name: opensds-{{ instance }}
  cmd.run:
    - name: {{ daemon.repo.clean_cmd }}
    - cwd: {{ golang.go_path }}/src/github.com/opensds/{{ instance }}
    - env:
       - GOPATH: {{ golang.go_path }}
    - output_loglevel: quiet
    - onlyif:
      - {{ "systemd" in daemon.strategy|lower }}
      - {{ "repo" in daemon.strategy|lower }}

opensds hotpot daemon {{ instance }} directories removed:
  file.absent:
    - names:
      - {{ opensds.systemd.dir }}/opensds-{{ instance }}.service
      - {{ opensds.dir.hotpot }}
      - {{ opensds.dir.tmp }}/{{ opensds.dir.hotpot }}
      - {{ golang.go_path }}/src/github.com/opensds/{{ instance }}
  cmd.run:
    - names:
      - systemctl daemon-reload
    - watch:
      - file: opensds hotpot daemon {{ instance }} directories removed

    {%- endif %}
  {%- endfor %}
