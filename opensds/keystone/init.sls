###  opensds/keystone/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml

include:
  - devstack.user
  - opensds.keystone.conflicts.init
  - devstack.install
  - opensds.keystone.conflicts.clean
