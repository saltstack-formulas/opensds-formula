###  opensds/let/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds with context %}


    {%- if opensds.let.container.enabled %}

opensds let container service stopped:
  docker_container.stopped:
    - name: {{ opensds.let.service }}
    - error_on_absent: False

   {%- else %}

opensds let kill daemon service:
  service.dead:
    - name: {{ opensds.let.service }}

   {% endif %}
