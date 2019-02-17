# opensds/dock/config/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.deploy_project not in ('gelato',) %}
{%- from 'opensds/files/macros.j2' import update_config, create_dir with context %}

include:
  - opensds.config

        {%- for id in opensds.dock.ids %}
            {%- if 'opensdsconf' in opensds.dock and id in opensds.dock.opensdsconf %}
                {%- set config = opensds.dock.opensdsconf[id] %}
                {%- if config is mapping %}

{{ update_config('opensds','dock config', id, config, opensds.conf) }}

                {%- endif %}
            {%- endif %}
        {%- endfor %}

{{ create_dir('opensds','dock config', 'volumegroups', opensds.dir.hotpot) }}
    {%- endif %}
