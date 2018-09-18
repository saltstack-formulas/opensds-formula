### opensds/database/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.database.container.enabled %}
        {%- if opensds.database.container.composed %}

include:
  - opensds.envs.docker.clean

        {#- elif opensds.database.container.build #}
        {%- else %}

opensds database container service stopped:
  docker_container.stopped:
    - name: {{ opensds.database.service }}
    - error_on_absent:False

        {%- endif %}
    {%- elif opensds.database.provider|lower == 'etcd' %}

include:
  - etcd.service.stopped

    {% endif %}