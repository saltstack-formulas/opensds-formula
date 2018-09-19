###  opensds/salt/docker/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml

include:
  {{ '- epel' if grains.os_family in ('RedHat',) else '' }} 
  - docker
  - docker.compose-ng
