### opensds/dashboard/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds, docker with context %}

opensds dashboard disable other web servers:
  service.dead:
    - names:
      - apache2
    - enable: False

    {%- if opensds.dashboard.container.enabled %}

opensds dashboard container service running:
  cmd.run:
    - names:
      - mkdir -p /run/nginx 2>/dev/null
    - onlyif: {{ opensds.dashboard.container.enabled }}
  docker_container.running:
    - name: {{ opensds.dashboard.service }}
    - image: {{ opensds.dashboard.container.image }}:{{ opensds.dashboard.container.version}}
    - restart_policy: always
    - network_mode: host
         {%- if "volumes" in opensds.dashboard.container %}
    - binds: {{ opensds.dashboard.container.volumes }}
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

    {%- elif opensds.dashboard.provider|trim|lower in ('release', 'repo',) %}

include:
  {{ '- epel' if grains.os_family in ('Redhat',) else '' }}
  - packages.pips
  - packages.pkgs
  - packages.archives
  - apache.uninstall
  - opensds.dashboard.{{ opensds.dashboard.provider|trim|lower }}

opensds dashboard install angular cli:
  cmd.run:
    - name: npm install -g @angular/cli
    - onlyif: npm --version 2>/dev/null

    {%- endif %}


### opensds.conf ###
opensds dashboard ensure opensds dirs exist init:
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

opensds dashboard ensure opensds config file exists:
  file.managed:
    - name: {{ opensds.hotpot.conf }}
    - makedirs: True
    - user: {{ opensds.user or 'root' }}
    - mode: {{ opensds.file_mode or '0644' }}
    - replace: False

        {% for section, data in opensds.dashboard.opensdsconf.items() %}

opensds dashboard config ensure dashboard {{ section }} section exists:
  ini.sections_present:
    - name: {{ opensds.hotpot.conf }}
    - sections:
      - {{ section }}

            {%- for k, v in data.items() %}
opensds dashboard config ensure dashboard {{ section }} {{ k }} exists:
  ini.options_present:
    - name: {{ opensds.hotpot.conf }}
    - separator: '='
    - sections:
        {{ section }}:
          {{ k }}: {{ v }}
    - require:
      - opensds dashboard config ensure dashboard {{ section }} section exists
            {%- endfor %}
        {% endfor %}
