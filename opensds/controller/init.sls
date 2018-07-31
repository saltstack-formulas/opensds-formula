# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if not opensds.controller.container.enabled %}

include:
  - opensds.controller.install.{{ opensds.controller.install_from|trim|lower }}

  #Update PATH
opensds controller {{ opensds.controller.release }} ensure system profile file exists:
  file.managed:
    - name: /etc/profile.d/opensds.sh
    - source: salt://opensds/files/opensds.sh
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - context:
      home: {{ opensds.dir.work }}

  {% endif %}
