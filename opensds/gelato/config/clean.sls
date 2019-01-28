# opensds/gelato/config/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from 'opensds/map.jinja' import opensds with context %}

    {%- if opensds.deploy_project not in ('hotpot',) %}
{%- from 'opensds/files/macros.j2' import cleanup_files, cleanup_config with context %}

        {%- for id in opensds.gelato.ids %}
            {%- if id in opensds.gelato.opensdsconf %}

{{ cleanup_config('opensds', 'gelato config', id, opensds.conf)}}
{{ cleanup_files('opensds', 'gelato config', id, opensds.gelato) }}

            {%- endif %}
        {%- endfor %}
  {%- endif %}
