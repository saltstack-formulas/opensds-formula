# opensds/dashboard/config/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from 'opensds/map.jinja' import opensds with context %}

    {%- if opensds.deploy_project not in ('gelato',) %}

{%- from 'opensds/map.jinja' import golang with context %}
{%- from 'opensds/files/macros.j2' import update_config with context %}

include:
  - opensds.config
  - opensds.dashboard.config.nginx

       {%- for id in opensds.dashboard.ids %}
           {%- if 'opensdsconf' in opensds.dashboard and id in opensds.dashboard.opensdsconf %}
               {%- set config = opensds.dashboard.opensdsconf[id] %}
               {%- if config is mapping %}

{{ update_config('opensds','dashboard config', id, config, opensds.conf) }}

               {%- endif %}
           {%- endif %}

       {%- endfor %}
    {%- endif %}
