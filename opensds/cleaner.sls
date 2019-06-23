### opensds/cleaner.sls
# -*- coding: utf-8 -*-
# vim: ft=sls

include:
  - opensds.auth.clean
  - opensds.dashboard.clean
  - opensds.dock.clean
  - opensds.database.clean
  - opensds.sushi.clean
  - opensds.gelato.clean
  - opensds.hotpot.clean
  - opensds.backend.clean
  - opensds.telemetry.clean
  - opensds.infra.clean
  - opensds.freespace
