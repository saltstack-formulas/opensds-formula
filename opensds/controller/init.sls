### opensds/controller/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds, golang, docker, devstack with context %}


    {%- if opensds.controller.container.enabled %}

opensds controller container service running:
  docker_container.running:
    - name: {{ opensds.controller.service }}
    - image: {{opensds.controller.container.image}}:{{opensds.controller.container.version}}
    - restart_policy: always
    - network_mode: host
          {%- if "volumes" in opensds.controller.container %}
    - binds: {{ opensds.controller.container.volumes }}
          {%- endif %}
          {%- if "ports" in opensds.controller.container %}
    - port_bindings: {{ opensds.controller.container.ports }}
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

    {%- elif opensds.controller.provider|trim|lower in ('release', 'repo',) %}

include:
  {{ '- epel' if grains.os_family in ('Redhat',) else '' }}
  - packages.pips
  - packages.pkgs
  - packages.archives
  - golang
  - opensds.controller.{{ opensds.controller.provider|trim|lower }}

    {%- endif %}


### opensds.conf ###
opensds controller ensure opensds dirs exist:
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
      opensds_hotpot_release: {{ opensds.release.hotpot }}
