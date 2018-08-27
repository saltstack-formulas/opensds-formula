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

opensds nbp {{ opensds.nbp.release }} stop daemon service:
  service.dead:
    - name: {{ opensds.nbp.service }}
    - sig: {{ opensds.nbp.service }}

    {%- for type in ('csi', 'flexvolume', 'provisioner',) %}

opensds nbp {{ opensds.nbp.release}} clean {{ type }} release files:
  file.absent:
    - name: {{ opensds.nbp.dir.work }}/{{ type }}
    - require:
      - service: opensds nbp {{ opensds.nbp.release }} stop daemon service

    {% endfor %}

  {% endif %}
