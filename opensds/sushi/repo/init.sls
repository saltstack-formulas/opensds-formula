###  opensds/sushi/repo/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from 'opensds/map.jinja' import opensds with context %}

  {%- if opensds.deploy_project not in ('gelato',)  %}

{%- from 'opensds/map.jinja' import golang with context %}
{%- from 'opensds/files/macros.j2' import repo_download with context %}

      {%- for id in opensds.sushi.ids %}
          {%- if 'daemon' in opensds.sushi and id in opensds.sushi.daemon %}
              {%- set daemon = opensds.sushi.daemon[ id ] %}
              {%- if daemon is mapping and 'repo' in daemon.strategy|lower %}

{{ repo_download('opensds', 'sushi repo', id, daemon, golang.go_path + '/src/github.com/opensds') }}

              {%- endif %}
          {%- endif %}
      {%- endfor %}
  {%- endif %}
