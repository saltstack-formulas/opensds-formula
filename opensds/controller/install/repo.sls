# -*- coding: utf-8 -*-
# vim: ft=sls
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

opensds controller {{ opensds.controller.release}} repo download from git:
  git.latest:
    - name: {{ opensds.controller.repo.url }}
    - target: {{ opensds.dir.tmp }}/opensds-linux-amd64
    - rev: {{ opensds.repo.get('branch', 'master') }}
    - force_checkout: True
    - force_clone: True
    - force_fetch: True
    - force_reset: True
  cmd.run:
    - name: make
    - cwd: {{ opensds.dir.tmp }}/controller
    - env:
       - GOPATH: {{ opensds.gohome }}/bin
    - require:
      - git: opensds controller {{ opensds.controller.release }} repo download from git

opensds controller copy {{ opensds.controller.release }} repo content to work directory:
  file.copy:
    name: {{ opensds.dir.work }}
    source: {{ opensds.dir.tmp }}/opensds-linux-amd64
    makedirs: True
    force: True

