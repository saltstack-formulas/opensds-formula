### opensds/let/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds, docker with context %}

    {%- if opensds.let.container.enabled %}

opensds let {{ opensds.controller.release }} container service running:
  docker_container.running:
    - name: {{ opensds.let.service }}
    - image: {{ opensds.let.container.image }}:{{ opensds.let.container.version }}
    - restart_policy: always
    - network_mode: host
         {%- if "volumes" in opensds.let.container %}
    - binds: {{ opensds.let.container.volumes }}
         {%- endif %}
         {%- if "ports" in opensds.let.container %}
    - port_bindings: {{ opensds.let.container.ports }}
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


### opensds.conf ###
opensds let ensure opensds dirs exist:
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

opensds let ensure opensds config file exists:
  file.managed:
    - name: {{ opensds.controller.conf }}
    - makedirs: True
    - user: {{ opensds.user or 'root' }}
    - mode: {{ opensds.file_mode or '0644' }}
    - replace: False

    {% for section, data in opensds.let.opensdsconf.items() %}

opensds let ensure opensds config {{ section }} section exists:
  ini.sections_present:
    - name: {{ opensds.controller.conf }}
    - sections:
      - {{ section }}

         {%- for k, v in data.items() %}
opensds let ensure opensds config {{ section }} {{ k }} exists:
  ini.options_present:
    - name: {{ opensds.controller.conf }}
    - separator: '='
    - sections:
        {{ section }}:
          {{ k }}: {{ v }}
    - require:
      - opensds let ensure opensds config {{ section }} section exists
        {%- endfor %}

    {%- endfor %}


  {%- if not opensds.let.container.enabled %}

opensds osdslet systemd service:
  file.managed:
    - name: {{ opensds.let['systemd']['file'] }}
    - source: salt://opensds/files/service.jinja
    - mode: '0644'
    - template: jinja
    - makedirs: True
    - context:
        svc: osdslet
        systemd: {{ opensds.let.systemd|json }}
        command: '{{opensds.dir.work}}/bin/osdslet >{{opensds.dir.log}}/osdslet.out 2>{{opensds.dir.log}}/osdslet.err'
  service.running:
    - name: osdslet
    - enable: True
    - watch:
      - file: opensds osdslet systemd service

  {%- endif %}
