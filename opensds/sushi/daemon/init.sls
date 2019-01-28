###  opensds/sushi/daemon/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds, golang with context %}

include:
  - opensds.config

  {%- for instance in opensds.sushi.instances %}
    {%- if instance in opensds.sushi.daemon and opensds.sushi.daemon[ instance|string ] is mapping %}
       {%- set daemon = opensds.sushi.daemon[ instance|string ] %}

          ####################
          #### Sushi Repo ####
          ####################
       {%- if "repo" in daemon.strategy|lower %}

opensds sushi daemon {{ instance }} build from repo:
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
      - git: opensds sushi daemon {{ instance }} build from repo
  git.latest:
    - name: {{ daemon.repo.url }}
    - target: {{ golang.go_path }}/src/github.com/opensds/{{ instance }}
    - rev: {{ daemon.repo.branch }}
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
      - cmd: opensds sushi daemon {{ instance }} build from repo
  cmd.run:
    - name: {{ daemon.repo.build_cmd }}
    - env:
       - GOPATH: {{ golang.go_path }}
    - cwd: {{ golang.go_path }}/src/github.com/opensds/{{ instance }}
    - output_loglevel: quiet

opensds sushi daemon {{ instance }} repo copy to sushi directory:
  cmd.run:
    - name: cp -rp {{ golang.go_path }}/src/github.com/opensds/{{ instance }}/* {{ opensds.dir.sushi }}/
    - onlyif: test -d {{ golang.go_path }}/src/github.com/opensds/{{ instance }}
    - require:
      - git: opensds sushi daemon {{ instance }} build from repo

          #################################
          #### sushi release binaries ####
          #################################
       {%- elif "release" in daemon.strategy|lower %}

opensds sushi daemon {{ instance }} release copy to work directory:
  cmd.run:
    - name: cp -rp {{ opensds.dir.tmp }}/{{ opensds.dir.sushi }}/* {{ opensds.dir.sushi }}/
    - onlyif: test -d {{ opensds.dir.tmp }}/{{ opensds.dir.sushi }}

       {%- endif %}


          #######################################
          #### OpenSDS sushi daemon systemd  ####
          #######################################
       {%- if "systemd" in daemon.strategy|lower %}

opensds sushi daemon {{ instance }} systemd service started:
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
      - file: opensds sushi daemon {{ instance }} systemd service started
  service.running:
    - name: opensds-{{ instance }}
    - enable: True
    - watch:
      - cmd: opensds sushi daemon {{ instance }} systemd service started

       {%- endif %}
    {%- endif %}
  {%- endfor %}
