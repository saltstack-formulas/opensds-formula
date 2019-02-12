### opensds/backend/config/cinderbox.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "opensds/map.jinja" import opensds with context %}

   {%- if opensds.deploy_project not in ('gelato',)  %}
       {%- if 'cinder' in opensds.backend.block.ids and 'daemon' in opensds.backend.block %}
           {%- set daemon = opensds.backend.block.daemon['cinder'] %}
           {%- if 'compose' in daemon.strategy|lower and 'cinder' in opensds.backend.block.container %}
               {%- set container = opensds.backend.block.container['cinder'] %}
           {%- endif %}

           ###################
           # Custom makefiles
           ###################

opensds backend block config cinder Makefile set platform:
  file.replace:
    - name: {{ opensds.dir.sushi }}/cinder/contrib/block-box/Makefile
    - pattern: 'PLATFORM ?= debian:stretch'
    - repl: 'PLATFORM ?= {{ container.compose.platform }}'
    - backup: '.salt.bak.original'
    - onlyif: test -f {{ opensds.dir.sushi }}/cinder/contrib/block-box/Makefile

opensds backend block config cinder Makefile set image tag:
  file.replace:
    - name: {{ opensds.dir.sushi }}/cinder/contrib/block-box/Makefile
    - pattern: 'TAG ?= debian-cinder:latest'
    - repl: 'TAG ?= {{ container.compose.tag }}'
    - backup: '.salt.bak'
    - onlyif: test -f {{ opensds.dir.sushi }}/cinder/contrib/block-box/Makefile

opensds backend block config cinder docker-compose modify default username:
  file.replace:
    - name: {{ opensds.dir.sushi }}/cinder/contrib/block-box/docker-compose.yml
    - pattern: 'image: debian-cinder'
    - repl: 'image: {{ container.compose.image }}'
    - backup: '.salt.bak'
    - onlyif: test -f {{ opensds.dir.sushi }}/cinder/contrib/block-box/docker-compose.yml

opensds backend block config cinder docker-compose set image:
  file.replace:
    - name: {{ opensds.dir.sushi }}/cinder/contrib/block-box/docker-compose.yml
    - pattern: 'image: lvm-debian-cinder'
    - repl: 'image: {{ container.compose.imagetag }}'
    - backup: '.salt.bak'
    - onlyif: test -f {{ opensds.dir.sushi }}/cinder/contrib/block-box/docker-compose.yml

opensds backend block config cinder docker-compose set dbport:
  file.replace:
    - name: {{ opensds.dir.sushi }}/cinder/contrib/block-box/docker-compose.yml
    - pattern: '3306:3306'
    - repl: '{{ container.compose.dbports }}'
    - backup: '.salt.bak'
    - onlyif: test -f {{ opensds.dir.sushi }}/cinder/contrib/block-box/docker-compose.yml

               ###########################
               # update cinder.conf files
               ###########################
           {%- if 'custom' in opensds.backend.block and'cinder'in opensds.backend.block.custom %}
               {%- if opensds.backend.block.custom['cinder'] is iterable %}
                   {%- for file in opensds.backend.block.custom['cinder'] %}

opensds backend block config cinder {{ file }} modify default volumegroup:
  file.replace:
    - name: {{ opensds.dir.sushi }}/cinder/contrib/block-box/etc/cinder.conf
    - pattern: 'volume_group = cinder-volumes '
    - repl: 'volume_group = {{ container.compose.volumegroup }} '
    - backup: '.salt2.bak'
    - onlyif: test -f {{ opensds.dir.sushi }}/cinder/contrib/block-box/etc/cinder.conf

