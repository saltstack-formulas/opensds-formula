###  opensds/let/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.let.container.enabled %}
       {%- if opensds.let.container.composed %}

include:
  - opensds.envs.docker.clean

       {#- elif opensds.let.container.build #}
       {%- else %}

opensds let {{ opensds.controller.release }} container service stopped:
  docker_container.stopped:
    - names: {{ opensds.let.service }}
    - error_on_absent:False

       {%- endif %}
   {%- else %}

opensds let {{ opensds.controller.release }} kill daemon service:
  process.absent:
    - name: {{ opensds.let.service }}

   {% endif %}
