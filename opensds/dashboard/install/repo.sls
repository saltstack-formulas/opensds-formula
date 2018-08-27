# -*- coding: utf-8 -*-
# vim: ft=sls
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

include:
  - opensds.env

opensds dashboard {{ opensds.dashboard.release.version}} repo build from source:
  git.latest:
    - name: {{ opensds.repo.url }}
    - target: {{ opensds.lang.src }}/{{ opensds.dir.work }}/opensds/dashboard
    - rev: {{ opensds.repo.get('branch', 'master') }}
    - force_checkout: True
    - force_clone: True
    - force_fetch: True
    - force_reset: True
    - require_in:
      - cmd: opensds dashboard {{ opensds.dashboard.release.version}} repo build from source
  cmd.run:
    - names:
      - make
      - {{ opensds.dashboard.webservers.restart }}
    - cwd: {{ opensds.lang.src }}/{{ opensds.dir.work }}/opensds/dashboard

opensds dashboard {{ opensds.dashboard.release.version}} repo reconfigure nginx:
  file.managed:
    name: {{ opensds.dir.tmp }}/script/set_nginx_config.sh
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
