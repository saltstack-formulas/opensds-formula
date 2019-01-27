###  opensds/dock/daemon/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds, golang with context %}

include:
  - opensds.dock.config

  {%- for instance in opensds.dock.instances %}
    {%- if instance in opensds.dock.daemon %}
      {%- set daemon = opensds.dock.daemon[instance|string] %}
      {%- if instance in opensds.dock.container %}
        {%- if not (opensds.dock.container[instance]['enabled'] or opensds.dock.container[instance]['build'])%}

opensds dock daemon {{ instance }} repo copy osdsdock to usr/local/bin:
  file.copy:
    - name: /usr/local/bin
    - source: {{ golang.go_path }}/src/github.com/opensds/opensds/bin/osdsdock
    - onlyif: test -f {{ golang.go_path }}/src/github.com/opensds/opensds/bin/osdsdock
    - force: False
    - subdir: True

opensds dock daemon {{ instance }} release copy osdsdock to usr/local/bin:
  file.copy:
    - name: /usr/local/bin
    - source: {{ opensds.dir.tmp }}/{{ opensds.dir.hotpot }}/build/out/bin/osdsdock
    - onlyif: test -f {{ opensds.dir.tmp }}/{{ opensds.dir.hotpot }}/build/out/bin/osdsdock
    - mode: '0755'
    - subdir: True
    - force: True


          #######################################
          #### OpenSDS dock daemon systemd  ####
          #######################################
          {%- if "systemd" in daemon.strategy|lower %}

opensds dock daemon {{ instance }} systemd service started:
  file.managed:
    - name: {{ opensds.systemd.dir }}/opensds-{{ instance }}.service
    - source: salt://opensds/files/service.jinja
    - mode: {{ opensds.file_mode }}
    - template: jinja
    - makedirs: True
    - context:
        svc: {{ instance }}
        systemd: {{ opensds.systemd|json }}
        start: {{ daemon.start }}
        stop: /usr/bin/killall opensds-{{ instance }}
        workdir: /usr/local
  cmd.run:
    - name: systemctl daemon-reload
    - watch:
      - file: opensds dock daemon {{ instance }} systemd service started
  service.running:
    - name: opensds-{{ instance }}
    - enable: True
    - watch:
      - cmd: opensds dock daemon {{ instance }} systemd service started

          {%- endif %}

        {%- endif %}
      {%- endif %}
    {%- endif %}
  {%- endfor %}
