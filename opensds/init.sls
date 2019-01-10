### opensds/init.sls
include:
  {{ '- epel' if grains.os_family in ('RedHat',) else '' }}  
  - opensds.infra
  - opensds.hotpot
  - opensds.sushi
  - opensds.auth
  - opensds.database
  - opensds.let
  - opensds.dock
  - opensds.dashboard
  - opensds.gelato
