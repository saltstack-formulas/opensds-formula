### opensds/hotpot/repo.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds, golang with context %}

include:
  - golang.init

opensds hotpot ensure opensds dirs exist:
  file.directory:
    - names:
      {%- for k, v in opensds.dir.items() %}
      - {{ v }}
      {%- endfor %}
      - {{ opensds.dir.tmp }}/{{ opensds.dir.work }}
    - makedirs: True
    - force: True
    - user: {{ opensds.user or 'root' }}
    - dir_mode: {{ opensds.dir_mode or '0755' }}
    - recurse:
      - user
      - mode

opensds hotpot repo download from git:
  git.latest:
    - name: {{ opensds.hotpot.repo.url }}
    - target: {{ opensds.dir.tmp }}/{{ opensds.dir.work }}
    - rev: {{ opensds.repo.get('branch', 'master') }}
    - force_checkout: True
    - force_clone: True
    - force_fetch: True
    - force_reset: True
    - require:
      - opensds hotpot ensure opensds dirs exist
  cmd.run:
    - name: make
    - cwd: {{ opensds.dir.tmp }}/{{ opensds.dir.work }}
    - env:
       - GOPATH: {{ golang.go_path }}/bin
    - require:
      - git: opensds hotpot repo download from git
  file.managed:
    - name: {{ opensds.dir.work }}/
    - makedirs: True
    - user: {{ opensds.user or 'root' }}
    - dir_mode: {{ opensds.dir_mode or '0755' }}
    - recurse:
      - user
      - mode

opensds hotpot copy repo content to work directory:
  file.copy:
    - name: {{ opensds.dir.work }}/
    - source: {{ opensds.dir.tmp }}/{{ opensds.dir.work }}/*
    - makedirs: True
    - force: True
    - user: {{ opensds.user or 'root' }}
    - mode: {{ opensds.file_mode or '0644' }}
    - require:
      - file: opensds hotpot repo download from git
     
