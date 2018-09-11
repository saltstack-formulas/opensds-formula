### opensds/profile/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

opensds profile set system profile path:
  file.managed:
    - name: /etc/profile.d/opensds.sh
    - source: salt://opensds/files/profile.j2
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    # onlyif: test -f {{ opensds.stacks.lang.home }}/bin/go
    - context:
      langhome: {{ opensds.stacks.lang.home }}
      sdshome: {{ opensds.dir.work }}
