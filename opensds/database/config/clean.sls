# opensds/database/config/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.deploy_project not in ('gelato',) %}
{%- from 'opensds/files/macros.j2' import cleanup_config with context %}
{%- from "opensds/map.jinja" import golang, packages with context %}

        {%- for id in opensds.database.ids %}
            {%- if "opensdsconf" in opensds.database and id in opensds.database.opensdsconf %}

{{ cleanup_config('opensds', 'database config', id, opensds.conf)}}

            {%- endif %}
        {%- endfor %}
    {%- endif %}
