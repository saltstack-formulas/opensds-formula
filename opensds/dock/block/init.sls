# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

include:
  {%- if opensds.dock.block.container.enabled and not opensds.dock.block.container.compose %}

    {%- if opensds.dock.block.provider|trim|lower == 'cinder' %}
        #Cinder-as-a-Service uses https://github.com/openstack/cinder/tree/master/contrib/block-box
    {%- endif %}

  {%- else %}

  - opensds.dock.block.{{ opensds.dock.block.driver }}

  {%- endif %}
