###  stacks/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml

include:
  - opensds.stacks.salt
  - packages.archives.install
  - opensds.stacks.golang
  - opensds.stacks.profile
  - devstack.install
  - docker.compose-ng
  - iscsi.initiator
