###  opensds/backend/block/daemon/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds, golang with context %}

include:
  - opensds.backend.block.config

  {%- for instance in opensds.backend.block.instances %}
    {%- if instance in opensds.backend.block.daemon and opensds.backend.block.daemon[ instance|string ] is mapping %}
      {%- set daemon = opensds.backend.block.daemon[ instance|string ] %}

          #######################################################
          #### OpenSDS backend.block daemon build from repo  ####
          #######################################################
      {%- if "repo" in daemon.strategy|lower %}

opensds backend block daemon build {{ instance }} from repo:
  file.directory:
    - name: {{ golang.go_path }}/src/github.com/opensds/{{ instance }}
    - makedirs: True
    - force: True
    - user: {{ opensds.user or 'root' }}
    - dir_mode: {{ opensds.dir_mode or '0755' }}
    - recurse:
      - user
      - mode
    - require_in:
      - git: opensds backend block daemon build {{ instance }} from repo
  git.latest:
    - name: {{ daemon.repo.url }}
    - target: {{ golang.go_path }}/src/github.com/opensds/{{ instance }}
    - rev: {{ 'master' if not "branch" in daemon.repo else daemon.repo.branch }}
    - force_checkout: True
    - force_clone: True
    - force_fetch: True
    - force_reset: True
    - require_in:
      - cmd: opensds backend block daemon build {{ instance }} from repo
  cmd.run:
    - name: {{ daemon.repo.build_cmd }}
    - cwd: {{ golang.go_path }}/src/github.com/opensds/{{ instance }}
    - env:
       - GOPATH: {{ golang.go_path }}
    - output_loglevel: quiet
    - require_in:
      - service: opensds backend block systemd {{ instance }} service started

opensds backend block daemon {{ instance }} repo copy to sushi directory:
  cmd.run:
    - name: cp -rp {{ golang.go_path }}/src/github.com/opensds/{{ instance }}/* {{ opensds.dir.sushi }}/
    - onlyif: test -d {{ golang.go_path }}/src/github.com/opensds/{{ instance }}
    - require:
      - git: opensds backend block daemon build {{ instance }} from repo

          #######################################
          ####backend block release binaries ####
          #######################################
       {%- elif "release" in daemon.strategy|lower %}

opensds backend block daemon {{ instance }} release copy to sushi directory:
  cmd.run:
    - name: cp -rp {{ opensds.dir.tmp }}/{{ opensds.dir.sushi }}/* {{ opensds.dir.sushi }}/
    - onlyif: test -d {{ opensds.dir.tmp }}/{{ opensds.dir.sushi }}

       {%- endif %}


          ########################################
          #### OpenSDS backend block systemd  ####
          ########################################
      {%- if "systemd" in daemon.strategy|lower %}

opensds backend block systemd {{ instance }} service started:
  file.managed:
    - name: {{ opensds.dir.hotpot }}/opensds-{{ instance }}.service
    - source: salt://opensds/files/service.jinja
    - mode: '0644'
    - template: jinja
    - makedirs: True
    - context:
      svc: {{ instance }}
      systemd: {{ opensds.systemd|json }}
      start: {{ daemon.start }}
      stop: /usr/bin/killall opensds-{{ instance }}
      workdir: /usr/local
  cmd.run:
    - names:
      - systemctl daemon-reload
    - watch:
      - file: opensds backend block systemd {{ instance }} service started
  service.running:
    - name: opensds-{{ instance }}
    - enable: True
    - watch:
      - cmd: opensds backend block systemd {{ instance }} service started

      {%- endif %}
    {%- endif %}
  {%- endfor %}
