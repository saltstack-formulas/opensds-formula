### opensds/salt/devstack/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml

include:
  - devstack.user          #https://github.com/saltstack-formulas/devstack-formula
  - devstack.install
  - devstack.cli
