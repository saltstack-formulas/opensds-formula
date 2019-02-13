###  opensds/dashboard/daemon/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.deploy_project not in ('gelato',)  %}

{%- from "opensds/map.jinja" import packages, docker, golang with context %}
{%- from 'opensds/files/macros.j2' import cp_source, build_source, copy_build with context %}
{%- from 'opensds/files/macros.j2' import workflow, container_run, service_run with context %}

include:
  - opensds.dashboard.config

        {%- for id in opensds.dashboard.ids %}
            {%- if 'daemon' in opensds.dashboard and id in opensds.dashboard.daemon  %}
                {%- if opensds.dashboard.daemon[ id ]|lower is mapping %}

                    {%- if 'container' in opensds.dashboard.daemon[ id ]['strategy']|lower %}
opensds dashboard daemon {{ id }} ensure nginx stopped and disabled:
  service.dead:
    - name: nginx
    - enable: False
                    {%- endif %}

                    {%- if 'build' in opensds.dashboard.daemon[ id ]['strategy']|lower %}
opensds dashboard config install angular cli:
  cmd.run:
    - name: 'npm install -g @angular/cli'
    - env:
      - GOPATH: {{ golang.go_path }}
    - onlyif:
      - npm --version 2>/dev/null
      - {{ id|lower == 'dashboard' }}
   - unless: {{ 'container' in opensds.dashboard.daemon[ id ]|lower }}
                    {%- endif %}

{{ workflow('opensds', 'dashboard daemon', id, opensds.dashboard, opensds.dir.dashboard, opensds.systemd) }}

                {%- endif %}
            {%- endif %}
        {%- endfor %}
    {%- endif %}
