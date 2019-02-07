# opensds/dock/config/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from 'opensds/map.jinja' import opensds with context %}

    {%- if opensds.deploy_project not in ('gelato',) %}
{%- from 'opensds/files/macros.j2' import cleanup_files, cleanup_config with context %}

include:
  - opensds.macros

        {%- for id in opensds.dock.ids %}
            {%- if id in opensds.dock.opensdsconf %}

{{ cleanup_config('opensds', 'dock config', id, opensds.conf)}}
{{ cleanup_files('opensds', 'dock config', id, opensds.dock) }}

            {%- endif %}
        {%- endfor %}
    {%- endif %}
