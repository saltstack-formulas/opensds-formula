# -*- coding: utf-8 -*-
# vim: ft=sls

openstack-opensds nginx conflict handler after stack.sh:
  cmd.run:
    - names:
      - docker container start dashboard
      - rm /tmp/opensds_stopped_dashboard
    - onlyif: test -f /tmp/opensds_stopped_dashboard

