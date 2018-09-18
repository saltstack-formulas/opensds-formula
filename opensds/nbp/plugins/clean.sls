###  opensds/nbp/plugins/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds with context %}

    {%- set plugin = opensds.nbp.plugin_type %}
    {%- if opensds.nbp.plugins.container.enabled %}
        {%- if opensds.nbp.plugins.container.composed %}

include:
  - opensds.envs.docker.clean

        {#- elif opensds.nbp.plugins.container.build #}
        {%- else %}

opensds nbp plugins container service stopped:
  docker_container.stopped:
    - name: {{ opensds.nbp.plugins.service }}
    - error_on_absent: False

        {%- endif %}
    {%- else %}

opensds nbp plugins {{ plugin }} k8s stop:
  cmd.run:
    - name: {{ opensds.k8s.stop }}
    - onlyif: test -f {{ opensds.k8s.stop.split(' ') }}
    - cwd:  {{ opensds.nbp.dir[plugin] }}
    - output_loglevel: quiet 

opensds nbp plugins stop service:
  service.dead:
    - name: {{ opensds.nbp.service }}
    - sig: {{ opensds.nbp.service }}

         {%- for plugin in opensds.nbp.plugins %}

opensds nbp plugins {{ plugin }} clean plugin dir:
  file.absent:
    - name: {{ opensds.nbp.plugins[plugin] }}
    - require:
      - opensds nbp stop service
      - opensds nbp {{ plugin }} k8s stop

         {%- endfor %}
    {%- endif %}
