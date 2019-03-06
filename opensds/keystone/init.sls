###  opensds/keystone/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{%- from "opensds/map.jinja" import opensds with context %}

{%- if "keystone" in opensds.hotpot.opensdsconf.osdslet.auth_strategy|lower %}

include:
  - devstack.user
  - opensds.keystone.conflicts.init
  - devstack.install
  {%- if grains.os_family == 'RedHat' %}
  - devstack.install       {# workaround https://github.com/saltstack-formulas/devstack-formula/issues/13 #}
  {%- endif %}
  - opensds.keystone.conflicts.clean

{%- else %}

opensds keystone init nothing to do:
  test.show_notification:
    - text: |
        Skipping keystone because `auth_strategy: noauth` (or something else) was configured!

{%- endif %}
