# opensds/auth/config/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from 'opensds/map.jinja' import opensds with context %}

    {%- if opensds.deploy_project not in ('gelato',) %}
{%- from 'opensds/files/macros.j2' import update_config with context %}

include:
  - opensds.config

        {%- for id in opensds.auth.ids %}
            {%- if 'opensdsconf' in opensds.auth and id in opensds.auth.opensdsconf %}
                {%- set config = opensds.auth.opensdsconf[id] %}
                {%- if config is mapping %}

{{ update_config('opensds','auth config', id, config, opensds.conf) }}

                {%- endif %}
            {%- endif %}
        {%- endfor %}
    {%- endif %}
