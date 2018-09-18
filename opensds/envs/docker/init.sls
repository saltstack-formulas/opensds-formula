###  opensds/salt/docker/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml

include:
  # docker.remove     #https://github.com/saltstack-formulas/docker-formula
  - docker
  - docker.compose-ng
