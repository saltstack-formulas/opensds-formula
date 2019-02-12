###  opensds/backend/block/daemon/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "opensds/map.jinja" import opensds with context %}

  {%- if opensds.deploy_project not in ('gelato',)  %}

{%- from 'opensds/files/macros.j2' import daemon_clean with context %}
{%- from "opensds/map.jinja" import golang, packages with context %}

      {%- if opensds.backend.block.ids is iterable and opensds.backend.block.ids is string %}
          {%- set backends = opensds.backend.block.ids.split(', ') %}
      {%- else %}
          {%- set backends = opensds.backend.block.ids %}
      {%- endif %}
      {%- for id in backends %}
          {%- if 'daemon' in opensds.backend.block and id in opensds.backend.block.daemon  %}  
              {%- if opensds.backend.block.daemon[ id ] is mapping %}

{{ daemon_clean('opensds', 'backend block daemon', id, opensds.backend.block, opensds.systemd) }}

              {%- endif %}
          {%- endif %}
      {%- endfor %}
  {%- endif %}
