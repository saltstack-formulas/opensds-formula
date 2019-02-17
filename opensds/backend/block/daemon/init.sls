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

      {%- if opensds.backend.block.ids is iterable and opensds.backend.block.ids is string %}
          {%- set backends = opensds.backend.block.ids.split(', ') %}
      {%- else %}
          {%- set backends = opensds.backend.block.ids %}
      {%- endif %}
      {%- for id in backends %}
          {%- if 'daemon' in opensds.backend.block and id in opensds.backend.block.daemon  %}
              {%- if opensds.backend.block.daemon[ id ] is mapping %}

    {%- if id == 'cinder' and  grains.os in ('CentOS', ) %}
opensds infra use git2 on EL:
  pkg.installed:
    - sources:
      - ius-release: https://centos7.iuscommunity.org/ius-release.rpm
  cmd.run:
    - name: yum swap git git2u -y
  {%- endif %}

{{ workflow('opensds', 'backend block daemon', id, opensds.backend.block, opensds.dir.sushi, opensds, golang) }}

              {%- endif %}
          {%- endif %}
      {%- endfor %}
  {%- endif %}
