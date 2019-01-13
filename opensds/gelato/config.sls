###  opensds/gelato/config.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds, golang with context %}

  {%- if opensds.deploy_project not in ('hotpot',) %}

opensds gelato download docker-compose.yml configuration file:
  cmd.run:
    - name: curl -O {{ opensds.gelato.container.compose.url }}
    - cwd: {{ opensds.gelato.dir.work }}
    - unless: test {{ opensds.gelato.provider }} = 'repo'
  #file.managed: file corrupted ##
  #  - name: {{ opensds.gelato.dir.work }}/docker-compose.yml
  #  - source: {{ opensds.gelato.container.compose.url }}
  #  - source_hash: {{ opensds.gelato.container.compose.hashsum }}
    - require_in:
      - cmd: opensds gelato start service run compose up

opensds gelato modify configuration auth strategy:
  file.replace:
    - name: {{ opensds.gelato.container.compose.conf }}
    - pattern: OS_AUTH_AUTHSTRATEGY=.*$
    - repl: OS_AUTH_AUTHSTRATEGY={{ opensds.auth.provider }}
    - backup: '.salt.bak'
    - require_in:
      - cmd: opensds gelato start service run compose up

opensds gelato modify configuration auth url:
  file.replace:
    - name: {{ opensds.gelato.container.compose.conf }}
    - pattern: OS_AUTH_URL=.*$
    - repl: OS_AUTH_URL=http://{{ opensds.host }}/identity
    - backup: '.salt.bak'
    - require_in:
      - cmd: opensds gelato start service run compose up

opensds gelato modify configuration username:
  file.replace:
    - name: {{ opensds.gelato.container.compose.conf }}
    - pattern: OS_USERNAME=.*
    - repl: OS_USERNAME={{ opensds.gelato.service }}
    - backup: '.salt.bak'
    - require_in:
      - cmd: opensds gelato start service run compose up

opensds gelato modify configuration password:
  file.replace:
    - name: {{ opensds.gelato.container.compose.conf }}
    - pattern: OS_PASSWORD=.*
    - repl: OS_PASSWORD={{ opensds.auth.opensdsconf.keystone_authtoken.password or devstack.local.password }}
    - backup: '.salt.bak'
    - require_in:
      - cmd: opensds gelato start service run compose up

opensds gelato start service run compose up:
  cmd.run:
    - names:
      - dos2unix docker-compose.yml
      - docker-compose up -d
    - cwd: {{ opensds.gelato.dir.work }}
    - require_in:
      - cmd: opensds gelato start service wait compose up

opensds gelato start service wait compose up:
  cmd.run:
    - name: sleep 15
    - timeout: 120
    - stateful:
      - test_name: netstat -tuplan | grep 8089 2>/dev/null

  {%- endif %}
