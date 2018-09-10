### stacks/profile/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  # remove system profile
opensds stacks profile ensure system profile file absent:
  file.absent:
    - name: /etc/profile.d/opensds.sh
