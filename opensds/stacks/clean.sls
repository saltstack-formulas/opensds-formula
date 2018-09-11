### opensds/stacks/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml

include:
  # docker.compose-ng.down
  # .golang.remove
  - .devstack.clean
  - .salt.clean
