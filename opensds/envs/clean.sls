### opensds/salt/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml

include:
  # golang.remove
  - devstack.remove
  - opensds.envs.profile.clean
  - memcached.uninstall
