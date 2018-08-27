# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

# Update system profile path
opensds lang {{ opensds.controller.release }} set system profile path:
  file.managed:
    - name: /etc/profile.d/opensds.sh
    - source: salt://opensds/files/profile.sh
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - onlyif: test -f {{ opensds.lang.home }}/bin/go
    - context:
      langhome: {{ opensds.lang.home }}
      sdshome: {{ opensds.dir.work }}
