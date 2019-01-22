###  opensds/dashboard/daemon/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds, golang with context %}


  {%- for instance in opensds.dashboard.instances %}
    {%- if instance in opensds.dashboard.daemon and opensds.dashboard.daemon[ instance|string ] is mapping %}
       {%- set daemon = opensds.dashboard.daemon[ instance|string ] %}

           #########################################
           #### OpenSDS dashboard daemon clean  ####
           #########################################
       {%- if "repo" in daemon.strategy|lower %}

opensds dashboard daemon {{ instance }} systemd service removed:
  service.dead:
    - name: opensds-{{ instance }}
  file.absent:
    - names:
      - {{ opensds.systemd.dir }}/opensds-{{ instance }}.service
      - {{ golang.go_path }}/src/github.com/opensds/{{ instance }}
    - watch:
      - service: opensds dashboard daemon {{ instance }} systemd service removed
  cmd.run:
    - names:
      - systemctl daemon-reload
    - watch:
      - file: opensds dashboard daemon {{ instance }} systemd service removed

       {%- endif %}
    {%- endif %}
  {%- endfor %}
