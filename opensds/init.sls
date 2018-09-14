### opensds/init.sls
include:
  - opensds.salt
  - opensds.profile
  - opensds.controller
  - opensds.nbp
  - opensds.auth
  - opensds.database
  - opensds.let
  - opensds.dock
  - opensds.dashboard

