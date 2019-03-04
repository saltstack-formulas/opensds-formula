### opensds/init.sls

include:
  - opensds.infra
  - opensds.keystone
  - opensds.config
  - opensds.database
  - opensds.auth
  - opensds.hotpot
  - opensds.sushi
  - opensds.backend
  - opensds.dock
  - opensds.dashboard
  - opensds.gelato
  - opensds.freespace
