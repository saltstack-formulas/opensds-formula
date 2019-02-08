# opensds/hotpot/config/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.deploy_project not in ('gelato',) %}

{%- from 'opensds/files/macros.j2' import cleanup_files, cleanup_config with context %}
{%- from "opensds/map.jinja" import golang, packages with context %}

        {%- for id in opensds.hotpot.ids %}
            {%- if "opensdsconf" in opensds.hotpot and id in opensds.hotpot.opensdsconf and opensds.hotpot.opensdsconf[id] is mapping %}

{{ cleanup_config('opensds', 'hotpot config', id, opensds.conf) }}
{{ cleanup_files('opensds', 'hotpot config', id, opensds.hotpot) }}

            {%- endif %}
        {%- endfor %}
    {%- endif %}
