# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- set provider = opensds.dock.block.provider|trim|lower %}
  {%- if opensds.dock.block.container.enabled %}
    {%- if provider in ('lvm', 'ceph',) %}

opensds dock block {{ opensds.dock.block.provider }} container running:
  docker_container.running:
    - name: {{ opensds.dock.block.service }}
    - image: {{ opensds.dock.block.container.image }}
    - restart_policy: always
    - network_mode: host
    - unless: {{ opensds.dock.block.container.compose }}

    {%- elif opensds.dock.block.provider|trim|lower == 'cinder' %}

       {# Todo: Cinder-aaS https://github.com/openstack/cinder/tree/master/contrib/block-box #}

    {%- endif %}
  {%- else %}

include:
  - opensds.dock.block.config
  - opensds.dock.block[provider]

  {%- endif %}
