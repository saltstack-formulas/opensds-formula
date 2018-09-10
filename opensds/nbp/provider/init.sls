###   nbp/provider/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds with context %}

include:
  - opensds.nbp.config

opensds nbp {{ opensds.nbp.plugin_type }} {{ opensds.nbp.release.version }} k8s start:
  cmd.run:
    - name: {{ opensds.k8s_start }}
    - onlyif: {{ test -f opensds.k8s_start }}
    - cwd:  {{ opensds.nbp.dir[opensds.nbp.plugin_type] }}
    - output_loglevel: quiet 
