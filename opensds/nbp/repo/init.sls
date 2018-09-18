###  opensds/nbp/repo/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds with context %}

include:
  - packages.pips
  - packages.pkgs
  - packages.archives

opensds nbp repo get source if missing:
  git.latest:
    - name: {{ opensds.nbp.repo.url }}
    - target: {{ golang.go_path }}/src/github.com/opensds/nbp
    - rev: {{ opensds.nbp.repo.get('branch', 'master') }}
    - force_checkout: True
    - force_clone: True
    - force_fetch: True
    - force_reset: True
  cmd.run:
    - name: make
    - cwd: {{ {{ golang.go_path }}/src/github.com/opensds/nbp

    {%- for driver in ('csi', 'provisioner',) %}

opensds nbp repo copy {{ driver }} deploy scripts to workdir:
   file.copy:
    - name: {{ opensds.nbp.dir.work }}/{{ driver }}/
    - source: {{ golang.go_path }}/github.com/opensds/nbp/deploy/
    - force: True
    - makedirs: True
    - mode: 0755

opensds nbp repo copy {{ driver }} deploy scripts to workdir:
   file.copy:
    - name: {{ opensds.nbp.dir.work }}/{{ driver }}/
    - source: {{ golang.go_path }}/github.com/opensds/nbp/examples/
    - force: True
    - makedirs: True
    - mode: 0755

    {%- endfor %}

opensds nbp copy flexvolume plugin binary into flexvolume plugin dir:
  file.copy:
    - name: {{ opensds.nbp.plugins[opensds.nbp.plugin_type]['dir'] }}/opensds
    - source: {{ opensds.nbp.plugins[opensds.nbp.plugin_type]['binary'] }}
    - force: True
    - makedirs: True
    - mode: 0755
    - onlyif: test {{ plugin }} == 'flexvolume'

