###  opensds/gelato/config.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds, golang with context %}

  {%- if opensds.deploy_project not in ('hotpot',) %}

opensds gelato download docker-compose.yaml configuration file:
  file.managed:
    - name: {{ opensds.gelato.dir.work }}/docker-compose.yml
    - source: {{ opensds.gelato.container.compose.url }}
    - unless: {{ opensds.gelato.provider }} = 'repo'

opensds gelato modify configuration auth strategy:
  file.replace:
    - name: {{ opensds.gelato.container.compose.conf }}
    - pattern: OS_AUTH_AUTHSTRATEGY=.*$
    - repl: OS_AUTH_AUTHSTRATEGY={{ opensds.auth.provider }}
    - backup: '.salt.bak'

opensds gelato modify configuration auth url:
  file.replace:
    - name: {{ opensds.gelato.container.compose.conf }}
    - pattern: OS_AUTH_URL=.*$
    - repl: OS_AUTH_URL=http://{{ opensds.host }}/identity
    - backup: '.salt.bak'

opensds gelato modify configuration username:
  file.replace:
    - name: {{ opensds.gelato.container.compose.conf }}
    - pattern: OS_USERNAME=.*
    - repl: OS_USERNAME={{ opensds.gelato.service }}
    - backup: '.salt.bak'

opensds gelato modify configuration password strategy:
  file.replace:
    - name: {{ opensds.gelato.container.compose.conf }}
    - pattern: OS_PASSWORD=.*
    - repl: OS_PASSWORD={{ opensds.auth.opensdsconf.keystone_authtoken.password or devstack.local.password }}
    - backup: '.salt.bak'

opensds gelato start service run compose up:
  cmd.run:
    - name: docker-compose up -d
    - cwd: {{ opensds.gelato.dir }}

opensds gelato start service wait compose up:
  cmd.run:
    - name: sleep 15
    - timeout: 120
    - stateful:
      - test_name: netstat -tuplan | grep 8089 2>/dev/null

  {%- endif %}
