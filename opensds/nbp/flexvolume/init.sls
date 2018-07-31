# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds with context %}

opensds nbp {{ opensds.nbp.release.version}} ensure {{ opensds.nbp.plugin_type }} directory exists:
  file.directory:
    - names:
      - {{ opensds.nbp.dir.work }}
      - {{ opensds.nbp.dir[opensds.nbp.plugin_type] }}
    - makedirs: True
    - user: {{ opensds.nbp.dir.user }}
    - dir_mode: {{ opensds.nbp.dir.mode or '0755' }}
    - recurse:
      - user
      - mode
    - require_in:
      - opensds nbp {{ opensds.nbp.release.version}} copy {{ opensds.nbp.plugin_type }} binary to plugin dir 

opensds nbp {{ opensds.nbp.release.version }} copy {{ opensds.nbp.plugin_type }} binary to plugin dir:
  file.copy:
    - name: {{ opensds.nbp.dir[opensds.nbp.plugin_type] }}/opensds
    - source: {{ opensds.nbp.dir.work }}/{{ opensds.nbp.plugin_type }}/opensds
