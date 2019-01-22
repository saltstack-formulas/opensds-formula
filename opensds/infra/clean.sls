### opensds/infra/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

include:
  # golang.remove
  # devstack.remove
  - opensds.infra.profile.clean
  - memcached.uninstall

  {%- if opensds.pkgs %}

opensds infra ensure required packages removed:
  pkg.purged:
    - names: {{ opensds.pkgs }}

  {%- endif %}
