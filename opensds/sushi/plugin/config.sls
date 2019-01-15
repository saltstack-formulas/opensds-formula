###  opensds/sushi/plugin/config.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds, driver with context %}

include:
  - opensds.config

  {%- for instance in opensds.sushi.instances %}

         ##############################
         #### OpenSDS opensds.conf ####
         ##############################
     {%- if instance in opensds.sushi.opensdsconf %}
        {%- set plugin = opensds.sushi.opensdsconf[ instance|string ] %}

opensds sushi plugin {{ instance }} ensure opensds config {{ instance }} section exists:
  ini.sections_present:
    - name: {{ opensds.hotpot.conf }}
    - sections:
      - {{ instance }}
    - require:
      - file: opensds config ensure opensds conf exists

         {%- for k, v in plugin.items() %}

opensds sushi plugin {{ instance }} ensure opensds config {{ instance }} {{ k }} exists:
  ini.options_present:
    - name: {{ opensds.hotpot.conf }}
    - require:
      - file: opensds config ensure opensds conf exists
    - sections:
        {{ instance }}:
          {{ k }}: {{ v }}
    - separator: '='

         {%- endfor %}
     {%- endif %}

          ###################################
          #### Plugin directory and file ####
          ###################################
     {%- if "plugins" in opensds.sushi.plugin and instance in opensds.sushi.plugin.plugins %}
        {%- set plugin = opensds.sushi.plugin.plugins[ instance|string ] %}

opensds sushi plugin {{ instance }} copy into plugin dir:
  file.copy:
    - name: {{ plugin['dir'] }}/opensds/
    - source: {{ plugin['file'] }}
    - force: True
    - makedirs: True
    - user: {{ opensds.user or 'root' }}
    - mode: {{ opensds.file_mode or '0644' }}
    - onlyif: {{ instance|lower in ('flexvolume',) }}

opensds sushi plugin {{ instance }} ensure opensds k8s plugin file exists:
  file.managed:
    - name: {{ plugin['dir'] }}/{{ plugin['file'] }}
    - user: {{ opensds.user or 'root' }}
    - mode: {{ opensds.file_mode or '0644' }}
    - replace: False
    - onlyif: {{ instance|lower in ('csi', 'provisioner',) }}

opensds sushi plugin {{ instance }} set endpoint in opensds k8s plugin file:
  file.replace:
    - name: {{ plugin['dir'] }}/{{ plugin['file'] }}
    - pattern: '^  opensdsendpoint.*$'
    - repl: '  opensdsendpoint: {{ opensds.auth.daemon.osdsauth.endpoint_ipv4 }}:{{ opensds.auth.daemon.osdsauth.endpoint_port }}'
    - not_found_content: '  opensdsendpoint: {{ opensds.auth.daemon.osdsauth.endpoint_ipv4 }}:{{ opensds.auth.daemon.osdsauth.endpoint_port }}'
    - append_if_not_found: True
    - backup: True
    - require:
      - file: opensds sushi plugin {{ instance }} ensure opensds k8s plugin file exists
    - onlyif: {{ instance|lower in ('csi', 'provisioner',) }}

opensds sushi plugin {{ instance }} set auth strategy in opensds k8s plugin file:
  file.replace:
    - name: {{ plugin['dir'] }}/{{ plugin['file'] }}
    - pattern: '^  opensdsauthstrategy.*$'
    - repl: '  opensdsauthstrategy: {{ opensds.auth.daemon.osdsauth.strategy }}'
    - not_found_content: '  opensdsauthstrategy: {{ opensds.auth.daemon.osdsauth.strategy }}'
    - append_if_not_found: True
    - backup: True
    - require:
      - file: opensds sushi plugin {{ instance }} ensure opensds k8s plugin file exists
    - onlyif: {{ instance|lower in ('csi', 'provisioner',) }}

opensds sushi plugin {{ instance }} set auth url in opensds k8s plugin file:
  file.replace:
    - name: {{ plugin['dir'] }}/{{ plugin['file'] }}
    - pattern: '^  osauthurl.*$'
    - repl: '  osauthurl: {{ opensds.auth.opensdsconf.osdsauth.keystone_authtoken.auth_url }}'
    - not_found_content: '  osauthurl: {{ opensds.auth.opensdsconf.osdsauth.keystone_authtoken.auth_url }}'
    - append_if_not_found: True
    - backup: True
    - require:
      - file: opensds sushi plugin {{ instance }} ensure opensds k8s plugin file exists
    - onlyif: {{ instance|lower in ('csi', 'provisioner',) }}

     {%- endif %}
  {%- endfor %}
