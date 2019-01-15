###  opensds/gelato/container/build.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds, docker with context %}

  {%- if opensds.deploy_project not in ('hotpot',) %}

include:
  - opensds.config

    {%- for instance in opensds.gelato.instances %}
       {%- if instance in opensds.gelato.container %}
         {%- set container = opensds.gelato.container[ instance|string ] %}

             ##########################
             #### BUILD CONTAINERS ####
             ##########################
         {%- if container.enabled and container.build %}

opensds gelato container build {{ instance }} ensure directory:
  file.directory:
    - name: {{ opensds.dir.gelato }}/container/{{ instance }}
    - makedirs: True
    - force: True
    - user: {{ opensds.user or 'root' }}
    - dir_mode: {{ opensds.dir_mode or '0755' }}
    - recurse:
      - user
      - mode

opensds gelato container build {{ instance }} download docker-compose.yml file:
  file.managed:
    - name: {{ opensds.dir.gelato }}/container/{{ instance }}/docker-compose.yml
    - source: {{ container.compose.url }}
    - source_hash: {{ container.compose.hash }}
    - require:
      - file: opensds gelato container build {{ instance }} ensure directory
    - require_in:
      - cmd: opensds gelato container build {{ instance }} run compose

opensds gelato container build {{ instance }} modify configuration auth strategy:
  file.replace:
    - name: {{ opensds.dir.gelato }}/container/{{ instance }}/docker-compose.yml
    - pattern: OS_AUTH_AUTHSTRATEGY=.*$
    - repl: OS_AUTH_AUTHSTRATEGY={{ opensds.auth.daemon.osdsauth.strategy }}
    - backup: '.salt.bak'
    - require_in:
      - cmd: opensds gelato container build {{ instance }} run compose

opensds gelato container build {{ instance }} modify configuration auth url:
  file.replace:
    - name: {{ opensds.dir.gelato }}/container/{{ instance }}/docker-compose.yml
    - pattern: OS_AUTH_URL=.*$
    - repl: OS_AUTH_URL=http://{{ opensds.host }}/identity
    - backup: '.salt.bak'
    - require_in:
      - cmd: opensds gelato container build {{ instance }} run compose

opensds gelato container build {{ instance }} modify configuration username:
  file.replace:
    - name: {{ opensds.dir.gelato }}/container/{{ instance }}/docker-compose.yml
    - pattern: OS_USERNAME=.*
    - repl: OS_USERNAME={{ opensds.gelato.service }}
    - backup: '.salt.bak'
    - require_in:
      - cmd: opensds gelato container build {{ instance }} run compose

opensds gelato container build {{ instance }} modify configuration password:
  file.replace:
    - name: {{ opensds.dir.gelato }}/container/{{ instance }}/docker-compose.yml
    - pattern: OS_PASSWORD=.*
    - repl: OS_PASSWORD={{ devstack.local.password }}
    - backup: '.salt.bak'
    - require_in:
      - cmd: opensds gelato container build {{ instance }} run compose

#### Service is managed by systemd per opensds/gelato/daemon/init.sls #####

         {%- endif %}
       {%- endif %}
    {%- endfor %}
  {%- endif %}
