# opensds/backend/config/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.deploy_project not in ('gelato',) %}
{%- from 'opensds/files/macros.j2' import update_config with context %}

include:
  - opensds.config

        {%- for id in opensds.backend.ids %}
            {%- if 'opensdsconf' in opensds.backend and id in opensds.backend.opensdsconf %}
                {%- set config = opensds.backend.opensdsconf[id] %}
                {%- if config %}

{{ update_config('opensds','backend config', id, config, opensds.conf) }}

                {%- endif %}
            {%- endif %}
        {%- endfor %}
    {%- endif %}