opensds backend block config cinder {{ file }} modify default enabled_backends:
  file.replace:
    - name: {{ opensds.dir.sushi }}/cinder/contrib/block-box/etc/cinder.conf
    - pattern: 'enabled_backends.*'
    - repl: 'enabled_backends = lvm'   {#getlist(opensds.backend.block.enabled_backends)#}
    - onlyif: test -f {{ opensds.dir.sushi }}/cinder/contrib/block-box/etc/cinder.conf

#opensds backend block config cinder {{ file }} modify default volumes_dir:
#  file.replace:
#    - name: {{ opensds.dir.sushi }}/cinder/contrib/block-box/etc/cinder.conf
#    - pattern: 'volumes_dir.*'
#    - repl: 'volumes_dir = {{ opensds.dir.hotpot }}/volumegroups/'
#    - onlyif: test -f {{ opensds.dir.sushi }}/cinder/contrib/block-box/etc/cinder.conf

                       {%- if "DISABLED DISABLED keystone" in file %}

opensds backend block config cinder {{ file }} set opensdsendpoint:
  file.replace:
    - name: {{ opensds.dir.sushi }}/cinder/contrib/block-box/{{ file }}
    - pattern: '^www_authenticate_uri.*$'
    - repl: 'www_authenticate_uri = {{ opensds.auth.daemon.osdsauth.endpoint_ipv4 }}:{{ opensds.auth.daemon.osdsauth.endpoint_port }}'
    - onlyif: test -f {{ opensds.dir.sushi }}/cinder/contrib/block-box/{{ file }}

opensds backend block config cinder {{ file }} set auth_type:
  file.replace:
    - name: {{ opensds.dir.sushi }}/cinder/contrib/block-box/{{ file }}
    - pattern: '^auth_type.*$'
    - repl: 'auth_type = password'
    - onlyif: test -f {{ opensds.dir.sushi }}/cinder/contrib/block-box/{{ file }}

opensds backend block config cinder {{ file }} set auth_url:
  file.replace:
    - name: {{ opensds.dir.sushi }}/cinder/contrib/block-box/{{ file }}
    - pattern: '^auth_url.*$'
    - repl: 'auth_url = {{ opensds.auth.opensdsconf.keystone_authtoken.auth_url }}'
    - onlyif: test -f {{ opensds.dir.sushi }}/cinder/contrib/block-box/{{ file }}

opensds backend block config cinder {{ file }} set memcached_servers:
  file.replace:
    - name: {{ opensds.dir.sushi }}/cinder/contrib/block-box/{{ file }}
    - pattern: '^memcached_servers.*$'
    - repl: 'memcached_servers = {{ opensds.auth.daemon.osdsauth.endpoint_ipv4 }}:11211'
    - onlyif: test -f {{ opensds.dir.sushi }}/cinder/contrib/block-box/{{ file }}

opensds backend block config cinder {{ file }} set username:
  file.replace:
    - name: {{ opensds.dir.sushi }}/cinder/contrib/block-box/{{ file }}
    - pattern: '^username.*$'
    - repl: 'username = {{ opensds.backend.drivers.cinder.authOptions.username }}'
    - onlyif: test -f {{ opensds.dir.sushi }}/cinder/contrib/block-box/{{ file }}

opensds backend block config cinder {{ file }} set password:
  file.replace:
    - name: {{ opensds.dir.sushi }}/cinder/contrib/block-box/{{ file }}
    - pattern: '^password.*$'
    - repl: 'password = {{ opensds.backend.drivers.cinder.authOptions.password }}'
    - onlyif: test -f {{ opensds.dir.sushi }}/cinder/contrib/block-box/{{ file }}

opensds backend block config cinder {{ file }} set project_domain_name:
  file.replace:
    - name: {{ opensds.dir.sushi }}/cinder/contrib/block-box/{{ file }}
    - pattern: '^project_domain_name.*$'
    - repl: 'project_domain_name = {{ opensds.backend.drivers.cinder.authOptions.domainId }}'
    - onlyif: test -f {{ opensds.dir.sushi }}/cinder/contrib/block-box/{{ file }}

opensds backend block config cinder {{ file }} set user_domain_name:
  file.replace:
    - name: {{ opensds.dir.sushi }}/cinder/contrib/block-box/{{ file }}
    - pattern: '^user_domain_name.*$'
    - repl: 'user_domain_name = {{ opensds.backend.drivers.cinder.authOptions.domainName }}'
    - onlyif: test -f {{ opensds.dir.sushi }}/cinder/contrib/block-box/{{ file }}

opensds backend block config cinder {{ file }} set project_name:
  file.replace:
    - name: {{ opensds.dir.sushi }}/cinder/contrib/block-box/{{ file }}
    - pattern: '^project_name.*$'
    - repl: 'project_name = {{ opensds.backend.drivers.cinder.authOptions.projectName }}'
    - onlyif: test -f {{ opensds.dir.sushi }}/cinder/contrib/block-box/{{ file }}

opensds backend block config cinder {{ file }} set connection:
  file.replace:
    - name: {{ opensds.dir.sushi }}/cinder/contrib/block-box/{{ file }}
    - pattern: '^connection.*$'
    - repl: 'connection = mysql:{{ opensds.database.opensdsconf.database.credential }}'
    - onlyif: test -f {{ opensds.dir.sushi }}/cinder/contrib/block-box/{{ file }}

                       {%- endif %}
                   {%- endfor %}
               {%- endif %}
           {%- endif %}
      {%- endif %}
  {%- endif %}
