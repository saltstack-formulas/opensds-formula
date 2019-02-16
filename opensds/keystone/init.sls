###  opensds/keystone/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml

include:
  - devstack.user
  - opensds.keystone.conflicts.init
  - devstack.install
  {%- if grains.os_family == 'RedHat' %}
  - devstack.install       {# workaround https://github.com/saltstack-formulas/devstack-formula/issues/13 #}
  {%- endif %}
  - opensds.keystone.conflicts.clean
