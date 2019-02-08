###  opensds/backend/block/daemon/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.deploy_project not in ('gelato',)  %}

{%- from "opensds/map.jinja" import docker, packages, golang with context %}
{%- from 'opensds/files/macros.j2' import cp_source, build_source, cp_binaries with context %}
{%- from 'opensds/files/macros.j2' import workflow, container_run, service_run with context %}

include:
  - opensds.backend.block.config

      {%- for id in opensds.backend.block.ids %}
          {%- if 'daemon' in opensds.backend.block and id in opensds.backend.block.daemon  %}
              {%- if opensds.backend.block.daemon[ id ] is mapping %}

{{ workflow('opensds', 'backend block daemon', id, opensds.backend.block, opensds.dir.sushi, opensds.systemd) }}

              {%- endif %}
          {%- endif %}
      {%- endfor %}
   {%- endif %}
