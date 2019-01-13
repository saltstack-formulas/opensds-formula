###  opensds/sushi/plugins/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds with context %}

    {%- set plugin = opensds.sushi.plugin_type %}
    {%- if opensds.sushi.plugins.container.enabled %}

opensds sushi plugins container service stopped:
  docker_container.stopped:
    - name: {{ opensds.sushi.plugins.service }}
    - error_on_absent: False

    {%- else %}

opensds sushi plugins {{ plugin }} k8s stop:
  cmd.run:
    - name: {{ opensds.k8s.stop }}
    - onlyif: test -f {{ opensds.k8s.stop.split(' ') }}
    - cwd:  {{ opensds.sushi.dir[plugin] }}
    - output_loglevel: quiet 

opensds sushi plugins stop service:
  service.dead:
    - name: {{ opensds.sushi.service }}
    - sig: {{ opensds.sushi.service }}

         {%- for plugin in opensds.sushi.plugins %}
opensds sushi plugins {{ plugin }} clean plugin dir:
  file.absent:
    - name: {{ opensds.sushi.plugins[plugin] }}
    - require:
      - opensds sushi stop service
      - opensds sushi {{ plugin }} k8s stop
         {%- endfor %}
    {%- endif %}
