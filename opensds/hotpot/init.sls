### opensds/hotpot/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds, golang, docker, devstack with context %}


  {%- if opensds.deploy_project not in ('gelato',) %}
    {%- if opensds.hotpot.container.enabled %}

opensds hotpot container service running:
  docker_container.running:
    - name: {{ opensds.hotpot.service }}
    - image: {{opensds.hotpot.container.image}}:{{opensds.hotpot.container.version}}
    - restart_policy: always
    - network_mode: host
         {%- if "volumes" in opensds.hotpot.container %}
    - binds: {{ opensds.hotpot.container.volumes }}
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

    {%- elif opensds.hotpot.provider|trim|lower in ('release', 'repo',) %}

include:
  {{ '- epel' if grains.os_family in ('Redhat',) else '' }}
  - packages.pips
  - packages.pkgs
  - packages.archives
  - golang
  - opensds.hotpot.{{ opensds.hotpot.provider|trim|lower }}

    {%- endif %}


### opensds.conf ###
opensds hotpot ensure opensds dirs exist:
  file.directory:
    - names:
      {%- for k, v in opensds.dir.items() %}
      - {{ v }}
      {%- endfor %}
    - makedirs: True
    - force: True
    - user: {{ opensds.user or 'root' }}
    - dir_mode: {{ opensds.dir_mode or '0755' }}
    - recurse:
      - user
      - mode


### sdsrc
opensds sdrc file generated:
  file.managed:
    - name: {{ opensds.dir.work }}/sdsrc
    - source: salt://opensds/files/sdsrc.jinja
    - makedirs: True
    - template: jinja
    - user: {{ opensds.user or 'root' }}
    - mode: {{ opensds.file_mode or '0644' }}
    - context:
      go_path: {{ golang.go_path }}
      devstack: {{ devstack }}
      opensds: {{ opensds }}

  {%- endif %}
