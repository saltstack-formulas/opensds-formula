###  opensds/database/daemon/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "opensds/map.jinja" import opensds, golang with context %}

include:
    {%- if 'etcd' in opensds.database.daemon %}
        {%- if 'container' in opensds.database.daemon.etcd.strategy|lower %}
  - etcd.docker.stopped
          {%- else %}
  - etcd.service.stopped
          {%- endif %}
  - etcd.remove
     {%- endif %}
  - opensds.database.config.clean
