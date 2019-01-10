###  opensds/gelato/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds, golang with context %}

  {%- if opensds.deploy_project not in ('hotpot',) %}

opensds gelato ensure opensds dirs exist:
  file.directory:
    - names:
      {%- for k, v in opensds.dir.items() %}
      - {{ v }}
      {%- endfor %}
      - {{ golang.go_path }}/src/github.com/opensds/multi-cloud
    - makedirs: True
    - force: True
    - user: {{ opensds.user or 'root' }}
    - dir_mode: {{ opensds.dir_mode or '0755' }}
    - recurse:
      - user
      - mode

    {%- if opensds.gelato.container.enabled %}

opensds gelato container service running:
  docker_container.running:
    - name: {{ opensds.gelato.service }}
    - image: {{ opensds.gelato.container.image }}:{{ opensds.gelato.container.version }}
    - restart_policy: always
    - network_mode: host
         {%- if "volumes" in opensds.gelato.container %}
    - binds: {{ opensds.gelato.container.volumes }}
         {%- endif %}
         {%- if "ports" in opensds.gelato.container %}
    - ports: {{ opensds.gelato.container.ports }}
         {%- endif %}
         {%- if "port_bindings" in opensds.gelato.container %}
    - port_bindings: {{ opensds.gelato.container.port_bindings }}
         {%- endif %}
         {%- if docker.containers.skip_translate %}
    - skip_translate: {{ docker.containers.skip_translate }}
         {%- endif %}
         {%- if docker.containers.force_present %}
    - force_present: {{ docker.containers.force_present }}
         {%- endif %}
         {%- if docker.containers.force_running %}
    - force_running: {{ docker.containers.force_running }}
         {%- endif %}

    {%- else %}

include:
  - devstack.cli
  - opensds.gelato.repo
  - opensds.gelato.config

    {%- endif %}
  {%- endif %}
