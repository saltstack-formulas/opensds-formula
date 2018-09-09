# -*- coding: utf-8 -*-
# vim: ft=sls
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if opensds.nbp.container.enabled %}

opensds nbp {{ opensds.nbp.release }} container service stopped:
  nbper_container.stopped:
    - names:
       - {{ opensds.nbp.service }}
      {%- if opensds.nbp.container.compose and "osdsnbp" in docker.compose %}
       - {{ docker.compose.osdsnbp.container_name }}
      {%- endif %}
    - error_on_absent: False

  {% else %}

include:
  - opensds.nbp.provider.clean
  - opensds.nbp.{{ opensds.nbp.install_from }}.clean

  {% endif %}
