###  opensds/auth/daemon/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "opensds/map.jinja" import opensds with context %}

  {%- for instance in opensds.auth.instances %}
    {%- if instance in opensds.auth.daemon and opensds.auth.daemon[ instance|string ] is mapping %}
        {%- set daemon = opensds.auth.daemon[ instance|string ] %}

         #########################################
         #### OpenSDS auth keystone service  #####
         #########################################
        {%- if "keystone" in daemon.strategy|lower %}

         ## skipping 'include: - devstack.remove'

        {%- endif %}
    {%- endif %}
  {%- endfor %}
