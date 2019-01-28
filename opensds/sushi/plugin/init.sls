###  opensds/sushi/plugin/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

  {%- if opensds.deploy_project not in ('gelato',)  %}

include:
  - opensds.sushi.plugin.config
  - opensds.sushi.daemon

     {%- for instance in opensds.sushi.instances %}
        {%- if "plugins" in opensds.sushi and instance in opensds.sushi.plugins %}

          {%- set plugin = opensds.sushi.plugins[ instance|string ] %}
          ##############################
          #### sushi deploy scripts ####
          ##############################
          {%- if instance in ('csi', 'provisioner',) %}

opensds sushi plugin copy {{ instance }} deploy scripts to workdir:
   file.copy:
    - name: {{ opensds.dir.sushi }}/{{ instance }}/
    - source: {{ golang.go_path }}/github.com/opensds/{{ instance }}/deploy
    - force: True
    - makedirs: True
    - user: {{ opensds.user or 'root' }}
    - mode: {{ opensds.file_mode or '0644' }}

opensds sushi plugin copy {{ instance }} deploy scripts to workdir:
   file.copy:
    - name: {{ opensds.dir.sushi }}/{{ instance }}/
    - source: {{ golang.go_path }}/github.com/opensds/{{ instance }}/examples
    - force: True
    - makedirs: True
    - user: {{ opensds.user or 'root' }}
    - mode: {{ opensds.file_mode or '0644' }}

          {%- elif instance in ('flexvolume',) %}

opensds sushi copy {{ instance }} binary into flexvolume plugin dir:
  file.copy:
    - name: {{ plugin.dir }}/opensds/
    - source: {{ plugin.file }}
    - force: True
    - makedirs: True
    - user: {{ opensds.user or 'root' }}
    - mode: {{ opensds.file_mode or '0644' }}

          {%- endif %}
       {%- endif %}
    {%- endfor %}
  {%- endif %}
