###  opensds/dock/daemon/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds, golang with context %}

  {%- for instance in opensds.dock.instances %}
    {%- if instance in opensds.dock.daemon and opensds.dock.daemon[ instance|string ] is mapping %}
        {%- set daemon = opensds.dock.daemon[ instance|string ] %}

opensds dock daemon {{ instance }} systemd service removed:
  service.dead:
    - name: opensds-{{ instance }}
  file.absent:
    - names:
      - {{ opensds.systemd.dir }}/opensds-{{ instance }}.service
      - {{ golang.go_path }}/src/github.com/opensds/{{ instance }}
  cmd.run:
    - names:
      - systemctl daemon-reload
    - watch:
      - file: opensds dock daemon {{ instance }} systemd service removed

    {%- endif %}
  {%- endfor %}
