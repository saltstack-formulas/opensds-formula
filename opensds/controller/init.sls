### opensds/controller/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds, golang, devstack with context %}

    {%- if opensds.controller.container.enabled %}
       {%- if opensds.controller.container.composed %}

include:
  - opensds.envs.docker

       {#- if opensds.controller.container.build #}
       {%- else %}

opensds controller container service running:
  docker_container.running:
    - name: {{ opensds.controller.service }}
    - image: {{ opensds.controller.container.image }}
    - restart_policy: always
    - network_mode: host
           {%- if "volumes" in opensds.controller.container %}
    - binds: {{ opensds.controller.container.volumes }}
           {%- endif %}
           {%- if "ports" in opensds.controller.container %}
    - port_bindings: {{ opensds.controller.container.ports }}
           {%- endif %}

       {%- endif %}
    {%- elif opensds.controller.provider|trim|lower in ('release', 'repo',) %}

include:
  {{ '- epel' if grains.os_family in ('Redhat',) else '' }}
  - packages.pips
  - packages.pkgs
  - packages.archives
  - golang
  - opensds.controller.{{ opensds.controller.provider|trim|lower }}

## workaround salt/issues/49712
opensds controller ensure opensds dirs exist:
  file.directory:
    - names:
      {%- for k, v in opensds.dir.items() if v not in ('root', '700', '0700',) %}
      - {{ v }}
      {%- endfor %}
    - makedirs: True
    - force: True
    - dir_mode: '0755'

### sdsrc
opensds sdrc file generated:
  file.managed:
    - name: {{ opensds.dir.work }}/sdsrc
    - source: salt://opensds/files/sdsrc.jinja
    - makedirs: True
    - template: jinja
    - context:
      go_path: {{ golang.go_path }}
      devstack: {{ devstack }}
      opensds_hotpot_release: {{ opensds.release.hotpot }}
    {% endif %}
