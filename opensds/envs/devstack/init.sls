### opensds/salt/devstack/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml

include:
  {{ '- packages.pkgs' if grains.os_family in ('RedHat',) else '' }}
  - mysql.server
  - devstack.user          #https://github.com/saltstack-formulas/devstack-formula
  - devstack.install
  - devstack.cli
