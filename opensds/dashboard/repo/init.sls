###  opensds/dashboard/repo/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds, golang with context %}

include:
  {{ '- epel' if grains.os_family in ('RedHat',) else '' }}
  - packages.pips
  - packages.pkgs
  - packages.archives

opensds dashboard ensure opensds dirs exist:
  file.directory:
    - names:
      {%- for k, v in opensds.dir.items() %}
      - {{ v }}
      {%- endfor %}
      - {{ golang.go_path }}/src/github.com/opensds/dashboard
    - makedirs: True
    - force: True
    - user: {{ opensds.user or 'root' }}
    - dir_mode: {{ opensds.dir_mode or '0755' }}
    - recurse:
      - user
      - mode

opensds dashboard repo build from source:
  git.latest:
    - name: {{ opensds.dashboard.repo.url }}
    - target: {{ golang.go_path }}/src/github.com/opensds/dashboard
    - rev: {{ opensds.dashboard.repo.get('branch', 'master') }}
    - force_checkout: True
    - force_clone: True
    - force_fetch: True
    - force_reset: True
    - require:
      - opensds dashboard ensure opensds dirs exist
    - require_in:
      - cmd: opensds dashboard repo build from source
  cmd.run:
    - names:
      - service apache2 stop 2>/dev/null || true
      - make
      - service apache2 start 2>/dev/null || true
    - cwd: {{ golang.go_path }}/src/github.com/opensds/dashboard
    - output_loglevel: quiet
  service.running:
    - name: nginx
    - enable: True
    - watch:
      - cmd: opensds dashboard repo build from source
