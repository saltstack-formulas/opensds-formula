###  opensds/hotpot/daemon/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds, golang with context %}

include:
  - opensds.config

  {%- for instance in opensds.hotpot.instances %}
    {%- if instance in opensds.hotpot.daemon and opensds.hotpot.daemon[ instance|string ] is mapping %}
       {%- set daemon = opensds.hotpot.daemon[ instance|string ] %}

       {%- if not opensds.hotpot.container[ instance|string ]['enabled'] and not opensds.hotpot.container[ instance|string ]['build'] %}
          ####################
          #### Sushi Repo ####
          ####################
          {%- if "repo" in daemon.strategy|lower %}

opensds hotpot daemon {{ instance }} build from repo:
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
      - git: opensds hotpot daemon {{ instance }} build from repo
  git.latest:
    - name: {{ daemon.repo.url }}
    - target: {{ golang.go_path }}/src/github.com/opensds/{{ instance }}
    - rev: {{ daemon.repo.branch }}
    - force_checkout: True
    - force_clone: False
    - force_fetch: True
    - force_reset: True
    - retry:
        attempts: 3
        until: True
        interval: 60
        splay: 10
    - require_in:
      - cmd: opensds hotpot daemon {{ instance }} build from repo
  cmd.run:
    - name: {{ daemon.repo.build_cmd }}
    - cwd: {{ golang.go_path }}/src/github.com/opensds/{{ instance }}
    - env:
       - GOPATH: {{ golang.go_path }}
    - output_loglevel: quiet

opensds hotpot daemon {{ instance }} repo copy everything into hotpot directory:
  cmd.run:
    - name: cp -rp {{ golang.go_path }}/src/github.com/opensds/{{ instance }}/* {{ opensds.dir.hotpot }}/
    - onlyif: test -d {{ golang.go_path }}/src/github.com/opensds/{{ instance }}
    - require:
      - git: opensds hotpot daemon {{ instance }} build from repo

          #################################
          #### hotpot release binaries ####
          #################################
          {%- elif "release" in daemon.strategy|lower %}

opensds hotpot daemon {{ instance }} release copy to hotpot directory:
  cmd.run:
    - name: cp -rp {{ opensds.dir.tmp }}/{{ opensds.dir.hotpot }}/* {{ opensds.dir.hotpot }}/
    - onlyif: test -d {{ opensds.dir.tmp }}/{{ opensds.dir.hotpot }}/bin

          {%- endif %}
       {%- endif %}



       {%- for binary in [opensds.hotpot.binaries, 'osdsdock',] %}
     
opensds hotpot daemon {{ instance }} repo copy {{ binary }} to usr/local/bin:
  file.copy:
    - name: /usr/local/bin
    - source: {{ golang.go_path }}/src/github.com/opensds/{{ instance }}/build/out/bin/{{ binary }}
    - onlyif: test -f {{ golang.go_path }}/src/github.com/opensds/{{ instance }}/build/out/bin/{{ binary }}
    - force: False
    - subdir: True

opensds hotpot daemon {{ instance }} release copy {{ binary }} to usr/local/bin:
  file.copy:
    - name: /usr/local/bin
    - source: {{ opensds.dir.tmp }}/{{ opensds.dir.hotpot }}/bin/{{ binary }}
    - onlyif: test -f {{ opensds.dir.tmp }}/{{ opensds.dir.hotpot }}/bin/{{ binary }}
    - mode: '0755'
    - subdir: True
    - force: True

       {%- endfor %}



          ########################################
          #### OpenSDS hotpot daemon systemd  ####
          ########################################
       {%- if "systemd" in daemon.strategy|lower %}

opensds hotpot daemon {{ instance }} systemd service started:
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
      - file: opensds hotpot daemon {{ instance }} systemd service started
  service.running:
    - name: opensds-{{ instance }}
    - enable: True
    - watch:
      - cmd: opensds hotpot daemon {{ instance }} systemd service started

       {%- endif %}
    {%- endif %}
  {%- endfor %}
