###  opensds/nbp/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.nbp.container.enabled %}
        {%- if opensds.nbp.container.composed %}

include:
  - opensds.envs.docker.clean

        {#- elif opensds.nbp.container.build #}
        {%- else %}

opensds nbp container service stopped:
  docker_container.stopped:
    - name: {{ opensds.nbp.service }}
    - error_on_absent: False

        {%- endif %}
    {% else %}

include:
  - opensds.nbp.plugins.clean
  - iscsi.initiator.remove

    {% endif %}
