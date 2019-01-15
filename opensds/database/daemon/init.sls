###  opensds/database/daemon/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds, etcd  with context %}

  {%- for instance in opensds.database.instances %}
     {%- if instance in opensds.database.daemon %}

         ####################################
         #### OpenSDS Database service  #####
         ####################################
        {%- if "etcd" in opensds.database.daemon[instance|string]['strategy']|lower and not etcd.docker.enabled  %}

include:
  - etcd.install
  - etcd.service

        {%- endif %}
     {%- endif %}
  {%- endfor %}
