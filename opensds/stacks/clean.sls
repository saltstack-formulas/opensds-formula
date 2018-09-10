### stacks/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml

include:
  - opensds.stacks.profile.clean
  - devstack.remove
  - opensds.stacks.salt.clean
  - iscsi.initiator.clean
