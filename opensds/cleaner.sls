### opensds/cleaner.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds with context %}

include:
  - opensds.auth.clean
  - opensds.dashboard.clean
  - opensds.dock.clean
  - opensds.database.clean
  - opensds.let.clean
  - opensds.nbp.clean
  - opensds.stacks.clean

  {% if opensds.dock.provider|lower == "cinder" %}

opensds nbp {{ opensds.nbp.release }} block stop CinderaaS:
  cmd.run:
    - name: docker-compose down
    - cwd: {{ opensds.backend.cinder.data_dir }}/cinder/contrib/block-box

    {% for vg in opensds.backend.cinder.vg %}
opensds clean the {{ vg }} volume group of cinder:
  cmd.script:
    - source: salt://opensds/files/clean_lvm_vg.sh
    - context:
       cinder_volume_group: {{ vg }}
       cinder_data_dir: {{ opensds.backend.cinder.data_dir }}
    {% endfor %}

  {% endif %}
