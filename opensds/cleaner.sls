### opensds/cleaner.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds with context %}

include:
  - opensds.auth.clean
  - opensds.dashboard.clean
  - opensds.dock.clean
  - opensds.database.clean
  - opensds.let.clean
  - opensds.sushi.clean
  - opensds.profile.clean
  - opensds.infra.clean
