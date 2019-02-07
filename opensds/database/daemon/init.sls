###  opensds/database/daemon/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from 'opensds/map.jinja' import opensds with context %}

include:
  - opensds.database.config
    {%- if 'database' in opensds.database.daemon %}
        {%- if 'etcd' in opensds.database.daemon.database.strategy %}
  - etcd.install
  - etcd.linuxenv
            {%- if 'container' in opensds.database.daemon.database.strategy %}
  - etcd.docker.running
            {%- else %}
  - etcd.service
            {%- endif %}
        {%- endif %}
    {%- endif %}
