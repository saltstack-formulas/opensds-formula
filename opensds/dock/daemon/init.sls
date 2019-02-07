{%- from 'opensds/map.jinja' import opensds with context %}

    {%- if opensds.deploy_project not in ('gelato',)  %}

{%- from 'opensds/map.jinja' import packages, docker, golang with context %}
{%- from 'opensds/files/macros.j2' import create_dir, cp_source, build_source, cp_binaries with context %}
{%- from 'opensds/files/macros.j2' import workflow, container_run, service_run with context %}

include:
  - opensds.dock.config

      {%- for id in opensds.dock.ids %}
        {% if 'daemon' in opensds.dock and id in opensds.dock.daemon and opensds.dock.daemon[id] is mapping %}

{{ workflow('opensds', 'dock daemon', id, opensds.dock, opensds.dir.hotpot, opensds.systemd) }}

        {%- endif %}
      {%- endfor %}
    {%- endif %}
