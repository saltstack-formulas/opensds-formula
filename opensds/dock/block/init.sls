# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if opensds.dock.block.container.enabled %}
    {%- if opensds.dock.block.provider|trim|lower == ('lvm', 'ceph',) %}

opensds dock {{ opensds.dock.block.provider }} block service container running:
  docker_container.running:
    - name: {{ opensds.dock.block.service }}
    - image: {{ opensds.dock.block.container.image }}
    - restart_policy: always
    - network_mode: host
    - unless: {{ opensds.dock.block.container.compose }}

    {%- elif opensds.dock.block.provider|trim|lower == 'cinder' %}
     ## placeholder for Cinder-aaS https://github.com/openstack/cinder/tree/master/contrib/block-box

    {%- endif %}
  {%- elif opensds.dock.block.provider|trim|lower == 'lvm' %}

include:
  - lvm.pv.create
  - lvm.vg.create

  {%- elif opensds.dock.block.provider|trim|lower == 'cinder' %}
   ## placeholder for future local cinder service

  {%- elif opensds.dock.block.provider|trim|lower == 'ceph' %}
   ## placeholder for future local ceph service

include:
  - ceph.repo
  # deepsea

  {%- endif %}
