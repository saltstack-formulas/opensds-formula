###  opensds/hotpot/daemon/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.deploy_project not in ('gelato',)  %}

{%- from 'opensds/files/macros.j2' import daemon_clean with context %}
{%- from "opensds/map.jinja" import golang, packages with context %}

        {%- for id in opensds.hotpot.ids %}
            {%- if 'daemon' in opensds.hotpot and id in opensds.hotpot.daemon  %}
                {%- if opensds.hotpot.daemon[id] is mapping %}

{{ daemon_clean('opensds', 'hotpot daemon', id, opensds.hotpot, opensds.systemd) }}

                {%- endif %}
            {%- endif %}
        {%- endfor %}
    {%- endif %}
