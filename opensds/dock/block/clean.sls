###  dock/block/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- set provider = opensds.dock.block.provider|trim|lower %}
  {%- if opensds.dock.block.container.enabled %}
    {%- if provider in ('lvm', 'ceph',) %}

opensds dock {{ opensds.dock.block.provider }} block service container stopped:
  docker_container.stopped:
    - names: {{ opensds.dock.block.service }}
    - error_on_absent: False

    {%- elif provider == 'cinder' %}

       {# Todo: Cinder-aaS https://github.com/openstack/cinder/tree/master/contrib/block-box #}

    {%- endif %}
  {%- else %}

include:
  - opensds.dock.block[provider]['clean']

  {%- endif %}
