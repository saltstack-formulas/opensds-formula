### opensds/controller/repo.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

include:
  - opensds.stacks.golang

opensds controller {{ opensds.controller.release}} repo download from git:
  git.latest:
    - name: {{ opensds.controller.repo.url }}
    - target: {{ opensds.dir.tmp }}/{{ opensds.dir.work }}
    - rev: {{ opensds.repo.get('branch', 'master') }}
    - force_checkout: True
    - force_clone: True
    - force_fetch: True
    - force_reset: True
  cmd.run:
    - name: make
    - cwd: {{ opensds.dir.tmp }}/{{ opensds.dir.work }}
    - env:
       - GOPATH: {{ opensds.lang.home }}/bin
    - require:
      - git: opensds controller {{ opensds.controller.release }} repo download from git

opensds controller {{ opensds.controller.release }} copy repo content to work directory:
  file.copy:
    name: {{ opensds.dir.work }}
    source: {{ opensds.dir.tmp }}/{{ opensds.dir.work }}
    makedirs: True
    force: True
