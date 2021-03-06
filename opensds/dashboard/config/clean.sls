# opensds/dashboard/config/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.deploy_project not in ('gelato',) %}

{%- from 'opensds/files/macros.j2' import cleanup_files, cleanup_config with context %}
{%- from "opensds/map.jinja" import golang, packages with context %}

        {%- for id in opensds.dashboard.ids %}
            {%- if "opensdsconf" in opensds.dashboard and id in opensds.dashboard.opensdsconf %}

{{ cleanup_config('opensds', 'dashboard config', id, opensds.conf) }}
{{ cleanup_files('opensds', 'dashboard config', id, opensds.dir.dashboard) }}

            {%- endif %}
        {%- endfor %}
    {%- endif %}
