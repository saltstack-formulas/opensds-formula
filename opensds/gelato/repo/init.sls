###  opensds/gelato/repo/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds, golang with context %}

opensds gelato repo build from source:
  git.latest:
    - name: {{ opensds.gelato.repo.url }}
    - target: {{ golang.go_path }}/src/github.com/opensds/multi-cloud
    - rev: {{ opensds.gelato.repo.get('branch', 'master') }}
    - force_checkout: True
    - force_clone: True
    - force_fetch: True
    - force_reset: True
    - require:
      - opensds gelato ensure opensds dirs exist
    - require_in:
      - cmd: opensds gelato repo build from source
    - unless: {{ opensds.deploy_project in ('hotpot',) }}
    - onlyif: {{ opensds.gelato.provider }} = 'repo'
  cmd.run:
    - names:
      - make docker
    - cwd: {{ golang.go_path }}/src/github.com/opensds/multi-cloud
    - env:
        - GOPATH: {{ golang.go_path }}
    - output_loglevel: quiet
    - unless: {{ opensds.deploy_project in ('hotpot',) }}
    - onlyif: {{ opensds.gelato.provider }} = 'repo'

opensds gelato repo docker-compose.yml file into gelato work directory:
   file.copy:
    - name: {{ opensds.gelato.dir.work }}/
    - source: {{ golang.go_path }}/src/github.com/opensds/multi-cloud/docker-compose.yml
    - force: True
    - makedirs: True
    - user: {{ opensds.user or 'root' }}
    - mode: {{ opensds.file_mode or '0644' }}
    - unless: {{ opensds.deploy_project in ('hotpot',) }}
    - onlyif: {{ opensds.gelato.provider }} = 'repo'

