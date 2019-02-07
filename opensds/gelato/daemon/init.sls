###  opensds/gelato/daemon/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from 'opensds/map.jinja' import opensds with context %}

    {%- if opensds.deploy_project not in ('hotpot',)  %}

{%- from 'opensds/map.jinja' import docker, packages, golang with context %}
{%- from 'opensds/files/macros.j2' import cp_source, build_source, cp_binaries with context %}
{%- from 'opensds/files/macros.j2' import workflow, container_run, service_run with context %}

include:
  - opensds.gelato.config
  - devstack.cli

        {%- for id in opensds.gelato.ids %}
           {%- if 'daemon' in opensds.gelato and id in opensds.gelato.daemon %}
               {%- if opensds.gelato.daemon[ id ] is mapping %}

{{ workflow('opensds', 'gelato daemon', id, opensds.gelato, opensds.dir.gelato, opensds.systemd) }}

               {%- endif %}
           {%- endif %}
        {%- endfor %}
    {%- endif %}
