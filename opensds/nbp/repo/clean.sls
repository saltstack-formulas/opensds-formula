### nbp/repo/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

opensds nbp repo {{ opensds.nbp.release.version }} remove directories:
  file.absent:
    - names:
      - {{ opensds.lang.home }}/{{ opensds.lang.src }}/nbp }}
  {% for type in ('csi', 'flexvolume', 'provisioner',) %}
      - {{ opensds.nbp.dir.work }}/{{ type }}{{ '/opensds' if type == 'flexvolume' else '' }}
  {% endfor }}
      - {{ opensds.nbp.dir.work }}/csi/
      - {{ opensds.nbp.dir.work }}/csi/
      - {{ opensds.nbp.dir.work }}/provisioner/
      - {{ opensds.nbp.dir.work }}/provisioner/
      - {{ opensds.nbp.dir.work }}/flexvolume/opensds/

