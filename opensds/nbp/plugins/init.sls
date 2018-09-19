###  opensds/nbp/plugins/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

    {%- set plugin = opensds.nbp.plugin_type %}
    {%- if opensds.nbp.plugins.container.enabled %}
        {%- if opensds.nbp.plugins.container.composed %}

include:
  - opensds.envs.docker

        {#- elif opensds.nbp.plugins.container.build #}
        {%- else %}

opensds nbp plugins container service running:
  docker_container.running:
    - name: {{ opensds.nbp.plugins.service }}
    - image: {{ opensds.nbp.plugins.container.image }}
    - restart_policy: always
    - network_mode: host
           {%- if "volumes" in opensds.nbp.plugins.container %}
    - binds: {{ opensds.nbp.plugins.container.volumes }}
           {%- endif %}
           {%- if "ports" in opensds.nbp.plugins.container %}
    - port_bindings: {{ opensds.nbp.plugins.container.ports }}
           {%- endif %}

        {% endif %}
    {%- else %}

## workaround salt/issues/49712
opensds nbp ensure opensds dirs exist:
  file.directory:
    - names:
      {%- for k, v in opensds.dir.items() if v not in ('root', '700', '0700',) %}
      - {{ v }}
      {%- endfor %}
    - makedirs: True
    - force: True
    - dir_mode: '0755'

       {%- if plugin == 'flexvolume' %}

opensds nbp copy flexvolume plugin binary into flexvolume plugin dir:
  file.copy:
    - name: {{ opensds.nbp.plugins[plugin]['dir'] }}/opensds
    - source: {{ opensds.nbp.plugins[plugin]['binary'] }}
    - force: True
    - makedirs: True
    - mode: 0755
    - onlyif: {{ plugin == 'flexvolume' }}

opensds nbp copy flexvolume plugin binary into flexvolume plugin dir:
  file.copy:
    - name: {{ opensds.nbp.plugins[plugin]['dir'] }}/opensds/
    - source: {{ opensds.nbp.plugins[plugin]['binary'] }}
    - force: True
    - makedirs: True
    - mode: 0755
    - onlyif: {{ plugin == 'flexvolume' }}

       {%- else %}

opensds nbp plugins ensure opensds k8s {{ plugin }} plugin file exists:
  file.managed:
    - name: {{ opensds.nbp.plugins[plugin]['dir'] }}/{{ opensds.nbp.plugins[plugin]['conf'] }}
    - makedirs: True
    - mode: '0755'

opensds nbp ensure correct endpoint in opensds k8s {{ plugin }} plugin:
  file.replace:
    - name: {{ opensds.nbp.plugins[plugin]['dir'] }}/{{ opensds.nbp.plugins[plugin]['conf'] }}
    - pattern: '^  opensdsendpoint.*$'
    - repl: '  opensdsendpoint: {{ opensds.auth.endpoint }}'
    - not_found_content: '  opensdsendpoint: {{ opensds.auth.endpoint }}'
    - append_if_not_found: True
    - backup: True
    - require:
      - opensds nbp plugins ensure opensds k8s {{ plugin }} plugin file exists
    - onlyif: {{ plugin != 'flexvolume' }}

opensds nbp ensure correct auth strategy in opensds k8s {{ plugin }} plugin:
  file.replace:
    - name: {{ opensds.nbp.plugins[plugin]['dir'] }}/{{ opensds.nbp.plugins[plugin]['conf'] }}
    - pattern: '^  opensdsauthstrategy.*$'
    - repl: '  opensdsauthstrategy: {{ opensds.auth.provider }}'
    - not_found_content: '  opensdsauthstrategy: {{ opensds.auth.provider }}'
    - append_if_not_found: True
    - backup: True
    - require:
      - opensds nbp plugins ensure opensds k8s {{ plugin }} plugin file exists
    - onlyif: {{ plugin != 'flexvolume' }}

opensds nbp ensure correct os auth url in opensds k8s {{ plugin }} plugin:
  file.replace:
    - name: {{ opensds.nbp.plugins[plugin]['dir'] }}/{{ opensds.nbp.plugins[plugin]['conf'] }}
    - pattern: '^  osauthurl.*$'
    - repl: '  osauthurl: {{ opensds.auth.opensdsconf.keystone_authtoken.auth_url }}'
    - not_found_content: '  osauthurl: {{ opensds.auth.opensdsconf.keystone_authtoken.auth_url }}'
    - append_if_not_found: True
    - backup: True
    - require:
      - opensds nbp plugins ensure opensds k8s {{ plugin }} plugin file exists
    - onlyif: {{ plugin != 'flexvolume' }}

       {%- endif %} 

opensds nbp plugins k8s start:
  cmd.run:
    - name: {{ opensds.k8s.start }}
    - cwd: {{opensds.nbp.dir.work }}/{{ plugin }}
    - onlyif: test -f {{ opensds.k8s.start.split(' ') }}
    - output_loglevel: quiet
    - require:
      - opensds nbp plugins ensure opensds k8s {{ plugin }} plugin file exists

    {%- endif %}
