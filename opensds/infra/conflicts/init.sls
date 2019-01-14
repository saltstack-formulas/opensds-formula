# -*- coding: utf-8 -*-
# vim: ft=sls

openstack-opensds nginx conflict handler before stack.sh:
  cmd.run:
    - names:
      - docker container stop dashboard
      - touch /tmp/opensds_stopped_dashboard
    - onlyif: docker inspect dashboard >/dev/null 2>&1

