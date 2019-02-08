# opensds/sushi/plugin/config/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "opensds/map.jinja" import opensds with context %}

  {%- if opensds.deploy_project not in ('gelato',)  %}
{%- from "opensds/map.jinja" import golang with context %}
      {%- for id in opensds.sushi.plugin.ids %}

              ############################################
              #### deploy opensds plugin to framework dir
              ############################################
          {%- if 'custom' in opensds.sushi.plugin and id in opensds.sushi.plugin.custom %}
              {%- set custom = opensds.sushi.plugin.custom[ id ] %}
              {%- if 'dir' in custom and 'file' in custom and custom.dir and custom.file %}

opensds sushi plugin config {{ id }} copy {{ custom.file }} to {{ custom.dir }}:
  file.copy:
    - name: {{ custom.dir }}/opensds/
    - source: {{ opensds.dir.sushi }}/nbp/{{ custom.file }}
    - force: True
    - makedirs: True
    - user: {{ opensds.user or 'root' }}
    - mode: {{ opensds.file_mode or '0644' }}
    - onlyif: test -f {{ opensds.dir.sushi }}/nbp/{{ id }}/{{ custom.file }}
              {%- endif %}
          {%- endif %}

              #######################################
              #### modify yaml files in deploy/ dir
              #######################################
          {%- set deploydir = opensds.dir.sushi + '/nbp/' + id + '/deploy' %}
          {%- if salt['cmd.run']('test -d ' ~ deploydir) %}
              {%- for file in salt['cmd.run']('ls ' ~ deploydir ~ '/*.yaml 2>/dev/null').split()  %}

opensds sushi plugin config {{ id }} set endpoint in external {{ file }} provisioner file:
  file.replace:
    - name: {{ custom.dir }}/opensds/{{ file }}
    - pattern: '^  opensdsendpoint.*$'
    - repl: '  opensdsendpoint: {{ opensds.auth.daemon.osdsauth.endpoint_ipv4 }}:{{ opensds.auth.daemon.osdsauth.endpoint_port }}'
    - not_found_content: '  opensdsendpoint: {{ opensds.auth.daemon.osdsauth.endpoint_ipv4 }}:{{ opensds.auth.daemon.osdsauth.endpoint_port }}'
    - append_if_not_found: False
    - backup: True

opensds sushi plugin config {{ id }} set auth strategy in external {{ file }} provisioner file:
  file.replace:
    - name: {{ custom.dir }}/opensds/{{ file }}
    - pattern: '^  opensdsauthstrategy.*$'
    - repl: '  opensdsauthstrategy: {{ opensds.auth.daemon.osdsauth.strategy }}'
    - not_found_content: '  opensdsauthstrategy: {{ opensds.auth.daemon.osdsauth.strategy }}'
    - append_if_not_found: False
    - backup: True

opensds sushi plugin config {{ id }} set auth url in external {{ file }} provisioner file:
  file.replace:
    - name: {{ custom.dir }}/opensds/{{ file }}
    - pattern: '^  osauthurl.*$'
    - repl: '  osauthurl: {{ opensds.auth.opensdsconf.osdsauth.keystone_authtoken.auth_url }}'
    - not_found_content: '  osauthurl: {{opensds.auth.opensdsconf.osdsauth.keystone_authtoken.auth_url}}'
    - append_if_not_found: False
    - backup: True
              {%- endfor %}
          {%- endif %}

          {%- if 'repo' in opensds.sushi.daemon.nbp %}
              {%- if 'subdirs' in opensds.sushi.plugin and opensds.sushi.plugin.subdirs is iterable %}
                  {%- set subdirs = opensds.sushi.plugin.subdirs %}

opensds sushi plugin config {{ id }} ensure nbp dir exists:
  file.directory:
    - name: {{ opensds.dir.sushi }}/nbp/{{ id }}
    - makedirs: True
    - clean: True

                      ################################
                      # deploy, examples, charts dirs
                      ################################
                  {%- for subdir in opensds.sushi.plugin.subdirs %}
opensds sushi plugin config-repo {{ id }} copy {{ subdir }} to workdir:
  cmd.run:
    - name: cp -rp {{ golang.go_path }}/src/github.com/opensds/nbp/{{ id }}/{{ subdir }} {{ opensds.dir.sushi }}/nbp/{{ id }}/
    - onlyif: test -d {{ golang.go_path }}/src/github.com/opensds/nbp/{{ id }}/{{ subdir }}
    - unless: test -d {{ opensds.dir.sushi }}/nbp/{{ id }}/{{ subdir }}

                  {%- endfor %}
              {%- endif %}
          {%- endif %}
      {%- endfor %}
  {%- endif %}
