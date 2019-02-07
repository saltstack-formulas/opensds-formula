# opensds/sushi/config/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from 'opensds/map.jinja' import opensds with context %}

    {%- if opensds.deploy_project not in ('gelato',) %}
{%- from 'opensds/files/macros.j2' import cleanup_config, cleanup_files with context %}

        {%- for id in opensds.sushi.ids %}
            {%- if id in opensds.sushi.opensdsconf and opensds.sushi.opensdsconf[id] is mapping %}

{{ cleanup_config('opensds', 'sushi config', id, opensds.conf)}}

            {%- endif %}
        {%- endfor %}
    {%- endif %}
