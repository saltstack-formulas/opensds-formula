###  opensds/gelato/daemon/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from 'opensds/map.jinja' import opensds with context %}

    {%- if opensds.deploy_project not in ('gelato',)  %}
{%- from 'opensds/files/macros.j2' import daemon_clean with context %}

        {%- for id in opensds.gelato.ids %}
            {%- if 'keystone' in opensds.gelato.daemon[id]|lower %}
#include:
#  - devstack.remove

            {%- elif 'daemon' in opensds.gelato and id in opensds.gelato.daemon %}
                {%- if opensds.gelato.daemon[id] is mapping %}

{{ daemon_clean('opensds', 'gelato daemon', id, opensds.gelato, opensds.systemd) }}

                {%- endif %}
            {%- endif %}
        {%- endfor %}
   {%- endif %}
