###  opensds/backend/block/repo/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "opensds/map.jinja" import opensds with context %}

  {%- if opensds.deploy_project not in ('gelato',)  %}

{%- from "opensds/map.jinja" import golang with context %}
{%- from 'opensds/files/macros.j2' import repo_download with context %}

      {%- if opensds.backend.block.ids is iterable and opensds.backend.block.ids is string %}
          {%- set backends = opensds.backend.block.ids.split(', ') %}
      {%- else %}
          {%- set backends = opensds.backend.block.ids %}
      {%- endif %}
      {%- for id in backends %}
          {%- if 'daemon' in opensds.backend.block and id in opensds.backend.block.daemon %}
              {%- set daemon = opensds.backend.block.daemon[ id ] %}
              {%- if daemon is mapping and 'repo' in daemon.strategy|lower %}

{{ repo_download('opensds', 'backend block repo', id, daemon, opensds.dir.sushi) }}

              {%- endif %}
          {%- endif %}
      {%- endfor %}
  {%- endif %}
