###  opensds/backend/block/daemon/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from 'opensds/map.jinja' import opensds with context %}

    {%- if opensds.deploy_project not in ('gelato',)  %}
{%- from 'opensds/files/macros.j2' import daemon_clean with context %}

        {%- for id in opensds.backend.block.ids %}
           {%- if 'daemon' in opensds.backend.block and id in opensds.backend.block.daemon  %}  
               {%- if opensds.backend.block.daemon[ id ] is mapping %}

{{ daemon_clean('opensds', 'backend block daemon', id, opensds.backend.block, opensds.systemd) }}

               {%- endif %}
           {%- endif %}
        {%- endfor %}
    {%- endif %}
