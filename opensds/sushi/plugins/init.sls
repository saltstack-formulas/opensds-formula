###  opensds/sushi/plugins/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds, docker with context %}

    {%- set plugin = opensds.sushi.plugin_type %}
    {%- if opensds.sushi.plugins.container.enabled %}

opensds sushi plugins container service running:
  docker_container.running:
    - name: {{ opensds.sushi.plugins.service }}
    - image: {{opensds.sushi.plugins.container.image}}:{{opensds.sushi.plugins.container.version}}
    - restart_policy: always
    - network_mode: host
         {%- if "volumes" in opensds.sushi.plugins.container %}
    - binds: {{ opensds.sushi.plugins.container.volumes }}
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

    {% endif %}


### opensds.conf ###
opensds sushi ensure opensds dirs exist:
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

       {%- if plugin == 'flexvolume' %}

opensds sushi copy flexvolume plugin binary into flexvolume plugin dir:
  file.copy:
    - name: {{ opensds.sushi.plugins[plugin]['dir'] }}/opensds
    - source: {{ opensds.sushi.plugins[plugin]['binary'] }}
    - force: True
    - makedirs: True
    - user: {{ opensds.user or 'root' }}
    - mode: {{ opensds.file_mode or '0644' }}
    - onlyif: {{ plugin == 'flexvolume' }}

opensds sushi copy flexvolume plugin binary into flexvolume plugin dir:
  file.copy:
    - name: {{ opensds.sushi.plugins[plugin]['dir'] }}/opensds/
    - source: {{ opensds.sushi.plugins[plugin]['binary'] }}
    - force: True
    - makedirs: True
    - user: {{ opensds.user or 'root' }}
    - mode: {{ opensds.file_mode or '0644' }}
    - onlyif: {{ plugin == 'flexvolume' }}

       {%- elif plugin in ('csi', 'provisioner',) %}

opensds sushi plugins ensure opensds k8s {{ plugin }} plugin file exists:
  file.managed:
    - name: {{ opensds.sushi.plugins[plugin]['dir'] }}/{{ opensds.sushi.plugins[plugin]['conf'] }}
    - makedirs: True
    - user: {{ opensds.user or 'root' }}
    - mode: {{ opensds.file_mode or '0644' }}
    - replace: False

opensds sushi ensure correct endpoint in opensds k8s {{ plugin }} plugin:
  file.replace:
    - name: {{ opensds.sushi.plugins[plugin]['dir'] }}/{{ opensds.sushi.plugins[plugin]['conf'] }}
    - pattern: '^  opensdsendpoint.*$'
    - repl: '  opensdsendpoint: {{ opensds.auth.endpoint }}'
    - not_found_content: '  opensdsendpoint: {{ opensds.auth.endpoint }}'
    - append_if_not_found: True
    - backup: True
    - require:
      - opensds sushi plugins ensure opensds k8s {{ plugin }} plugin file exists
    - onlyif: {{ plugin != 'flexvolume' }}

opensds sushi ensure correct auth strategy in opensds k8s {{ plugin }} plugin:
  file.replace:
    - name: {{ opensds.sushi.plugins[plugin]['dir'] }}/{{ opensds.sushi.plugins[plugin]['conf'] }}
    - pattern: '^  opensdsauthstrategy.*$'
    - repl: '  opensdsauthstrategy: {{ opensds.auth.provider }}'
    - not_found_content: '  opensdsauthstrategy: {{ opensds.auth.provider }}'
    - append_if_not_found: True
    - backup: True
    - require:
      - opensds sushi plugins ensure opensds k8s {{ plugin }} plugin file exists
    - onlyif: {{ plugin != 'flexvolume' }}

opensds sushi ensure correct os auth url in opensds k8s {{ plugin }} plugin:
  file.replace:
    - name: {{ opensds.sushi.plugins[plugin]['dir'] }}/{{ opensds.sushi.plugins[plugin]['conf'] }}
    - pattern: '^  osauthurl.*$'
    - repl: '  osauthurl: {{ opensds.auth.opensdsconf.keystone_authtoken.auth_url }}'
    - not_found_content: '  osauthurl: {{ opensds.auth.opensdsconf.keystone_authtoken.auth_url }}'
    - append_if_not_found: True
    - backup: True
    - require:
      - opensds sushi plugins ensure opensds k8s {{ plugin }} plugin file exists
    - onlyif: {{ plugin != 'flexvolume' }}

   ## else

opensds sushi plugins k8s start:
  cmd.run:
    - name: {{ opensds.k8s.start }}
    - cwd: {{opensds.sushi.dir.work }}/{{ plugin }}
    - onlyif: test -f {{ opensds.k8s.start.split(' ') }}
    - output_loglevel: quiet
    - require:
      - opensds sushi plugins ensure opensds k8s {{ plugin }} plugin file exists

       {%- endif %} 
