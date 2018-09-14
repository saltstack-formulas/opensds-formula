###  opensds/dashboard/repo/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds with context %}

include:
  - packages.pips
  - packages.pkgs
  - packages.archives

opensds dashboard repo build from source:
  git.latest:
    - name: {{ opensds.repo.url }}
    - target: {{ golang.go_path }}/src/github.com/opensds/dashboard
    - rev: {{ opensds.repo.get('branch', 'master') }}
    - force_checkout: True
    - force_clone: True
    - force_fetch: True
    - force_reset: True
    - require_in:
      - cmd: opensds dashboard repo build from source
  cmd.run:
    - names:
      - make
      - {{ opensds.webservers.restart }}
    - cwd: {{ golang.go_path }}/src/github.com/opensds/dashboard

opensds dashboard repo reconfigure nginx:
  file.managed:
    - name: {{ opensds.dir.tmp }}/script/set_nginx_config.sh
    - source: salt://opensds/files/script/set_nginx_config.sh
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - unless: test -f {{ opensds.dir.tmp }}/script/set_nginx_config.sh
  cmd.run:
    - names:
      - {{ opensds.dir.tmp }}/script/set_nginx_config.sh
      - {{ opensds.dashboard.webservers.restart }}

