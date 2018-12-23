### opensds/auth/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds, docker with context %}


    {%- if opensds.auth.container.enabled %}

opensds auth container service running:
  docker_container.running:
    - name: {{ opensds.auth.service }}
    - image: {{ opensds.auth.container.image }}:{{ opensds.auth.container.version }}
    - restart_policy: always
    - network_mode: host
         {%- if "volumes" in opensds.auth.container %}
    - binds: {{ opensds.auth.container.volumes }}
         {%- endif %}
         {%- if "ports" in opensds.auth.container %}
    - port_bindings: {{ opensds.auth.container.ports }}
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

    {% else %}

include:
  - devstack.user
  - devstack.install
  - devstack.cli

    {% endif %}


### opensds.conf ###
opensds auth ensure opensds dirs exist:
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

    #### update opensds.conf ####
opensds auth ensure opensds config file exists:
  file.managed:
    - name: {{ opensds.controller.conf }}
    - makedirs: True
    - user: {{ opensds.user or 'root' }}
    - mode: {{ opensds.file_mode or '0644' }}
    - replace: False

    {% for section, data in opensds.auth.opensdsconf.items() %}

opensds auth config ensure osdsauth {{ section }} section exists:
  ini.sections_present:
    - name: {{ opensds.controller.conf }}
    - sections:
      - {{ section }}

        {%- for k, v in data.items() %}

opensds auth config ensure osdsauth {{ section }} {{ k }} exists:
  ini.options_present:
    - name: {{ opensds.controller.conf }}
    - separator: '='
    - sections:
        {{ section }}:
          {{ k }}: {{ v }}
    - require:
      - opensds auth config ensure osdsauth {{ section }} section exists

        {%- endfor %}
    {% endfor %}
