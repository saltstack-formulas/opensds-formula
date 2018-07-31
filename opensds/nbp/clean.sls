# -*- coding: utf-8 -*-
# vim: ft=sls
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if opensds.nbp.container.enabled and "nbp" in docker.compose and docker.compose.nbp.container_name is defined %}

opensds nbp container service stopped:
  docker_container.stopped:
    - names:
       - docker.compose.nbp.container_name

  {%- else %}

opensds nbp stop daemon service:
  service.dead:
    - name: {{ opensds.nbp.service }}
    - sig: {{ opensds.nbp.service }}
    - require_in:
      - file: opensds nbp clean {{ opensds.nbp.dir.work }} release files

opensds nbp clean {{ opensds.nbp.dir.work }} release files:
  file.absent:
    - names:
      - {{ opensds.nbp.dir/work }}/csi
      - {{ opensds.nbp.dir/work }}/flexvolume
      - {{ opensds.nbp.dir/work }}/provisioner

  {% endif %}
