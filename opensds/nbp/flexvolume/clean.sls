# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds with context %}

opensds nbp {{ opensds.nbp.release.version}} {{ opensds.nbp.plugin_type }} clean plugin dir:
  file.absent:
    - name: {{ opensds.nbp.dir[opensds.nbp.plugin_type] }}/opensds
