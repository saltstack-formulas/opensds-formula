###  opensds/sushi/daemon/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds, golang with context %}

  {%- for instance in opensds.sushi.instances %}
    {%- if instance in opensds.sushi.daemon and opensds.sushi.daemon[ instance|string ] is mapping %}
       {%- set daemon = opensds.sushi.daemon[ instance|string ] %}

opensds sushi daemon {{ instance }} systemd service removed:
  service.dead:
    - name: opensds-{{ instance }}
  cmd.run:
    - name: {{ daemon.repo.clean_cmd }}
    - cwd: {{ golang.go_path }}/src/github.com/opensds/{{ instance }}
    - env:
       - GOPATH: {{ golang.go_path }}
    - output_loglevel: quiet
    - onlyif: {{ "repo" in daemon.strategy|lower }}

opensds sushi daemon {{ instance }} directories removed:
  file.absent:
    - names:
      - {{ opensds.systemd.dir }}/opensds-{{ instance }}.service
      - {{ opensds.dir.sushi }}
      - {{ opensds.dir.tmp }}/{{ opensds.dir.sushi }}
      - {{ golang.go_path }}/src/github.com/opensds/{{ instance }}
  cmd.run:
    - names:
      - systemctl daemon-reload
    - watch:
      - file: opensds sushi daemon {{ instance }} directories removed

    {%- endif %}
  {%- endfor %}
