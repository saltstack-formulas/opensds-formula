###  opensds/dashboard/config/nginx.sls
# -*- coding: utf-8 -*-
# vim: ft=sls

include:
  - nginx.ng

opensds dashboard config custom ensure nginx stopped:
  service.dead:
    - name: nginx

opensds dashboard config custom ensure nginx disabled:
  service.disabled:
    - name: nginx
