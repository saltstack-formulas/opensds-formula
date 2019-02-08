# opensds/auth/config/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from 'opensds/map.jinja' import opensds, golang with context %}

    {%- if opensds.deploy_project not in ('gelato',) %}
{%- from 'opensds/files/macros.j2' import cleanup_config, cleanup_files with context %}

        {%- for id in opensds.auth.ids %}
            {%- if id in opensds.auth.opensdsconf %}

{{ cleanup_config('opensds', 'auth config', id, opensds.conf)}}
{{ cleanup_files('opensds', 'auth config', id, opensds.auth) }}

            {%- endif %}
        {%- endfor %}
    {%- endif %}
