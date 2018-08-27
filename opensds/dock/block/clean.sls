# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if opensds.dock.container.enabled %}
    {%- if opensds.dock.block.provider|trim|lower == ('lvm', 'ceph',) %}

opensds dock {{ opensds.dock.block.provider }} block service container stopped:
  docker_container.stopped:
    - names:
       - {{ opensds.dock.block.service }}
      {%- if opensds.dock.block.container.compose and "osdsblock" in docker.compose %}
       - {{ docker.compose.osdsblock.container_name }}
      {%- endif %}
    - error_on_absent: False

    {%- elif opensds.dock.block.provider|trim|lower == 'cinder' %}
     ## placeholder for Cinder-aaS https://github.com/openstack/cinder/tree/master/contrib/block-box

    {%- endif %}
  {%- elif opensds.dock.block.provider|trim|lower == 'lvm' %}

include:
  - lvm.vg.remove
  - lvm.pv.remove

  {%- elif opensds.dock.block.provider|trim|lower == 'cinder' %}
  #### cinder backend not implemented

  {%- elif opensds.dock.block.provider|trim|lower == 'ceph' %}
    {%- set ceph.use_upstream_repo == False %}

include:
  # deepsea.remove
  - ceph.repo

  {%- endif %}
