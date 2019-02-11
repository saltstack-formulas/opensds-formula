# opensds/sushi/plugin/config/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "opensds/map.jinja" import opensds with context %}

  {%- if opensds.deploy_project not in ('gelato',)  %}
{%- from "opensds/map.jinja" import golang with context %}
      {%- for id in opensds.sushi.plugin.ids %}
          {%- if 'repo' in opensds.sushi.daemon.nbp %}

opensds sushi plugin config {{ id }} ensure nbp dir exists:
  file.directory:
    - name: {{ opensds.dir.sushi }}/nbp/{{ id }}
    - makedirs: True
    - clean: True

              {%- if 'subdirs' in opensds.sushi.plugin and opensds.sushi.plugin.subdirs is iterable %}
                  {%- for s in opensds.sushi.plugin.subdirs %}

opensds sushi plugin config-repo {{ id }} copy {{ s }} to workdir:
  cmd.run:
    - unless: test -d {{ opensds.dir.sushi }}/nbp/{{ id }}/{{ s }}
                      {%- if id|lower == 'provisioner' %}
    - name: cp -rp {{golang.go_path}}/src/github.com/opensds/nbp/opensds-{{id}}/{{s}} {{opensds.dir.sushi}}/nbp/{{id}}/
    - onlyif: test -d {{ golang.go_path }}/src/github.com/opensds/nbp/opensds-{{ id }}/{{ s }}
                      {%- else %}
    - name: cp -rp {{golang.go_path}}/src/github.com/opensds/nbp/{{id}}/{{s}} {{opensds.dir.sushi}}/nbp/{{id}}/
    - onlyif: test -d {{ golang.go_path }}/src/github.com/opensds/nbp/{{ id }}/{{ s }}

                      {%- endif %}
                  {%- endfor %}
              {%- endif %}

              {%- if 'custom' in opensds.sushi.plugin and id in opensds.sushi.plugin.custom %}
                  {%- set custom = opensds.sushi.plugin.custom[ id ] %}

                      ##############################
                      # deploy plugin to filesystem
                      ##############################
                  {%- if 'file' in custom and custom.file and 'dir' in custom and custom.dir %}
opensds sushi plugin config {{ id }} copy {{ custom.file }} to {{ opensds.dir.sushi }}/nbp/{{ id }}:
  file.copy:
    - name: {{ custom.dir }}/opensds
    - source: {{ opensds.dir.sushi }}/nbp/{{ custom.file }}
    - force: True
    - makedirs: True
    - user: {{ opensds.user or 'root' }}
    - mode: {{ opensds.file_mode or '0644' }}
    - onlyif: test -f {{ opensds.dir.sushi }}/nbp/{{ id }}/{{ custom.file }}

                  {%- elif custom is iterable and custom is not string %}
                      ##############################
                      # customize plugin yaml files
                      ##############################
                      {%- for file in custom  %}

opensds sushi plugin config {{ id }} set opensdsendpoint in external {{ file }} file:
  file.replace:
    - name: {{ opensds.dir.sushi }}/nbp/{{ id }}/{{ file }}
    - pattern: '^  opensdsendpoint.*$'
    - repl: '  opensdsendpoint: {{ opensds.auth.daemon.osdsauth.endpoint_ipv4 }}:{{ opensds.auth.daemon.osdsauth.endpoint_port }}'
    - onlyif: test -f {{ opensds.dir.sushi }}/nbp/{{ id }}/{{ file }}

opensds sushi plugin config {{ id }} set opensdsauthstrategy in external {{ file }} file:
  file.replace:
    - name: {{ opensds.dir.sushi }}/nbp/{{ id }}/{{ file }}
    - pattern: '^  opensdsauthstrategy.*$'
    - repl: '  opensdsauthstrategy: {{ opensds.hotpot.opensdsconf.osdslet.auth_strategy }}'
    - onlyif: test -f {{ opensds.dir.sushi }}/nbp/{{ id }}/{{ file }}

opensds sushi plugin config {{ id }} set osauthurl in external {{ file }} file:
  file.replace:
    - name: {{ opensds.dir.sushi }}/nbp/{{ id }}/{{ file }}
    - pattern: '^  osauthurl.*$'
    - repl: '  osauthurl: {{ opensds.auth.opensdsconf.keystone_authtoken.auth_url }}'
    - onlyif: test -f {{ opensds.dir.sushi }}/nbp/{{ id }}/{{ file }}

opensds sushi plugin config {{ id }} set osusername in external {{ file }} file:
  file.replace:
    - name: {{ opensds.dir.sushi }}/nbp/{{ id }}/{{ file }}
    - pattern: '^  osusername.*$'
    - repl: '  osusername: {{ opensds.auth.opensdsconf.osdsauth.keystone_authtoken.username }}'
    - onlyif: test -f {{ opensds.dir.sushi }}/nbp/{{ id }}/{{ file }}

opensds sushi plugin config {{ id }} set ospassword in external {{ file }} file:
  file.replace:
    - name: {{ opensds.dir.sushi }}/nbp/{{ id }}/{{ file }}
    - pattern: '^  ospassword.*$'
    - repl: '  ospassword: {{ opensds.auth.opensdsconf.osdsauth.keystone_authtoken.password }}'
    - onlyif: test -f {{ opensds.dir.sushi }}/nbp/{{ id }}/{{ file }}

opensds sushi plugin config {{ id }} set osprojectname in external {{ file }} file:
  file.replace:
    - name: {{ opensds.dir.sushi }}/nbp/{{ id }}/{{ file }}
    - pattern: '^  osprojectname.*$'
    - repl: '  osprojectname: {{ opensds.auth.opensdsconf.osdsauth.keystone_authtoken.project_name }}'
    - onlyif: test -f {{ opensds.dir.sushi }}/nbp/{{ id }}/{{ file }}

opensds sushi plugin config {{ id }} set osuserdomainid in external {{ file }} file:
  file.replace:
    - name: {{ opensds.dir.sushi }}/nbp/{{ id }}/{{ file }}
    - pattern: '^  osuserdomainid.*$'
    - repl: '  osuserdomainid: {{ opensds.auth.opensdsconf.osdsauth.keystone_authtoken.user_domain_name }}'
    - onlyif: test -f {{ opensds.dir.sushi }}/nbp/{{ id }}/{{ file }}

                      {%- endfor %}
                  {%- endif %}
              {%- endif %}
          {%- endif %}
      {%- endfor %}
  {%- endif %}
