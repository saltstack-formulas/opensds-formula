###  opensds/stacks/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml

include:
  - .salt
  - .devstack
  - golang
  - packages.archives
  - docker.compose-ng
