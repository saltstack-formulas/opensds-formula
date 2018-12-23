###  opensds/nbp/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds, docker with context %}


    {%- if opensds.nbp.container.enabled %}

opensds nbp container service running:
  docker_container.running:
    - name: {{ opensds.nbp.service }}
    - image: {{ opensds.nbp.container.image }}:{{ opensds.nbp.container.version }}
    - restart_policy: always
    - network_mode: host
         {%- if "volumes" in opensds.nbp.container %}
    - binds: {{ opensds.nbp.container.volumes }}
         {%- endif %}
         {%- if "ports" in opensds.auth.container %}
    - ports: {{ opensds.auth.container.ports }}
         {%- endif %}
         {%- if "port_bindings" in opensds.auth.container %}
    - port_bindings: {{ opensds.auth.container.port_bindings }}
         {%- endif %}
         {%- if docker.containers.skip_translate %}
    - skip_translate: {{ docker.containers.skip_translate or '' }}
         {%- endif %}
         {%- if docker.containers.force_present %}
    - force_present: {{ docker.containers.force_present }}
         {%- endif %}
         {%- if docker.containers.force_running %}
    - force_running: {{ docker.containers.force_running }}
         {%- endif %}

    {%- else %}

include:
  - iscsi.initiator
  - opensds.nbp.plugins

    {%- endif %}
