###  opensds/salt/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml

include:
  - packages.pips
  - packages.pkgs
  - packages.archives
  - opensds.envs.docker
  - opensds.envs.profile
  - devstack.user          #https://github.com/saltstack-formulas/devstack-formula
  - devstack.install
  - devstack.cli
