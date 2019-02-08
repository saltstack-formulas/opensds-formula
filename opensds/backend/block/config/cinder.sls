# opensds/backend/config/cinder.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "opensds/map.jinja" import opensds with context %}

   {%- if opensds.deploy_project not in ('gelato',)  %}
{%- from "opensds/map.jinja" import driver with context %}

       {%- if 'cinder' in opensds.backend.block.ids %}
           {%- set daemon = opensds.backend.block.daemon['cinder'] %}
           {%- if 'container' in  daemon.strategy|lower and 'compose' in daemon.strategy|lower %}
               {%- set container = opensds.backend.block.container['cinder'] %}

opensds backend block config cinder modify default makefile platform:
  file.replace:
    - name: {{ opensds.dir.sushi }}/cinder/{{ daemon.subdir }}/Makefile
    - pattern: 'PLATFORM ?= debian:stretch'
    - repl: 'PLATFORM ?= {{ container.compose.platform }}'
    - backup: '.salt.bak.original'
    - onlyif: test -f {{ opensds.dir.sushi }}/cinder/{{ daemon.subdir }}/Makefile

opensds backend block config cinder modify default makefile tag:
  file.replace:
    - name: {{ opensds.dir.sushi }}/cinder/{{ daemon.subdir }}/Makefile
    - pattern: 'TAG ?= debian-cinder:latest'
    - repl: 'TAG ?= {{ container.compose.tag }}'
    - backup: '.salt.bak'
    - onlyif: test -f {{ opensds.dir.sushi }}/cinder/{{ daemon.subdir }}/Makefile

opensds backend block config cinder modify default compose username:
  file.replace:
    - name: {{ opensds.dir.sushi }}/cinder/{{ daemon.subdir }}/docker-compose.yml
    - pattern: 'image: debian-cinder'
    - repl: 'image: {{ container.compose.image }}'
    - backup: '.salt.bak'
    - onlyif: test -f {{ opensds.dir.sushi }}/cinder/{{ daemon.subdir }}/docker-compose.yml

opensds backend block config cinder modify default compose image:
  file.replace:
    - name: {{ opensds.dir.sushi }}/cinder/{{ daemon.subdir }}/docker-compose.yml
    - pattern: 'image: lvm-debian-cinder'
    - repl: 'image: {{ container.compose.imagetag }}'
    - backup: '.salt.bak'
    - onlyif: test -f {{ opensds.dir.sushi }}/cinder/{{ daemon.subdir }}/docker-compose.yml

opensds backend block config cinder modify default compose dbport:
  file.replace:
    - name: {{ opensds.dir.sushi }}/cinder/{{ daemon.subdir }}/docker-compose.yml
    - pattern: '3306:3306'
    - repl: '{{ container.compose.dbports }}'
    - backup: '.salt.bak'
    - onlyif: test -f {{ opensds.dir.sushi }}/cinder/{{ daemon.subdir }}/docker-compose.yml

opensds backend block config cinder modify default volumegroup:
  file.replace:
    - name: {{ opensds.dir.sushi }}/cinder/{{ daemon.subdir }}/etc/cinder.conf
    - pattern: 'volume_group = cinder-volumes '
    - repl: 'volume_group = {{ container.compose.volumegroup }} '
    - backup: '.salt.bak'
    - onlyif: test -f {{ opensds.dir.sushi }}/cinder/{{ daemon.subdir }}/etc/cinder.conf

           {%- endif %}
       {%- endif %}
   {%- endif %}
