###  opensd/dock/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds, docker with context %}

    {%- if opensds.dock.container.enabled %}
       {%- if opensds.dock.container.composed %}

include:
  - opensds.envs.docker

       {#- elif opensds.dock.container.build #}
       {%- else %}

opensds dock container service running:
  docker_container.running:
    - name: {{ opensds.dock.service }}
    - image: {{ opensds.dock.container.image }}
    - restart_policy: always
    - network_mode: host
          {%- if "volumes" in opensds.dock.container %}
    - binds: {{ opensds.dock.container.volumes }}
          {%- endif %}
          {%- if "ports" in opensds.dock.container %}
    - port_bindings: {{ opensds.dock.container.ports }}
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

       {%- endif %}
    {%- endif %}
    {%- if opensds.dock.block.enabled %}

include:
  - opensds.dock.block

opensds dock ensure opensds dirs exist:
  file.directory:
    - names:
      {%- for k, v in opensds.dir.items() if v not in ('root', '700', '0700',) %}
      - {{ v }}
      {%- endfor %}
    - makedirs: True
    - force: True
    - user: {{ opensds.user or 'root' }}
    - dir_mode: {{ opensds.dir_mode or '0755' }}
    - recurse:
      - user
      - mode

       #### update opensds.conf ####
opensds dock ensure opensds config file exists:
  file.managed:
    - name: {{ opensds.controller.conf }}
    - makedirs: True
    - user: {{ opensds.user or 'root' }}
    - mode: {{ opensds.file_mode or '0644' }}

       {% for section, data in opensds.dock.opensdsconf.items() %}

opensds dock ensure opensds config {{ section }} section exists:
  ini.sections_present:
    - name: {{ opensds.controller.conf }}
    - sections:
      - {{ section }}

            {%- for k, v in data.items() %}
opensds dock ensure opensds config {{ section }} {{ k }} exists:
  ini.options_present:
    - name: {{ opensds.controller.conf }}
    - separator: '='
    - sections:
        {{ section }}:
          {{ k }}: {{ v }}
    - require:
      - opensds dock ensure opensds config {{ section }} section exists
            {%- endfor %}

       {%- endfor %}
    {%- endif %}
