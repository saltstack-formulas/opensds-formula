### opensds/init.sls
include:
  - opensds.envs
  - opensds.controller
  - opensds.nbp
  - opensds.auth
  - opensds.database
  - opensds.let
  - opensds.dock
  - opensds.dashboard

