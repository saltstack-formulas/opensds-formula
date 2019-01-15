###  opensds/auth/daemon/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds with context %}

  {%- for instance in opensds.auth.instances %}
      {%- if instance in opensds.auth.daemon %}

         #########################################
         #### OpenSDS Auth keystone service  #####
         #########################################
         {%- if "keystone" in opensds.auth.daemon[instance|string]['strategy']|lower %}

include:
  - devstack.cli

         {%- endif %}
      {%- endif %}
  {%- endfor %}
