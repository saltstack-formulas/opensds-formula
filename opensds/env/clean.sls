# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

opensds ensure system profile file absent:
  file.absent:
    - name: /etc/profile.d/opensds.sh
