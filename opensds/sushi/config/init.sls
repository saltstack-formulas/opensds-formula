# opensds/sushi/config/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from 'opensds/map.jinja' import opensds with context %}

    {%- if opensds.deploy_project not in ('gelato',) %}
{%- from 'opensds/files/macros.j2' import update_config with context %}

        {%- for id in opensds.sushi.ids %}
             {%- if 'opensdsconf' in opensds.sushi and id in opensds.sushi.opensdsconf %}
                 {%- if opensds.sushi.opensdsconf[id] is mapping %}

{{ update_config('opensds','sushi config', id, opensds.sushi.opensdsconf[id], opensds.conf)}}

                 {%- endif %}
             {%- endif %}
        {%- endfor %}
  {%- endif %}
