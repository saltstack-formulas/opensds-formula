### opensds/init.sls
include:
  {{ '- epel' if grains.os_family in ('RedHat',) else '' }}  
  - opensds.envs
  - opensds.controller
  - opensds.nbp
  - opensds.auth
  - opensds.database
  - opensds.let
  - opensds.dock
  - opensds.dashboard

