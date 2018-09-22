###  opensds/nbp/repo/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds with context %}

include:
  {{ '- epel' if grains.os_family in ('Redhat',) else '' }}
  - packages.pips
  - packages.pkgs
  - packages.archives

opensds nbp ensure opensds dirs exist:
  file.directory:
    - names:
      {%- for k, v in opensds.dir.items() %}
      - {{ v }}
      {%- endfor %}
      {%- for k, v in opensds.nbp.dir.items() %}
      - {{ v }}
      {%- endfor %}
      - {{ golang.go_path }}/src/github.com/opensds/nbp
    - makedirs: True
    - force: True
    - user: {{ opensds.user or 'root' }}
    - dir_mode: {{ opensds.dir_mode or '0755' }}

opensds nbp repo get source if missing:
  git.latest:
    - name: {{ opensds.nbp.repo.url }}
    - target: {{ golang.go_path }}/src/github.com/opensds/nbp
    - rev: {{ opensds.nbp.repo.get('branch', 'master') }}
    - force_checkout: True
    - force_clone: True
    - force_fetch: True
    - force_reset: True
    - require:
      - opensds nbp ensure opensds dirs exist
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
    - user: {{ opensds.user or 'root' }}
    - mode: {{ opensds.file_mode or '0644' }}

opensds nbp repo copy {{ driver }} deploy scripts to workdir:
   file.copy:
    - name: {{ opensds.nbp.dir.work }}/{{ driver }}/
    - source: {{ golang.go_path }}/github.com/opensds/nbp/examples/
    - force: True
    - makedirs: True
    - user: {{ opensds.user or 'root' }}
    - mode: {{ opensds.file_mode or '0644' }}

    {%- endfor %}

opensds nbp copy flexvolume plugin binary into flexvolume plugin dir:
  file.copy:
    - name: {{ opensds.nbp.plugins[opensds.nbp.plugin_type]['dir'] }}/opensds
    - source: {{ opensds.nbp.plugins[opensds.nbp.plugin_type]['binary'] }}
    - force: True
    - makedirs: True
    - user: {{ opensds.user or 'root' }}
    - mode: {{ opensds.file_mode or '0644' }}
    - onlyif: test '{{ plugin }}' == 'flexvolume'

