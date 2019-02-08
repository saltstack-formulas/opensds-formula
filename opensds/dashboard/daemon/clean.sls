###  opensds/dashboard/daemon/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.deploy_project not in ('gelato',)  %}
{%- from 'opensds/files/macros.j2' import daemon_clean with context %}
{%- from "opensds/map.jinja" import golang, packages with context %}

        {%- for id in opensds.dashboard.ids %}
            {%- if 'daemon' in opensds.dashboard and id in opensds.dashboard.daemon and opensds.dashboard.daemon[ id ] is mapping %}

{{ daemon_clean('opensds', 'dashboard daemon', id, opensds.dashboard, opensds.systemd) }}

                    {%- if 'build' in opensds.dashboard.daemon[id]['strategy']|lower %}
opensds dashboard config {{ id }} clean angular cli:
  cmd.run:
    - name: npm uninstall -g @angular/cli
    - env:
       - GOPATH: {{ golang.go_path }}
    - onlyif:
      - npm --version 2>/dev/null
      - {{ id|lower == 'dashboard' }}
                    {%- endif %}

            {%- endif %}
        {%- endfor %}
    {%- endif %}
