###  opensds/sushi/plugin/daemon/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.deploy_project not in ('gelato',)  %}
{%- from 'opensds/files/macros.j2' import daemon_clean with context %}
{%- from "opensds/map.jinja" import golang, packages with context %}

        {%- for id in opensds.sushi.plugin.ids %}
           {%- if 'daemon' in opensds.sushi.plugin and id in opensds.sushi.plugin.daemon and opensds.sushi.plugin.daemon[ id ] is mapping %}

{{ daemon_clean('opensds', 'sushi plugin daemon', id, opensds.sushi.plugin, opensds.systemd, opensds.sushi.plugin_type) }}

           {%- endif %}
        {%- endfor %}
    {%- endif %}
