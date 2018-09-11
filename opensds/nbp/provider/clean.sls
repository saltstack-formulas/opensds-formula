###  nbp/provider/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds with context %}

  {%- if not opensds.nbp.container.enabled %}

opensds nbp {{ opensds.nbp.provider }} {{ opensds.nbp.release.version }} k8s stop:
  cmd.run:
    - name: {{ opensds.k8s_stop }}
    - onlyif: {{ test -f opensds.k8s_stop }}
    - cwd:  {{ opensds.nbp.dir[opensds.nbp.provider] }}
    - output_loglevel: quiet 

opensds nbp {{ opensds.nbp.release }} stop daemon service:
  service.dead:
    - name: {{ opensds.nbp.service }}
    - sig: {{ opensds.nbp.service }}

     {%- for plugintype in opensds.nbp.plugin.types %}

opensds nbp {{ opensds.nbp.release.version}} {{ plugintype }} clean plugin dir:
  file.absent:
    - names:
      - {{ opensds.nbp.plugin[plugintype] }}
    - require:
      - opensds nbp {{ opensds.nbp.release }} stop daemon service
      - opensds nbp {{ plugintype }} {{ opensds.nbp.release.version }} k8s stop

     {% endfor %}

  {%- endif %}
