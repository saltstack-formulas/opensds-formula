###  opensds/gelato/daemon/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds, golang with context %}

  {%- for instance in opensds.gelato.instances %}
    {%- if instance in opensds.gelato.daemon and opensds.gelato.daemon[ instance|string ] is mapping %}
       {%- set daemon = opensds.gelato.daemon[ instance|string ] %}

       {%- if "keystone" in daemon.strategy|lower %}

include:
  - devstack.cli

       {%- endif %}

          ##########################################
          #### OpenSDS gelato daemon from repo  ####
          ##########################################
       {%- if "repo" in daemon.strategy|lower %}

opensds gelato daemon build {{ instance }} from repo:
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
      - git: opensds gelato daemon build {{ instance }} from repo
  git.latest:
    - name: {{ daemon.repo.url }}
    - target: {{ golang.go_path }}/src/github.com/opensds/{{ instance }}
    - rev: {{ 'master' if not "branch" in daemon.repo else daemon.repo.branch }}
    - force_checkout: True
    - force_clone: True
    - force_fetch: True
    - force_reset: True
    - retry:
        attempts: 3
        until: True
        interval: 60
        splay: 10
    - require_in:
      - cmd: opensds gelato daemon build {{ instance }} from repo
  cmd.run:
    - name: {{ daemon.repo.build_cmd }}
    - cwd: {{ golang.go_path }}/src/github.com/opensds/{{ instance }}
    - env:
       - GOPATH: {{ golang.go_path }}
    - output_loglevel: quiet
    - onlyif: test -f {{ golang.go_path }}/src/github.com/opensds/{{ instance }}/docker-compose.yml
    - require_in:
      - service: opensds gelato daemon systemd {{ instance }} service started

opensds gelato daemon {{ instance }} repo copy to work directory:
  cmd.run:
    - name: cp -rp {{ golang.go_path }}/src/github.com/opensds/{{ instance }}/* {{ opensds.dir.gelato }}/
    - onlyif: test -d {{ golang.go_path }}/src/github.com/opensds/{{ instance }}
    - require:
      - git: opensds gelato daemon build {{ instance }} from repo

          ################################
          #### gelato release binaries ####
          ################################
       {%- elif "release" in daemon.strategy|lower %}

opensds gelato daemon {{ instance }} release copy to work directory:
  cmd.run:
    - name: cp -rp {{ opensds.dir.tmp }}/{{ opensds.dir.gelato }}/* {{ opensds.dir.gelato }}/
    - onlyif: test -d {{ opensds.dir.tmp }}/{{ opensds.dir.gelato }}

       {%- endif %}


opensds gelato daemon {{ instance }} copy docker-compose.yml to hotpot dir:
  file.copy:
    - name: {{ golang.go_path }}/src/github.com/opensds/{{ instance }}/docker-compose.yml
    - source: {{ opensds.dir.gelato }}/docker-compose.yml
    - makedirs: True
    - force: True
    - onlyif:
      - test -d {{ opensds.dir.gelato }}/docker-compose.yml
      - test -d {{ golang.go_path }}/src/github.com/opensds/{{ instance }}


          #######################################
          #### OpenSDS gelato daemon systemd ####
          #######################################
       {%- if "systemd" in daemon.strategy|lower %}

opensds gelato daemon systemd {{ instance }} service started:
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
        workdir: {{ golang.go_path }}/src/github.com/opensds/{{ instance }}/
  cmd.run:
    - names:
      - systemctl daemon-reload
    - watch:
      - file: opensds gelato daemon systemd {{ instance }} service started
  service.running:
    - name: opensds-{{ instance }}
    - enable: True
    - watch:
      - cmd: opensds gelato daemon systemd {{ instance }} service started

       {%- endif %}

    {%- endif %}
  {%- endfor %}
