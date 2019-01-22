###  opensds/database/daemon/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds, etcd with context %}

  {%- for instance in opensds.database.instances %}

        ####################################
        #### OpenSDS Database service  #####
        ####################################
     {%- if instance in opensds.database and "etcd" in opensds.database.daemon[instance|string]['strategy']|lower and not etcd.docker.enabled %}

include:
  - etcd.service.stopped
  - etcd.remove

     {%- endif %}
  {%- endfor %}
