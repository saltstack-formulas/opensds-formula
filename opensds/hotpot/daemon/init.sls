###  opensds/hotpot/daemon/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "opensds/map.jinja" import opensds with context %}

  {%- if opensds.deploy_project not in ('gelato',)  %}

{%- from "opensds/map.jinja" import packages, docker, golang with context %}
{%- from 'opensds/files/macros.j2' import cp_source, build_source, cp_binaries with context %}
{%- from 'opensds/files/macros.j2' import workflow, container_run, service_run with context %}

include:
  - opensds.hotpot.config

    {%- for id in opensds.hotpot.ids %}
      {% if 'daemon' in opensds.hotpot and id in opensds.hotpot.daemon and opensds.hotpot.daemon[id] is mapping %}

{{ workflow('opensds', 'hotpot daemon', id, opensds.hotpot, opensds.dir.hotpot, opensds) }}

            {%- endif %}
        {%- endfor %}
    {%- endif %}
