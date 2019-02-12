## opensds/keystone/conflicts/clean
# -*- coding: utf-8 -*-
# vim: ft=sls

opensds keystone conflicts start nginx after devstack stack.sh:
  cmd.run:
    - names:
      - docker container start dashboard
      - rm /tmp/opensds_stopped_dashboard
    - onlyif: test -f /tmp/opensds_stopped_dashboard
