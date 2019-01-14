###  opensds/sushi/repo/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds, golang with context %}

include:
  {{ '- epel' if grains.os_family in ('Redhat',) else '' }}
  - packages.pips
  - packages.pkgs
  - packages.archives

opensds sushi ensure opensds dirs exist:
  file.directory:
    - names:
      {%- for k, v in opensds.dir.items() %}
      - {{ v }}
      {%- endfor %}
      {%- for k, v in opensds.sushi.dir.items() %}
      - {{ v }}
      {%- endfor %}
      - {{ golang.go_path }}/src/github.com/opensds/sushi
    - makedirs: True
    - force: True
    - user: {{ opensds.user or 'root' }}
    - dir_mode: {{ opensds.dir_mode or '0755' }}

opensds sushi repo get source if missing:
  git.latest:
    - name: {{ opensds.sushi.repo.url }}
    - target: {{ golang.go_path }}/src/github.com/opensds/sushi
    - rev: {{ opensds.sushi.repo.get('branch', 'master') }}
    - force_checkout: True
    - force_clone: True
    - force_fetch: True
    - force_reset: True
    - require:
      - opensds sushi ensure opensds dirs exist
  cmd.run:
    - name: make
    - cwd: {{ golang.go_path }}/src/github.com/opensds/sushi

    {%- for driver in ('csi', 'provisioner',) %}

opensds sushi repo copy {{ driver }} deploy scripts to workdir:
   file.copy:
    - name: {{ opensds.sushi.dir.work }}/{{ driver }}/
    - source: {{ golang.go_path }}/github.com/opensds/sushi/deploy/
    - force: True
    - makedirs: True
    - user: {{ opensds.user or 'root' }}
    - mode: {{ opensds.file_mode or '0644' }}

opensds sushi repo copy {{ driver }} deploy scripts to workdir:
   file.copy:
    - name: {{ opensds.sushi.dir.work }}/{{ driver }}/
    - source: {{ golang.go_path }}/github.com/opensds/sushi/examples/
    - force: True
    - makedirs: True
    - user: {{ opensds.user or 'root' }}
    - mode: {{ opensds.file_mode or '0644' }}

    {%- endfor %}

opensds sushi copy flexvolume plugin binary into flexvolume plugin dir:
  file.copy:
    - name: {{ opensds.sushi.plugins[opensds.sushi.plugin_type]['dir'] }}/opensds
    - source: {{ opensds.sushi.plugins[opensds.sushi.plugin_type]['binary'] }}
    - force: True
    - makedirs: True
    - user: {{ opensds.user or 'root' }}
    - mode: {{ opensds.file_mode or '0644' }}
    - onlyif: test '{{ plugin }}' == 'flexvolume'

