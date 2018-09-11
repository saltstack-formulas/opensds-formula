###  opensds/nbp/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if opensds.nbp.container.enabled %}

opensds nbp {{ opensds.nbp.release }} container service stopped:
  nbper_container.stopped:
    - name: {{ opensds.nbp.service }}
    - error_on_absent: False

  {%- elif opensds.nbp.container.composed %}

include:
  - opensds.stacks.dockercompose.clean

  {% else %}

include:
  - opensds.nbp.provider.clean
  - opensds.nbp.{{ opensds.nbp.install_from }}.clean

  {% endif %}
