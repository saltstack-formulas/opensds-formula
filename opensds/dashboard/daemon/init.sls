###  opensds/dashboard/daemon/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds, golang with context %}

include:
  - opensds.dashboard.config

  {%- for instance in opensds.dashboard.instances %}
    {%- if instance in opensds.dashboard.daemon and opensds.dashboard.daemon[ instance|string ] is mapping %}
       {%- set daemon = opensds.dashboard.daemon[ instance|string ] %}

       {%- if "repo" in daemon.strategy|lower %}
          ###################################################
          #### OpenSDS dashboard daemon build from repo  ####
          ###################################################

extend:
  opensds dashboard config ensure nginx stopped:
    service.dead:
      - watch:
        - docker_container: opensds dashboard container {{ instance }} running
  opensds dashboard config ensure nginx disabled:
    service.disabled:
      - watch:
        - docker_container: opensds dashboard container {{ instance }} running


opensds dashboard daemon {{ instance }} install angular cli:
  cmd.run:
    - name: npm install -g @angular/cli
    - env:
       - GOPATH: {{ golang.go_path }}
    - onlyif:
      - npm --version 2>/dev/null
      - {{ instance == 'dashboard' }}

opensds dashboard daemon build {{ instance }} from repo:
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
      - git: opensds dashboard daemon build {{ instance }} from repo
  git.latest:
    - name: {{ daemon.repo.url }}
    - target: {{ golang.go_path }}/src/github.com/opensds/{{ instance }}
    - rev: {{ 'master' if not "branch" in daemon.repo else daemon.repo.branch }}
    - force_checkout: True
    - force_clone: True
    - force_fetch: True
    - force_reset: True
    - require_in:
      - cmd: opensds dashboard daemon build {{ instance }} from repo
  cmd.run:
    - name: {{ daemon.repo.build_cmd }}
    - cwd: {{ golang.go_path }}/src/github.com/opensds/{{ instance }}
    - env:
       - GOPATH: {{ golang.go_path }}
    - output_loglevel: quiet
    - require_in:
      - service: opensds dashboard daemon systemd {{ instance }} service started
  service.dead:
    - name: nginx
    - watch:
      - cmd: opensds dashboard daemon build {{ instance }} from repo

opensds dashboard daemon {{ instance }} repo copy to hotpot directory:
  service.disabled:
    - name: nginx
    - watch: service: opensds dashboard daemon build {{ instance }} from repo
  cmd.run:
    - name: cp -rp {{ golang.go_path }}/src/github.com/opensds/{{ instance }}/* {{ opensds.dir.hotpot }}/
    - onlyif: test -d {{ golang.go_path }}/src/github.com/opensds/{{ instance }}
    - require:
      - git: opensds dashboard daemon build {{ instance }} from repo


          #######################################
          ####dashboard release binaries ####
          #######################################
       {%- elif "release" in daemon.strategy|lower %}

opensds dashboard daemon {{ instance }} release copy to hotpot directory:
  cmd.run:
    - name: cp -rp {{ opensds.dir.tmp }}/{{ opensds.dir.hotpot }}/*  {{ opensds.dir.hotpot }}/
    - onlyif: test -d {{ opensds.dir.tmp }}/{{ opensds.dir.hotpot }}
    
       {%- endif %}


       {%- if "systemd" in daemon.strategy|lower %}
          ###########################################
          #### OpenSDS dashboard daemon systemd  ####
          ###########################################

opensds dashboard daemon systemd {{ instance }} service started:
  file.managed:
    - name: {{ opensds.systemd.dir }}/opensds-{{ instance }}.service
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
      - file: opensds dashboard daemon systemd {{ instance }} service started
  service.running:
    - name: opensds-{{ instance }}
    - enable: True
    - watch:
      - cmd: opensds dashboard daemon systemd {{ instance }} service started

       {%- endif %}

    {%- endif %}
  {%- endfor %}
