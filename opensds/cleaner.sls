### opensds/cleaner.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "opensds/map.jinja" import opensds with context %}

include:
  - opensds.auth.clean
  - opensds.dashboard.clean
  - opensds.dock.clean
  - opensds.database.clean
  - opensds.sushi.clean
  - opensds.gelato.clean
  - opensds.hotpot.clean
  - opensds.backend.clean
  - opensds.infra.clean

opensds cleaner profile absent:
  file.absent:
    - name: /etc/profile.d/opensds.sh
