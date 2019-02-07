###  opensds/gelato/repo/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from 'opensds/map.jinja' import opensds with context %}

    {%- if opensds.deploy_project not in ('hotpot',) %}

{%- from 'opensds/map.jinja' import golang with context %}
{%- from 'opensds/files/macros.j2' import repo_download with context %}

        {%- for id in opensds.gelato.ids %}
            {%- if id in opensds.gelato.daemon and opensds.gelato.daemon[ id ] is mapping %}
                {%- set daemon = opensds.gelato.daemon[ id ] %}
                {%- if daemon is mapping and 'repo' in daemon.strategy|lower %}

{{ repo_download('opensds', 'gelato repo', id, daemon, golang.go_path + '/src/github.com/opensds') }}

                {%- endif %}
            {%- endif %}
        {%- endfor %}
    {%- endif %}
