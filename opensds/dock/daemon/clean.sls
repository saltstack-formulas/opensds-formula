###  opensds/dock/daemon/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from 'opensds/map.jinja' import opensds with context %}

    {%- if opensds.deploy_project not in ('gelato',)  %}
{%- from 'opensds/files/macros.j2' import daemon_clean with context %}

       {%- for id in opensds.dock.ids %}
           {%- if 'daemon' in opensds.dock and id in opensds.dock.daemon and opensds.dock.daemon[id] is mapping%}

{{ daemon_clean('opensds', 'hotpot daemon', id, opensds.dock, opensds.systemd) }}

           {%- endif %}
       {%- endfor %}
    {%- endif %}
