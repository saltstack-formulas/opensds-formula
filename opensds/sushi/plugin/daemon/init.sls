###  opensds/sushi/plugin/daemon/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.deploy_project not in ('gelato',)  %}

{%- from "opensds/map.jinja" import docker, packages, golang with context %}
{%- from 'opensds/files/macros.j2' import cp_source, build_source, cp_binaries with context %}
{%- from 'opensds/files/macros.j2' import workflow, container_run, service_run with context %}

        {%- for id in opensds.sushi.plugin.ids %}
            {%- if 'daemon' in opensds.sushi.plugin and id in opensds.sushi.plugin.daemon  %}
                {%- if opensds.sushi.plugin.daemon[id] is mapping %}

{{ workflow('opensds','sushi plugin daemon', id, opensds.sushi.plugin, opensds.dir.sushi+'/nbp', opensds, golang, opensds.sushi.plugin_type|string)}}

                {%- endif %}
            {%- endif %}
        {%- endfor %}
     {%- endif %}
