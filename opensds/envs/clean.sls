### opensds/salt/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml

include:
  # opensds.envs.docker.clean
  # golang.remove
  - devstack.remove
  - opensds.envs.profile.clean
