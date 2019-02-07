# opensds/hotpot/config/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from 'opensds/map.jinja' import opensds with context %}

    {%- if opensds.deploy_project not in ('gelato',) %}
{%- from 'opensds/files/macros.j2' import update_config with context %}

include:
  - opensds.config

        {%- for id in opensds.hotpot.ids %}
            {%- if 'opensdsconf' in opensds.hotpot and id in opensds.hotpot.opensdsconf %}
                {%- set config = opensds.hotpot.opensdsconf[id] %}
                {%- if config is mapping %}

{{ update_config('opensds','hotpot config', id, config, opensds.conf) }}

                {%- endif %}
            {%- endif %}
        {%- endfor %}
    {%- endif %}
