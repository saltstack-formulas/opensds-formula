# opensds/backend/config/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.deploy_project not in ('gelato',) %}
{%- from 'opensds/files/macros.j2' import cleanup_config, cleanup_files with context %}
{%- from "opensds/map.jinja" import golang, packages with context %}

        {%- for id in opensds.backend.ids %}
            {%- if "opensdsconf" in opensds.backend and id in opensds.backend.opensdsconf %}

{{ cleanup_config('opensds', 'backend config', id, opensds.conf) }}
{{ cleanup_files('opensds', 'backend', id, opensds.backend) }}

opensds backend config {{ id }} remove driver file:
  file.absent:
    - name: {{ opensds.dir.driver }}/{{ id }}.yaml

            {%- endif %}
        {%- endfor %}
    {%- endif %}
